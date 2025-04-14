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
	public String innerList(Model model) throws Exception {

		return "/profile/innerLawyer";
	}

	@RequestMapping("/profile/personalLawyer.do")
	public String personalList(Model model) throws Exception {

		return "/profile/personalLawyer";
	}

	@RequestMapping("/profile/view.do")
	public String lawyerView(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		request.setAttribute("map", map);
		return "/profile/lawyerView";
	}

	@RequestMapping("/profile/lawyerEdit.do")
	public String lawyerEdit(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
		request.setAttribute("map", map);

		return "/profile/lawyerEdit";
	}

	// 리뷰
	@RequestMapping("/profile/review.do")
	public String terms(Model model) throws Exception {

		return "/profile/review";
	}

	// 소속 변호사 목록 시작
	@RequestMapping(value = "/profile/innerLawyer.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String innerList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = profileService.getInnerList(map);
		return new Gson().toJson(resultMap);
	}

	// 소속 변호사 목록 시작 깃
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
			Gson gson = new Gson();

			// 이미지 경로 로그
//	        System.out.println("UploadPath: " + uploadPath);

	        // 1. 프로필 정보 가져오기
	        String infoJson = request.getParameter("info");
	        Map<String, Object> infoMap = gson.fromJson(infoJson, Map.class);

	        // 2. 대표 사건 선택 목록 가져오기
	        String selectedBoardsJson = request.getParameter("selectedBoards");
	        List<Double> selectedBoardsDouble = gson.fromJson(selectedBoardsJson, List.class);
	        List<Integer> selectedBoards = selectedBoardsDouble.stream()
	                .map(Double::intValue)
	                .collect(Collectors.toList());

	        // 3. 삭제된 자격증 목록 가져오기
	        String deletedLicenseJson = request.getParameter("deletedLicenseIds");
	        List<Map<String, Object>> deletedLicenseList = new ArrayList<>();
	        if (deletedLicenseJson != null && !deletedLicenseJson.isEmpty()) {
	            deletedLicenseList = gson.fromJson(deletedLicenseJson, List.class);
	        }

	        // 4. 신규 자격증 처리
	        List<HashMap<String, Object>> licenseList = new ArrayList<>();
	        int licenseCount = Integer.parseInt(request.getParameter("licenseCount"));
	        for (int i = 0; i < licenseCount; i++) {
	            String licenseName = request.getParameter("licenseName_" + i);
	            MultipartFile licenseFile = request.getFile("licenseFile_" + i);
	            // 로그 확인
//	            System.out.println(">>> licenseName_" + i + ": " + licenseName);
//	            System.out.println(">>> licenseFile_" + i + ": " + (licenseFile != null ? licenseFile.getOriginalFilename() : "null"));

	            if (licenseName != null && !licenseName.trim().isEmpty() && licenseFile != null && !licenseFile.isEmpty()) {
	                HashMap<String, Object> license = new HashMap<>();
	                license.put("licenseName", licenseName.trim());
	                license.put("licenseFile", licenseFile);
	                licenseList.add(license);
	            } else {
	                throw new Exception("[" + (licenseName != null ? licenseName : "이름 없음") + "] 자격증 항목이 누락되었습니다.");
	            }
	        }
	        
	        // 5. 선택된 전문 분야 값 받아오기
	        String selectedCategoriesJson = request.getParameter("selectedCategories");
	        List<String> selectedCategories = gson.fromJson(selectedCategoriesJson, List.class);

	        String mainCategories1 = selectedCategories.size() > 0 ? selectedCategories.get(0) : null;
	        String mainCategories2 = selectedCategories.size() > 1 ? selectedCategories.get(1) : null;

	        // 6. 최종 파라미터 맵 구성
	        HashMap<String, Object> paramMap = new HashMap<>();
	        paramMap.put("lawyerId", lawyerId);
	        paramMap.put("lawyerInfo", infoMap.get("lawyerInfo"));
	        paramMap.put("lawyerCareer", infoMap.get("lawyerCareer"));
	        paramMap.put("lawyerTask", infoMap.get("lawyerTask"));
	        paramMap.put("lawyerEdu", infoMap.get("lawyerEdu"));
	        paramMap.put("selectedBoards", selectedBoards);
	        paramMap.put("licenseList", licenseList);
	        paramMap.put("deletedLicenseList", deletedLicenseList);
	        paramMap.put("mainCategories1", mainCategories1);
	        paramMap.put("mainCategories2", mainCategories2);
	        paramMap.put("uploadPath", uploadPath);

	        // 7. 서비스 메서드 호출 (DB 업데이트)
	        resultMap = profileService.editLawyer(paramMap);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	    }

	    return new Gson().toJson(resultMap);
	}

    // 리뷰리스트
	@RequestMapping(value = "/profile/reviewList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reviewList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = profileService.getLReviewList(map);
		return new Gson().toJson(resultMap);
	}

	// CATEGORIES_MASTER 테이블의 데이터 가져오기
	@RequestMapping(value = "/profile/getCategories.dox", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCategories() throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			// CATEGORIES_MASTER 데이터 조회
			List<Map<String, Object>> categories = profileService.getCategories();
			resultMap.put("categories", categories);
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
		}

		return new Gson().toJson(resultMap);
	}
}
