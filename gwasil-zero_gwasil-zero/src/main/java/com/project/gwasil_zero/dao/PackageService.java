package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.PackageMapper;
import com.project.gwasil_zero.model.Packages;
import com.project.gwasil_zero.model.Pay;

import jakarta.servlet.http.HttpSession;

@Service
public class PackageService {
	@Autowired
	PackageMapper packageMapper;
	
	@Autowired
	HttpSession session;
	
	//게시글 가져오기
	public HashMap<String, Object> getpackageList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Packages> list = packageMapper.selectPackageList(map);		
			resultMap.put("list", list);
			resultMap.put("result", "success");		
			
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage()); //개발자 확인하기 위한 용도
			resultMap.put("result", "fail");						
		}
		return resultMap;
	}

	public HashMap<String, Object> addPayment(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		packageMapper.insertPayment(map);
		return resultMap;
	}

	public HashMap<String, Object> getpayList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Pay> purchasedList  = packageMapper.selectpayList(map);		
		resultMap.put("purchasedList", purchasedList);
		resultMap.put("result", "success");	
		
		return resultMap;
	}
	
	
}