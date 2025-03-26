package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.AdminMapper;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.Report;
import com.project.gwasil_zero.model.User;

@Service
public class AdminService {
	
	@Autowired
	AdminMapper adminMapper;

	public HashMap<String, Object> getNewMemList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<User> newMemList = adminMapper.selectNewMemList(map);
			
			resultMap.put("newMemList", newMemList);
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
			List<Lawyer> lawPassList = adminMapper.selectLawPassList(map);
			
			resultMap.put("lawPassList", lawPassList);
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> getRepoList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Report> repoList = adminMapper.selectReportList(map);
			
			resultMap.put("repoList", repoList);
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}





}
