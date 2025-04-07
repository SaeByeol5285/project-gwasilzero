package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.CommonMapper;
import com.project.gwasil_zero.model.Board;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.Review;

@Service
public class CommonService {
	@Autowired
	CommonMapper commonMapper;

	// 최신글 가져오기
	public HashMap<String, Object> getBoardList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<Board> boardList = commonMapper.selectBoardList(map);
			resultMap.put("list", boardList);
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "failed");
		}

		return resultMap;
	}

	public HashMap<String, Object> getLawyerList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<Lawyer> list = commonMapper.selectLawyerList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "failed");
		}

		return resultMap;
	}

	public HashMap<String, Object> getLReviewList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<Review> list = commonMapper.selectReviewList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "failed");
		}

		return resultMap;	}

}
