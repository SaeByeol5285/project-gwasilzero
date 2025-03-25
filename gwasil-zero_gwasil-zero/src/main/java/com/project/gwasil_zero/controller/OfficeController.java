package com.project.gwasil_zero.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.project.gwasil_zero.dao.OfficeService;

@Controller
public class OfficeController {
	@Autowired
	OfficeService officeService;
	
	@RequestMapping("/lawyer/office.do") 
    public String office(Model model) throws Exception{
		
        return "/lawyerOffice/office"; 
    }
	
	
	
}
