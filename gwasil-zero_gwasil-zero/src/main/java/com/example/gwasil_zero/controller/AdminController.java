package com.example.gwasil_zero.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.gwasil_zero.dao.AdminService;

@Controller
public class AdminController {
	
	@Autowired
	AdminService adService;
	
	// 상품 관리
	@RequestMapping("/project/admin/product.do") 
	public String add(Model model) throws Exception{
		return "/admin-product"; 
	}
}
