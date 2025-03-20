package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.GwasilZeroMapper;
import com.project.gwasil_zero.model.GwasilZero;

import jakarta.servlet.http.HttpSession;


@Service
public class GwasilZeroService {
	
	@Autowired
	GwasilZeroMapper gwasilZeroMapper;
	
	@Autowired
	HttpSession session;
	
	//게시글 가져오기
	public HashMap<String, Object> getBoardList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<GwasilZero> list = gwasilZeroMapper.selectBoardList(map);		
			resultMap.put("list", list);
			resultMap.put("result", "success");		
			
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage()); //개발자 확인하기 위한 용도
			resultMap.put("result", "fail");						
		}
		return resultMap;
	}
}
