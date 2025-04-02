package com.project.gwasil_zero.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.ContractMapper;
import com.project.gwasil_zero.model.Lawyer;

@Service
public class ContractService {
	@Autowired
	ContractMapper contractMapper;
	
	public HashMap<String, Object> addContract(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			contractMapper.insertContract(map);
			resultMap.put("result","success");
			
		}catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result","failed");
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getLawyerInfo(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Lawyer lawyer = contractMapper.selectLawyer(map);
			resultMap.put("lawyer", lawyer);
			resultMap.put("result","success");
			
		}catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result","failed");
		}
		return resultMap;
	}
}
