package com.project.gwasil_zero.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.project.gwasil_zero.dao.CommonService;

@Controller
public class CommonController {
	@Autowired
	CommonService commonService;

	@RequestMapping("/common/main.do")
	public String boardList(Model model) throws Exception {

		return "/common/main";
	}

}
