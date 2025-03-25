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
import com.project.gwasil_zero.dao.PackagesService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class PackagesController {
	@Autowired
	PackagesService packagesService;
	
	// 패키지 구매
	@RequestMapping("/packages/packages.do")
	public String packageList(Model model) throws Exception {

		return "/packages/packages";
	}
	
	// 결제 창
	@RequestMapping("/packages/packagesPay.do")
	public String pay(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);

		return "/packages/packagesPay";
	}

	
	@RequestMapping(value = "/packages/packages.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String packageList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = packagesService.getpackageList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/payment.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	   @ResponseBody
	   public String payment(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	      HashMap<String, Object> resultMap = new HashMap<String, Object>();
	      
	      resultMap = packagesService.addPayment(map);
	      return new Gson().toJson(resultMap);
	   }
}