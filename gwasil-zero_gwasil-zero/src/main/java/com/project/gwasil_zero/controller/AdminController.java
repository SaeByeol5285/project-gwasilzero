package com.project.gwasil_zero.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.project.gwasil_zero.dao.AdminService;

@Controller
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	// admin main 주소
	@RequestMapping("/admin/main.do") 
	public String adminMain(Model model) throws Exception{

		return "/admin/admin-main"; 
	}
}
