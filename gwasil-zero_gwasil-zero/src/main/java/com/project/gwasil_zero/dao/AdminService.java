package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.AdminMapper;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.User;

@Service
public class AdminService {
	
	@Autowired
	AdminMapper adminMapper;

	public HashMap<String, Object> getNewMemList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<User> uList = adminMapper.selectNewMemList(map);
			
			resultMap.put("uList", uList);
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> getLawPassList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Lawyer> lawList = adminMapper.selectLawPassList(map);
			
			resultMap.put("lawList", lawList);
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}





}
