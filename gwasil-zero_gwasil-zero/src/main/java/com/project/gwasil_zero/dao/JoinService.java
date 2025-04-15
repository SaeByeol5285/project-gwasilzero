package com.project.gwasil_zero.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.JoinMapper;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class JoinService {

	@Autowired
	HttpSession session;

	@Autowired
	JoinMapper joinMapper;

	@Autowired
	PasswordEncoder passwordEncoder;

	public HashMap<String, Object> addUser(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		String hashPwd = passwordEncoder.encode((String) map.get("pwd"));
		map.put("pwd", hashPwd);
		int num = joinMapper.insertUser(map);
		resultMap.put("result", "success");
		return resultMap;
	}

	public HashMap<String, Object> searchJoin(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		// lawyerId가 없으면 userId 값을 복사
		if (!map.containsKey("lawyerId") || map.get("lawyerId") == null) {
			map.put("lawyerId", map.get("userId"));
		}

		User user = joinMapper.selectUser(map);
		Lawyer lawyer = joinMapper.selectLawyer(map);

		int count = (user != null || lawyer != null) ? 1 : 0;
		resultMap.put("count", count);
		return resultMap;
	}

	public HashMap<String, Object> addLawyer(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		String hashPwd = passwordEncoder.encode((String) map.get("pwd"));
		map.put("pwd", hashPwd);
		int num = joinMapper.insertLawyer(map);
		resultMap.put("result", "success");
		return resultMap;
	}

	public HashMap<String, Object> searchJoinLawyer(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		//  userId 없으면 lawyerId 값을 넣어주기
		if (!map.containsKey("userId") || map.get("userId") == null) {
			map.put("userId", map.get("lawyerId"));
		}

		Lawyer lawyer = joinMapper.selectLawyer(map);
		User user = joinMapper.selectUser(map);

		int count = (lawyer != null || user != null) ? 1 : 0;
		resultMap.put("count", count);
		return resultMap;
	}

	public HashMap<String, Object> editUser(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		joinMapper.updateBoard(map);
		resultMap.put("result", "success");
		return resultMap;
	}

}
