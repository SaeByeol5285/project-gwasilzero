package com.project.gwasil_zero.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.project.gwasil_zero.dao.ReviewService;
import com.project.gwasil_zero.model.Review;

import jakarta.servlet.http.HttpSession;

@Controller
public class ReviewController {

	@Autowired
	ReviewService reviewService;

	// 작성가능 리스트
	@RequestMapping(value = "/review/available.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAvailableReviewList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = reviewService.getAvailableReviewList(map);
		return new Gson().toJson(resultMap);
		
	}
	
	//리뷰 작성
	@RequestMapping(value = "/review/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addReview(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = reviewService.addReview(map);
		return new Gson().toJson(resultMap);
		
	}
	
	
	
	
}
