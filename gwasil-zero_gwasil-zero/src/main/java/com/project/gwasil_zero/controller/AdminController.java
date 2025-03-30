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
    @RequestMapping("/admin/report.do") 
    public String adminBoard(@RequestParam(value = "page", required = false) String page, Model model) {
        model.addAttribute("currentPage", page);
        return "/admin/report"; 
    }

    // admin 차트 주소
    @RequestMapping("/admin/chart.do") 
    public String adminChart(@RequestParam(value = "page", required = false) String page, Model model) {
        model.addAttribute("currentPage", page);
        return "/admin/chart"; 
    }
    
    // 로그아웃 세션처리 
//    @RequestMapping("/logout")
//    public String logout(HttpSession session) {
//        session.invalidate(); // 세션 초기화
//        return "redirect:/common/main"; // 메인 페이지로 리다이렉트
//    }
    
    // 신규 유저 목록
 	@RequestMapping(value = "/admin/newMemList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
 	@ResponseBody
 	public String newMemList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
 		HashMap<String, Object> resultMap = new HashMap<String, Object>();
 		
 		resultMap = adminService.getNewMemList(map);
 		return new Gson().toJson(resultMap);
 	}
 	
 	// 변호사 승인 대기 목록(메인화면 5명출력)
  	@RequestMapping(value = "/admin/lawAdminWaitList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
  	@ResponseBody
  	public String lawAdminWaitList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
  		HashMap<String, Object> resultMap = new HashMap<String, Object>();
  		
  		resultMap = adminService.getLawAdminWaitList(map);
  		return new Gson().toJson(resultMap);
  	}
  	
  	// 게시글 신고 목록 
   	@RequestMapping(value = "/admin/repoAdminList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String repoAdminList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
   		HashMap<String, Object> resultMap = new HashMap<String, Object>();
   		
   		resultMap = adminService.getRepoAdminList(map);
   		return new Gson().toJson(resultMap);
   	}
   	
   	// 모든 유저 목록
  	@RequestMapping(value = "/admin/userList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
  	@ResponseBody
  	public String userList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
  		HashMap<String, Object> resultMap = new HashMap<String, Object>();
  		
  		resultMap = adminService.getUserList(map);
  		return new Gson().toJson(resultMap);
  	}
  	
  	// 변호사 승인 대기 목록
   	@RequestMapping(value = "/admin/lawWaitList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String lawWaitList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
   		HashMap<String, Object> resultMap = new HashMap<String, Object>();
   		
   		resultMap = adminService.getLawWaitList(map);
   		return new Gson().toJson(resultMap);
   	}
   	
   	// 변호사 승인 처리
   	@RequestMapping(value = "/admin/lawApprove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String lawApprove(@RequestParam HashMap<String, Object> map) throws Exception {
   	    HashMap<String, Object> resultMap = new HashMap<>();

   	    adminService.approveLawyer(map);

   	    resultMap.put("result", "success");
   	    return new Gson().toJson(resultMap);
   	}
   	
   	// 현재 변호사 목록
   	@RequestMapping(value = "/admin/lawPassedList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String lawPassedList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
   		HashMap<String, Object> resultMap = new HashMap<String, Object>();
   		
   		resultMap = adminService.getLawPassedList(map);
   		return new Gson().toJson(resultMap);
   	}
   	
   	// 변호사 취소 처리
   	@RequestMapping(value = "/admin/lawCencel.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String lawCencel(@RequestParam HashMap<String, Object> map) throws Exception {
   	    HashMap<String, Object> resultMap = new HashMap<>();

   	    adminService.cencelLawyer(map);

   	    resultMap.put("result", "success");
   	    return new Gson().toJson(resultMap);
   	}
   	
   	// 탈퇴한 변호사 목록
   	@RequestMapping(value = "/admin/lawOutList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String lawOutList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
   		HashMap<String, Object> resultMap = new HashMap<String, Object>();
   		
   		resultMap = adminService.getLawOutList(map);
   		return new Gson().toJson(resultMap);
   	}
   	
   	// 변호사 재가입 처리
   	@RequestMapping(value = "/admin/lawComeBack.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String lawComeBack(@RequestParam HashMap<String, Object> map) throws Exception {
   	    HashMap<String, Object> resultMap = new HashMap<>();

   	    adminService.comeBackLawyer(map);

   	    resultMap.put("result", "success");
   	    return new Gson().toJson(resultMap);
   	}
   	
   	// 신고 게시판 목록
   	@RequestMapping(value = "/admin/reportList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String reportList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
   		HashMap<String, Object> resultMap = new HashMap<String, Object>();
   		
   		resultMap = adminService.getReportList(map);
   		return new Gson().toJson(resultMap);
   	}
   	
   	// 게시글 신고 상태 업데이트
   	@RequestMapping(value = "/admin/updateReportStatus.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String updateReportStatus(@RequestParam HashMap<String, Object> map) throws Exception {
   	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

   	    try {
   	        adminService.updateReportStatus(map);
   	        resultMap.put("result", "success");
   	    } catch (Exception e) {
   	        e.printStackTrace();
   	        resultMap.put("result", "fail");
   	    }

   	    return new Gson().toJson(resultMap);
   	}
   	
   	// 매출액 차트 그리기(바차트, 라인차트)
   	@RequestMapping(value = "/admin/statChart.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String statChart(@RequestBody HashMap<String, Object> map) throws Exception {
   	    HashMap<String, Object> resultMap = new HashMap<>();
   	    
   	    try {
   	        resultMap = adminService.getStatChart(map);
   	    } catch (Exception e) {
   	        System.out.println("통계 에러: " + e.getMessage());
   	        resultMap.put("result", "fail");
   	    }
   	    
   	    return new Gson().toJson(resultMap);
   	}
   	
   	// 패키지별 총 매출 (도넛 차트용)
   	@RequestMapping(value = "/admin/statDonut.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String statDonut(@RequestBody HashMap<String, Object> map) throws Exception {
   	    HashMap<String, Object> resultMap = new HashMap<>();

   	    try {
   	        resultMap = adminService.getStatDonut(map);
   	    } catch (Exception e) {
   	        System.out.println("도넛 차트 에러: " + e.getMessage());
   	        resultMap.put("result", "fail");
   	    }

   	    return new Gson().toJson(resultMap);
   	}
		
}
