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

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	// admin main 주소
	@RequestMapping("/admin/main.do") 
    public String adminMain(@RequestParam(value = "page", required = false) String page, Model model) {
		if (page == null || page.isEmpty()) {
	        page = "main";
	    }
		
		model.addAttribute("currentPage", page);
        return "/admin/main"; 
    }
	
	// admin 회원관리 주소
    @RequestMapping("/admin/user.do") 
    public String adminUser(@RequestParam(value = "page", required = false) String page, Model model) {
        model.addAttribute("currentPage", page);
        return "/admin/user"; 
    }
    
 // admin 변호사관리 주소
    @RequestMapping("/admin/lawyer.do") 
    public String adminLawyer(@RequestParam(value = "page", required = false) String page, Model model) {
        model.addAttribute("currentPage", page);
        return "/admin/lawyer"; 
    }
    
    // admin 게시판관리 주소
    @RequestMapping("/admin/board.do") 
    public String adminBoard(@RequestParam(value = "page", required = false) String page, Model model) {
        model.addAttribute("currentPage", page);
        return "/admin/board"; 
    }

    // admin 차트 주소
    @RequestMapping("/admin/chart.do") 
    public String adminChart(@RequestParam(value = "page", required = false) String page, Model model) {
        model.addAttribute("currentPage", page);
        return "/admin/chart"; 
    }
    
    // 로그아웃 세션처리 
    @RequestMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // 세션 초기화
        return "redirect:/login"; // 로그인 페이지로 리다이렉트
    }
    
    // 신규 유저 목록
 	@RequestMapping(value = "/newMemList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
 	@ResponseBody
 	public String newMemList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
 		HashMap<String, Object> resultMap = new HashMap<String, Object>();
 		
 		resultMap = adminService.getNewMemList(map);
 		return new Gson().toJson(resultMap);
 	}
		
}
