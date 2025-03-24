package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.AdminMapper;
import com.project.gwasil_zero.model.User;

@Service
public class AdminService {
	
	@Autowired
	AdminMapper adminMapper;

	public HashMap<String, Object> getNewMemList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<User> list = adminMapper.selectNewMemList(map);
			
			resultMap.put("list", list);
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

}
