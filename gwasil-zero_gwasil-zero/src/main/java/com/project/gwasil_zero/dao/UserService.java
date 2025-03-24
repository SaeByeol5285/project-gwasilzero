package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.UserMapper;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class UserService {
	
	@Autowired
	UserMapper userMapper;
	
	@Autowired
	HttpSession session;
	
	@Autowired
	PasswordEncoder passwordEncoder;
	
	
	public HashMap<String, Object> getInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		User searchUser = userMapper.searchUser(map);
		Lawyer searchLawyer = userMapper.searchLawyer(map);
		
		if(searchUser!=null) {
			List<User> list = userMapper.selectUser(map);
			resultMap.put("list", list);
		}
		if(searchLawyer!=null) {
			List<Lawyer> list = userMapper.selectLawyer(map);
			resultMap.put("list", list);
		}
		
		
		resultMap.put("result", "success");	
		return resultMap;
	}

	public HashMap<String, Object> addUser(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		String hashPwd = passwordEncoder.encode((String)map.get("pwd"));
		map.put("pwd", hashPwd);
		int num = userMapper.insertUser(map);
		resultMap.put("result", "success");
		
		return resultMap;
	}

	public HashMap<String, Object> searchUser(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		User user = userMapper.CheckUser(map);
		int count = user != null ? 1 : 0;
		resultMap.put("count", count);
		return resultMap;
	}

	public HashMap<String, Object> selectUserId(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		userMapper.selectUserId(map);
		resultMap.put("result", "success");
		return resultMap;
	}

	public HashMap<String, Object> selectUserPwd(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		userMapper.selectUserPwd(map);
		resultMap.put("result", "success");
		return resultMap;
	}
	
	 
}
	