package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
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
//		userMapper.insertUser(map);
		
		return null;
	}
}
	