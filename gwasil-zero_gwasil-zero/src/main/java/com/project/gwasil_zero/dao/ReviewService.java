package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.ReviewMapper;
import com.project.gwasil_zero.model.Board;
import com.project.gwasil_zero.model.Review;
import com.project.gwasil_zero.model.TotalDocs;

@Service
public class ReviewService {
	@Autowired
	ReviewMapper reviewMapper;


	public HashMap<String, Object> getAvailableReviewList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<Review> list = reviewMapper.selectAvailableReviewList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
		}
		return resultMap;
	}


	public HashMap<String, Object> addReview(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			int num = reviewMapper.insertReview(map);
			if(num > 0) {
				resultMap.put("result", "success");
			}else {
				resultMap.put("result", "fail");				
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "error");
		}
		return resultMap;
	}


}
