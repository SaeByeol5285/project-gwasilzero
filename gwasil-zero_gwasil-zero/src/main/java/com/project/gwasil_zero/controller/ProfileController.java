package com.project.gwasil_zero.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.project.gwasil_zero.dao.ProfileService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ProfileController {
	
	@Autowired
	ProfileService profileService;
	
	@RequestMapping("/profile/innerLawyer.do") 
    public String innerList(Model model) throws Exception{

        return "/profile/innerLawyer"; 
    }
	
	@RequestMapping("/profile/personalLawyer.do") 
    public String personalList(Model model) throws Exception{

        return "/profile/personalLawyer"; 
    }
	
	@RequestMapping("/profile/view.do") 
	public String lawyerView(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
        return "/profile/lawyerView"; 
    }
	
	@RequestMapping("/profile/lawyerEdit.do") 
	public String lawyerEdit(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);

        return "/profile/lawyerEdit"; 
    }
	
	// 소속 변호사 목록 시작
	@RequestMapping(value = "/profile/innerLawyer.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String innerList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
		resultMap = profileService.getInnerList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 소속 변호사 목록 시작
	@RequestMapping(value = "/profile/personalLawyer.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String personalList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
		resultMap = profileService.getPersonalList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 소속 변호사 상세보기
	@RequestMapping(value = "/profile/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String lawyerInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = profileService.getLawyer(map);
		return new Gson().toJson(resultMap);
	}
	
	// 게시글 수정
	@RequestMapping(value = "/profile/lawyerEdit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String lawyerEdit(@RequestBody HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		
		// --- 로그로 데이터 확인 (디버깅 용도) ---
//	    System.out.println("=== [lawyerEdit] ===");
//	    System.out.println("lawyerId: " + map.get("lawyerId"));
//	    System.out.println("licenseList: " + map.get("licenseList"));
//	    System.out.println("selectedBoards: " + map.get("selectedBoards"));
		
		// 1. 기본 정보 수정 (LAWYER 테이블)
		resultMap = profileService.editLawyer(map);
		
		// 2. LICENSE 리스트 수정 (DELETE 후 INSERT)
	    profileService.editLicense(map);
	    
	    // 3. 대표 사건 사례(mainCase1No~3No) 업데이트
	    profileService.editMainCases(map); 
	    
		return new Gson().toJson(resultMap);
	}
	
	// git test
}
