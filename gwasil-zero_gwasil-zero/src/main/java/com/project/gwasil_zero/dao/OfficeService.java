package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.OfficeMapper;
import com.project.gwasil_zero.model.Area;
import com.project.gwasil_zero.model.Lawyer;

@Service
public class OfficeService {
	@Autowired
	OfficeMapper officeMapper;
	
	public HashMap<String, Object> selectSi(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Area> siList = officeMapper.getSi(map);
		resultMap.put("siList", siList);
		
		return resultMap;
	}

	public HashMap<String, Object> selectGu(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Area> guList = officeMapper.getGu(map);
		resultMap.put("guList", guList);
		
		return resultMap;
	}

	public HashMap<String, Object> selectDong(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Area> dongList = officeMapper.getDong(map);
		resultMap.put("dongList", dongList);
		
		return resultMap;
	}

	public HashMap<String, Object> getLawyerList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Lawyer> lawyerList = officeMapper.getLawyerList(map);
		resultMap.put("lawyerList", lawyerList);
		
		return resultMap;
	}
}
