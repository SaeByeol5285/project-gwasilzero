package com.project.gwasil_zero.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.project.gwasil_zero.dao.CommonService;

@Controller
public class CommonController {
	@Autowired
	CommonService commonService;

	// 메인페이지
	@RequestMapping("/common/main.do")
	public String boardList(Model model) throws Exception {

		return "/common/main";
	}

	// 회사소개
	@RequestMapping("/common/introduce.do")
	public String intro(Model model) throws Exception {

		return "/introduceCo/introduceCo";
	}

	// 이용약관
	@RequestMapping("/common/terms.do")
	public String terms(Model model) throws Exception {

		return "/common/terms";
	}

	// 에러페이지
	@RequestMapping("/common/error.do")
	public String error(Model model) throws Exception {

		return "/common/error";
	}

	// 메인-최신게시글
	@RequestMapping(value = "/common/boardList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String boardlist(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = commonService.getBoardList(map);
		return new Gson().toJson(resultMap);
	}

	// 변호사 리스트
	@RequestMapping(value = "/common/lawyerList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String lawyerList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = commonService.getLawyerList(map);
		return new Gson().toJson(resultMap);
	}

}
