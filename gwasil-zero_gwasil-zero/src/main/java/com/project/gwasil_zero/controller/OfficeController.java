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
import com.project.gwasil_zero.dao.OfficeService;

@Controller
public class OfficeController {
	@Autowired
	OfficeService officeService;
	
	@RequestMapping("/lawyer/office.do") 
    public String office(Model model) throws Exception{
		
        return "/lawyerOffice/office"; 
    }
	
	@RequestMapping(value = "/lawyer/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String lawyerList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = officeService.getLawyerList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/si.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String siArea(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = officeService.selectSi(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/gu.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String guArea(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = officeService.selectGu(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/dong.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String dongArea(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = officeService.selectDong(map);
		return new Gson().toJson(resultMap);
	}
	
}
