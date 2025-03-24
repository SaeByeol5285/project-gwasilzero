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
import com.project.gwasil_zero.dao.AdminService;

@Controller
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	@RequestMapping("/admin/main.do") 
    public String adminMain(@RequestParam(value = "page", required = false) String page, Model model) {
		if (page == null || page.isEmpty()) {
	        page = "main";
	    }
		
		model.addAttribute("currentPage", page);
        return "/admin/main"; 
    }
	
	@RequestMapping("/admin/product.do") 
	public String adminProduct(@RequestParam(value = "page", required = false) String page, Model model) {
		if (page == null || page.isEmpty()) {
	        page = "main";
	    }
		
		model.addAttribute("currentPage", page);
        return "/admin/product"; 
    }
	
	// 패키지 목록 (PackageController)
	@RequestMapping(value = "/admin/product.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String packageList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = adminService.getpackageList(map);
		return new Gson().toJson(resultMap);
	}
}
