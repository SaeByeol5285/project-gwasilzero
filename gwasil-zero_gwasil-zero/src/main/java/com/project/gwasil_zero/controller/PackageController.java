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
import com.project.gwasil_zero.dao.PackageService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class PackageController {
	@Autowired
	PackageService packageService;
	
	@Autowired
	HttpSession session;
	
	// 패키지 구매
	@RequestMapping("/package/package.do")
	public String packageList(Model model) throws Exception {

		return "/package/package";
	}
	
	// 결제 창
	@RequestMapping("/package/packagePay.do")
	public String pay(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);

		return "/package/packagePay";
	}

	
	@RequestMapping(value = "/package/package.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String packageList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = packageService.getpackageList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/payment.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	   @ResponseBody
	   public String payment(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	      HashMap<String, Object> resultMap = new HashMap<String, Object>();
	      
	      resultMap = packageService.addPayment(map);
	      return new Gson().toJson(resultMap);
	   }
	
	// 결제 내역 불러오기
	@RequestMapping(value = "/package/purchased.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String payList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		 String sessionId = (String) session.getAttribute("sessionId");
		 String role = (String) session.getAttribute("role");

		 if ("user".equals(role)) {
		     map.put("userId", sessionId);
		 } else if ("lawyer".equals(role)) {
		     map.put("lawyerId", sessionId);
		 }
		resultMap = packageService.getpayList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 변호사 월 정액 활동 패키지 구매
	@RequestMapping(value = "/lawyer/updateAuthEndtime.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String lawyerPackage(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = packageService.editAuthEndtime(map);
		return new Gson().toJson(resultMap);
	}
}