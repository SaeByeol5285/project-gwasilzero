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
	
	@RequestMapping("/project/admin.do") 
    public String main(Model model) throws Exception{
		
        return "/admin"; 
    }
	
	@RequestMapping("/project/admin/product.do") 
    public String product(Model model) throws Exception{
		
        return "/admin-product"; 
    }
	
	// 패키지 목록 (PackageController)
	@RequestMapping(value = "/project/admin/product.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String packageList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = adminService.getpackageList(map);
		return new Gson().toJson(resultMap);
	}
}
