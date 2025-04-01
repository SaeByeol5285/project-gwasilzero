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
import com.project.gwasil_zero.dao.ContractService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ContractController {
	@Autowired
	ContractService contractService;
	
	@RequestMapping("/contract/newContract.do") 
	   public String boardView(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
			
		request.setAttribute("map", map);
		return "/contract/newContract";
	}
	
	@RequestMapping(value = "/contract/addContract.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addContract(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = contractService.addContract(map);
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/contract/getLawyerInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getLawyerInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = contractService.getLawyerInfo(map);
		return new Gson().toJson(resultMap);
	}
}
