package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.MypageMapper;
import com.project.gwasil_zero.model.User;

@Service
public class MypageService {

	@Autowired
	MypageMapper mypageMapper;

	public HashMap<String, Object> getList(HashMap<String, Object> map) {
	    if (map.get("sessionId") != null) {
	        map.put("userId", map.get("sessionId"));  // 🔥 이게 핵심
	    }

	    System.out.println("🔎 최종 전달 데이터: " + map);
	    
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    List<User> user = mypageMapper.selectUser(map);
	    System.out.println("🔎 조회된 사용자 정보: " + user);

	    resultMap.put("user", user);
	    return resultMap;
	}
	
	public HashMap<String, Object> removeUser(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    if (map.get("sessionId") != null) {
	        map.put("userId", map.get("sessionId"));  // 🔥 핵심
	    }

	    int deletedRows = mypageMapper.deleteUser(map);  // Mapper 호출
	    System.out.println("🔎 삭제된 행 수: " + deletedRows);  // 추가

	    if (deletedRows > 0) {
	        resultMap.put("result", "success");
	    } else {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "사용자 정보를 찾을 수 없습니다.");
	    }

	    System.out.println("🔎 Service 응답 데이터: " + resultMap);  // 추가
	    return resultMap;
	}

}
