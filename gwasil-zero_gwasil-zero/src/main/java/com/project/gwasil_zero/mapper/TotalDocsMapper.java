package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.TotalCmt;
import com.project.gwasil_zero.model.TotalDocs;
import com.project.gwasil_zero.model.TotalFile;

@Mapper
public interface TotalDocsMapper {

	//리스트
	List<TotalDocs> selectDocsList(HashMap<String, Object> map);

	//페이징
	int selectDocsCnt(HashMap<String, Object> map);

	//상세보기
	TotalDocs selectDocsInfo(HashMap<String, Object> map);

	//이전글
	TotalDocs selectPrevDocs(HashMap<String, Object> map);

	//다음글
	TotalDocs selectNextDocs(HashMap<String, Object> map);

	//첨부파일 리스트
	List<TotalFile> selectFileList(HashMap<String, Object> map);
	
	//조회수 증가
	void updateCnt(HashMap<String, Object> map);

	//글삭제
	int deleteDocs(HashMap<String, Object> map);
	
	//글수정
    void updateDocs(HashMap<String,Object> map);

	//글쓰기
	void insertDocs(HashMap<String, Object> map);
	
	//첨부파일 넣기
	void insertFiles(HashMap<String, Object> map);

	//첨부파일 삭제
	void deleteFile(HashMap<String, Object> delMap);

	//댓글 등록
	int insertCmt(HashMap<String, Object> map);

	//댓글 리스트
	List<TotalCmt> selectCmtList(HashMap<String, Object> map);

	//댓글 수정
	int updateCmt(HashMap<String, Object> map);

	//댓글 삭제
	int deleteCmt(HashMap<String, Object> map);








}
