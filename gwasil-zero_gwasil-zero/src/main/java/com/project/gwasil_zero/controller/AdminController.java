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
    
 // admin 변호사관리 주소dddd
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
   	
   	// 연도 목록 조회
   	@RequestMapping(value = "/admin/pieAvailableYears.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String pieAvailableYears() {
   	    HashMap<String, Object> resultMap = adminService.getAvailableYears();
   	    return new Gson().toJson(resultMap);
   	}

   	// 월 목록 조회
   	@RequestMapping(value = "/admin/pieAvailableMonths.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String pieAvailableMonths(@RequestBody HashMap<String, Object> map) {
   	    HashMap<String, Object> resultMap = adminService.getAvailableMonths(map);
   	    return new Gson().toJson(resultMap);
   	}

   	// 일 목록 조회
   	@RequestMapping(value = "/admin/pieAvailableDays.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String pieAvailableDays(@RequestBody HashMap<String, Object> map) {
   	    HashMap<String, Object> resultMap = adminService.getAvailableDays(map);
   	    return new Gson().toJson(resultMap);
   	}
   	
   	// 파이차트 데이터 조회
   	@RequestMapping(value = "/admin/statPie.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String statPie(@RequestBody HashMap<String, Object> map) throws Exception {
   	    HashMap<String, Object> resultMap = new HashMap<>();

   	    try {
   	        // 파라미터 정리
   	        String year = (String) map.getOrDefault("year", "");
   	        String month = (String) map.getOrDefault("month", "");
   	        String day = (String) map.getOrDefault("day", "");

   	        // 유효성 검사 및 포맷 보정
   	        if (!year.isEmpty()) {
   	            if (!year.matches("\\d{4}")) {
   	                resultMap.put("result", "fail");
   	                resultMap.put("message", "올바르지 않은 연도 형식입니다.");
   	                return new Gson().toJson(resultMap);
   	            }
   	            map.put("year", year);
   	        }

   	        if (!month.isEmpty()) {
   	            int m = Integer.parseInt(month);
   	            if (m < 1 || m > 12) {
   	                resultMap.put("result", "fail");
   	                resultMap.put("message", "올바르지 않은 월 형식입니다.");
   	                return new Gson().toJson(resultMap);
   	            }
   	            if (month.length() == 1) {
   	                month = "0" + month;
   	                map.put("month", month);
   	            }
   	        }

   	        if (!day.isEmpty()) {
   	            int d = Integer.parseInt(day);
   	            if (d < 1 || d > 31) {
   	                resultMap.put("result", "fail");
   	                resultMap.put("message", "올바르지 않은 일 형식입니다.");
   	                return new Gson().toJson(resultMap);
   	            }
   	            if (day.length() == 1) {
   	                day = "0" + day;
   	                map.put("day", day);
   	            }
   	        }

   	        // 실제 데이터 조회
   	        resultMap = adminService.getStatPie(map);

   	    } catch (Exception e) {
   	        System.out.println("Pie 차트 에러: " + e.getMessage());
   	        resultMap.put("result", "fail");
   	        resultMap.put("message", "서버 오류가 발생했습니다.");
   	    }

   	    return new Gson().toJson(resultMap);
   	}
   	
   	// 일반 이용자 등록 차트 데이타 조회
   	@RequestMapping(value = "/admin/statUserLine.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String statUserLine(@RequestBody HashMap<String, Object> map) {
   	    HashMap<String, Object> resultMap = new HashMap<>();

   	 try {
         // 필터 기본값 처리
         String groupType = (String) map.getOrDefault("groupType", "monthly");
         map.put("groupType", groupType);

         resultMap = adminService.getStatUserLine(map);
     } catch (Exception e) {
         e.printStackTrace();
         resultMap.put("result", "fail");
     }

   	    return new Gson().toJson(resultMap);
   	}

}
