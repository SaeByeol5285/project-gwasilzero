package com.project.gwasil_zero.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.project.gwasil_zero.dao.JoinService;

@Controller
public class JoinContorller {

	@Autowired
	JoinService joinService;

	// 일반 유저 / 변호사 유저 선택
	@RequestMapping("/join/select.do")
	public String search(Model model) throws Exception {

		return "/join/user-select";
	}
}
