package com.project.gwasil_zero.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

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
	
	// 변호사 라이센스 리스트 및 자격증 이미지
	@RequestMapping(value = "/profile/lawyerEdit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String lawyerEdit(MultipartHttpServletRequest request) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        String lawyerId = request.getParameter("lawyerId");
	        String uploadPath = request.getServletContext().getRealPath("/license/");

	        // info
	        String infoJson = request.getParameter("info");
	        Gson gson = new Gson();
	        Map<String, Object> infoMap = gson.fromJson(infoJson, Map.class);

	        // selectedBoards
	        String selectedBoardsJson = request.getParameter("selectedBoards");
	        List<Double> selectedBoardsDouble = gson.fromJson(selectedBoardsJson, List.class);
	        List<Integer> selectedBoards = selectedBoardsDouble.stream()
	                .map(Double::intValue)
	                .collect(Collectors.toList());

	        // licenseList
	        List<HashMap<String, Object>> licenseList = new ArrayList<>();
	        int licenseCount = Integer.parseInt(request.getParameter("licenseCount"));
	        for (int i = 0; i < licenseCount; i++) {
	            String licenseName = request.getParameter("licenseName_" + i);
	            MultipartFile licenseFile = request.getFile("licenseFile_" + i);

	            // 유효성 체크 (trim + 파일 존재)
	            if (licenseName != null && !licenseName.trim().isEmpty()
	                && licenseFile != null && !licenseFile.isEmpty()) {
	                HashMap<String, Object> license = new HashMap<>();
	                license.put("licenseName", licenseName.trim());
	                license.put("licenseFile", licenseFile);
	                licenseList.add(license);
	            } else {
	            	throw new Exception("[" + (licenseName != null ? licenseName : "이름 없음") + "] 자격증 항목이 누락되었습니다.");
	            }
	        }

	        // map 구성
	        HashMap<String, Object> paramMap = new HashMap<>();
	        paramMap.put("lawyerId", lawyerId);
	        paramMap.put("lawyerInfo", infoMap.get("lawyerInfo"));
	        paramMap.put("lawyerCareer", infoMap.get("lawyerCareer"));
	        paramMap.put("lawyerTask", infoMap.get("lawyerTask"));
	        paramMap.put("lawyerEdu", infoMap.get("lawyerEdu"));
	        paramMap.put("selectedBoards", selectedBoards);
	        paramMap.put("licenseList", licenseList);
	        paramMap.put("uploadPath", uploadPath);

	        // 서비스 호출
	        resultMap = profileService.editLawyer(paramMap);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	    }

	    return new Gson().toJson(resultMap);
	}
}
