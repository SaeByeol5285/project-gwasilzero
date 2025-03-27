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
import com.project.gwasil_zero.dao.JoinService;

@Controller
public class JoinController {

	@Autowired
	JoinService joinService;

	// 일반 유저 / 변호사 유저 선택
	@RequestMapping("/join/select.do")
	public String search(Model model) throws Exception {

		return "/join/user-select";
	}

	// 일반 유저 회원가입
	@RequestMapping("/join/user-join.do")
	public String userJoin(Model model) throws Exception {

		return "/join/user-join";
	}

	// 변호사 회원가입
	@RequestMapping("/join/lawyer-join.do")
	public String lawyerJoin(Model model) throws Exception {

		return "/join/lawyer-join";
	}

	// 일반 유저 정보수정
	@RequestMapping("/join/edit.do")
	public String edit(Model model) throws Exception {

		return "/join/user-edit";
	}

	// 일반 유저 회원가입
	@RequestMapping(value = "/join/user-add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String joinUser(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = joinService.addUser(map);
		return new Gson().toJson(resultMap);
	}

	// 변호사 유저 회원가입
	@RequestMapping(value = "/join/lawyer-add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String joinLawyer(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = joinService.addLawyer(map);
		return new Gson().toJson(resultMap);
	}

	// 일반 유저 중복체크
	@RequestMapping(value = "/join/check.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String check(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = joinService.searchJoin(map);
		return new Gson().toJson(resultMap);
	}

	// 변호사 유저 중복체크
	@RequestMapping(value = "/join/checkLawyer.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String checkLawyer(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = joinService.searchJoinLawyer(map);
		return new Gson().toJson(resultMap);
	}

	// 일반 유저 정보수정
	@RequestMapping(value = "/join/user-edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editUser(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = joinService.editUser(map);
		return new Gson().toJson(resultMap);
	}
}
