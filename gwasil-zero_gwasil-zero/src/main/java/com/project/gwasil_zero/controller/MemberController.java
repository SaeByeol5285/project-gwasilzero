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
import com.project.gwasil_zero.dao.MemberService;

@Controller
public class MemberController {
	
	@Autowired // 두번째로 만들자
	MemberService memberService;
	
	@RequestMapping("/member/login.do") 
	public String login(Model model) throws Exception{

        return "/member/member-login"; 
    }
	
	@RequestMapping(value = "/member/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
//		System.out.println(map); 
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = memberService.memberLogin(map);
		return new Gson().toJson(resultMap);
	}

}
