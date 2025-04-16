import os
from flask import Flask, request, jsonify
import oracledb
import re
from langchain.chains import create_sql_query_chain
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_community.utilities import SQLDatabase
from langchain_community.tools import QuerySQLDatabaseTool
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import PromptTemplate
from langchain_core.runnables import RunnablePassthrough, RunnableLambda
from operator import itemgetter
from flask_cors import CORS

# Google API 키 설정
os.environ["GOOGLE_API_KEY"] = "AIzaSyDsln7DVGpc5ZFks2jntz1ftion8Y2zQbU"

# Flask 앱 생성
app = Flask(__name__)
CORS(app)

# Oracle DB 연결 정보
ORACLE_URI = "oracle+oracledb://admin:test%2123%24@team3.ccxwnfpmkcwn.ap-northeast-2.rds.amazonaws.com:1521/orcl"
db = SQLDatabase.from_uri(
    ORACLE_URI,
    include_tables=["review"],
    schema="ADMIN")

# LangChain LLM 설정
gemini_llm = ChatGoogleGenerativeAI(model="gemini-1.5-flash")
gemini_sql = create_sql_query_chain(llm=gemini_llm, db=db)
query_excecuter = QuerySQLDatabaseTool(db=db)

# 정규식 기반 SQL 추출 함수
def extract_sql(text):
    pattern = r"SQLQuery:\s*(SELECT[\s\S]+?)(?:```|$)"
    match = re.search(pattern, text)
    if match:
        query = match.group(1).replace('"', '')
        return query
    return None

# 한글 alias 처리 함수
def fix_alias_quotes(sql: str) -> str:
    return re.sub(r'AS\s+([가-힣\d\s]+)', r'AS "\1"', sql)

@app.route('/query', methods=['POST'])
def query_sql():
    data = request.json
    question = data.get("question")
    
    if not question:
        return jsonify({"error": "질문이 필요합니다."}), 400
    
    gemini_query = gemini_sql.invoke({"question": question})
    query = extract_sql(gemini_query)
    if not query:
        return jsonify({"error": "SQL 변환 실패"}), 500
    
    query = fix_alias_quotes(query.rstrip(";"))
    result = db.run(query)
    return jsonify({"query": query, "result": result})

# SQL 실행 결과를 자연어 응답으로 변환
answer_prompt = PromptTemplate.from_template(
    """Given the following user question, corresponding SQL query, and SQL result, answer the user question.

    Question: {question}
    SQL Query: {query}
    SQL Result: {result}
    Answer: """
)

def safe_extract_sql(text):
    sql = extract_sql(text)
    return fix_alias_quotes(sql.rstrip(";")) if sql else "SELECT 1 FROM DUAL"

qa_chain = (
    RunnablePassthrough.assign(query=gemini_sql).assign(
        result=itemgetter("query") | RunnableLambda(safe_extract_sql) | query_excecuter
    )
    | answer_prompt
    | gemini_llm
    | StrOutputParser()
)

@app.route('/qa', methods=['POST'])
def qa():
    data = request.json
    question = data.get("question")
    if not question:
        return jsonify({"error": "질문이 필요합니다."}), 400
    
    response = qa_chain.invoke({"question": question})
    return jsonify({"answer": response})


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)