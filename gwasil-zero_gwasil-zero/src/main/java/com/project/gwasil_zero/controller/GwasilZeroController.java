package com.project.gwasil_zero.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.project.gwasil_zero.dao.GwasilZeroService;

@Controller
public class GwasilZeroController {
	@Autowired
	GwasilZeroService gwasilZeroService;
	
	// 게시글 목록
	@RequestMapping("/project/list.do")
	public String boardList(Model model) throws Exception {

		return "/sample";
	}


	// 게시글 목록
	@RequestMapping(value = "/project/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String boardList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = gwasilZeroService.getBoardList(map);
		return new Gson().toJson(resultMap);
	}

}
