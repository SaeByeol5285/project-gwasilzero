package com.project.gwasil_zero.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
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
	       HashMap<String, Object> resultMap = new HashMap<String, Object>();
	       
	       // 사용자와 변호사 정보 조회
	       User searchUser = userMapper.searchUser(map);  // 유저 찾기
	       Lawyer searchLawyer = userMapper.searchLawyer(map);  // 변호사 찾기

	       // 비밀번호 비교 (PasswordEncoder 사용)
	       if (searchUser != null && passwordEncoder.matches(map.get("pwd").toString(), searchUser.getUserPassword())) {
	           // 비밀번호가 맞으면 로그인 성공 처리
	           resultMap.put("list", userMapper.selectUser(map));  // 유저 정보 조회
	           resultMap.put("result", "success");
	       } else if (searchLawyer != null && passwordEncoder.matches(map.get("pwd").toString(), searchLawyer.getLawyerPwd())) {
	           // 비밀번호가 맞으면 로그인 성공 처리
	           resultMap.put("list", userMapper.selectLawyer(map));  // 변호사 정보 조회
	           resultMap.put("result", "success"); 
	       } else {
	           // 로그인 실패 처리
	           resultMap.put("result", "fail");  
	       }

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
	      User user = userMapper.selectUserId(map);
	      Lawyer lawyer = userMapper.selectLawyerId(map);
	      resultMap.put("user", user);
	      resultMap.put("lawyer", lawyer);      
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
	