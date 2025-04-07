package com.project.gwasil_zero.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import java.lang.reflect.Type;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

@Controller
public class KeywordController {

    @RequestMapping(value = "/api/keywords.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String extractKeywords(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<>();

        // 1. 파라미터에서 텍스트 가져오기
        String inputText = (String) map.get("text");
        if (inputText == null || inputText.trim().isEmpty()) {
            resultMap.put("error", "텍스트를 입력하세요.");
            return new Gson().toJson(resultMap);
        }

        // 2. Python 스크립트 실행
        String scriptPath = "C:/KR-WordRank/keyword_extract.py";
        ProcessBuilder builder = new ProcessBuilder("python", scriptPath, inputText);
        builder.redirectErrorStream(true);
        Process process = builder.start();

        // 3. Python 출력 읽기
        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream(), StandardCharsets.UTF_8));
        StringBuilder output = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            output.append(line);
        }

        int exitCode = process.waitFor();
        if (exitCode != 0) {
            resultMap.put("error", "파이썬 실행 실패 (code: " + exitCode + ")");
            return new Gson().toJson(resultMap);
        }

        // 4. JSON 파싱 후 결과 반환
        Gson gson = new Gson();
        Type type = new TypeToken<HashMap<String, Object>>() {}.getType();
        HashMap<String, Object> keywordMap = gson.fromJson(output.toString(), type);

        resultMap.put("result", "success");
        resultMap.put("keywords", keywordMap);

        return gson.toJson(resultMap);
    }
}
