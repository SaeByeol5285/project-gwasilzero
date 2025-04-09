package com.project.gwasil_zero.dao;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.project.gwasil_zero.mapper.ProfileMapper;
import com.project.gwasil_zero.model.Board;
import com.project.gwasil_zero.model.BoardFile;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.License;
import com.project.gwasil_zero.model.Review;

@Service
public class ProfileService {
	
	@Autowired
	ProfileMapper profileMapper;
	
	public HashMap<String, Object> getInnerList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Lawyer> list = profileMapper.selectInnerList(map);
			int count = profileMapper.selectInnerCnt(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("count", count);
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getPersonalList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Lawyer> list = profileMapper.selectPersonalList(map);
			int count = profileMapper.selectPersonalCnt(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("count", count);
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> getLawyer(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Lawyer info = profileMapper.selectLawyer(map);
//			System.out.println("mainCategoryName1 = " + info.getMainCategoryName1());
//			System.out.println("mainCategoryName2 = " + info.getMainCategoryName2());
			List<License> license = profileMapper.lawyerLicenseList(map);
			List<Board> boardList = profileMapper.lawyerBoardList(map);
			List<BoardFile> boardFileList = profileMapper.lawyerBoardFileList(map);
			
			resultMap.put("info", info);
			resultMap.put("license", license);
			resultMap.put("boardList", boardList); 
			resultMap.put("boardFileList", boardFileList);
			resultMap.put("result", "success");
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> editLawyer(HashMap<String, Object> paramMap) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    String lawyerId = (String) paramMap.get("lawyerId");
	    String lawyerInfo = (String) paramMap.get("lawyerInfo");
	    String lawyerCareer = (String) paramMap.get("lawyerCareer");
	    String lawyerTask = (String) paramMap.get("lawyerTask");
	    String lawyerEdu = (String) paramMap.get("lawyerEdu");
	    List<Integer> selectedBoards = (List<Integer>) paramMap.get("selectedBoards");
	    List<HashMap<String, Object>> licenseList = (List<HashMap<String, Object>>) paramMap.get("licenseList");
	    List<Map<String, String>> deletedLicenseList = (List<Map<String, String>>) paramMap.get("deletedLicenseList");
	    String uploadPath = (String) paramMap.get("uploadPath");
	    String mainCategories1 = (String) paramMap.get("mainCategories1");
	    String mainCategories2 = (String) paramMap.get("mainCategories2");

	    // 1. LAWYER 테이블 업데이트
	    HashMap<String, Object> param = new HashMap<>();
	    param.put("lawyerId", lawyerId);
	    param.put("lawyerInfo", lawyerInfo);
	    param.put("lawyerCareer", lawyerCareer);
	    param.put("lawyerTask", lawyerTask);
	    param.put("lawyerEdu", lawyerEdu);
	    param.put("mainCategories1", mainCategories1);
	    param.put("mainCategories2", mainCategories2);
	    
	    profileMapper.updateLawyer(param);

	    // 2. 삭제할 LICENSE 항목 처리
	    if (deletedLicenseList != null) {
	        for (Map<String, String> del : deletedLicenseList) {
	            String name = del.get("licenseName");
	            String id = del.get("lawyerId");
	            HashMap<String, Object> delMap = new HashMap<>();
	            delMap.put("lawyerId", id);
	            delMap.put("licenseName", name);
	            profileMapper.deleteLicense(delMap);
	        }
	    }

	    // 3. 신규 LICENSE 삽입
	    for (HashMap<String, Object> license : licenseList) {
	        String licenseName = (String) license.get("licenseName");
	        MultipartFile file = (MultipartFile) license.get("licenseFile");

	        if (file != null && !file.isEmpty()) {
	            String savedName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
	            String savePath = uploadPath + File.separator + savedName;
	            String webPath = "/license/" + savedName;

	            //로그확인
//	            System.out.println(">>> insertLicense: " + licenseName + ", " + webPath);
	            try {
	                file.transferTo(new File(savePath));
	            } catch (Exception e) {
	                e.printStackTrace();
	                throw new Exception("파일 저장 실패: " + e.getMessage());
	            }

	            HashMap<String, Object> fileMap = new HashMap<>();
	            fileMap.put("lawyerId", lawyerId);
	            fileMap.put("licenseName", licenseName);
	            fileMap.put("licenseFilePath", webPath);
	            
	            // 로그 확인용
//	            System.out.println(">> DB 저장 직전: " + fileMap);
	    	            
	            profileMapper.insertLicense(fileMap);
	        } else {
	            throw new Exception("[" + licenseName + "] 자격증 파일이 첨부되지 않았습니다.");
	        }
	    }

	    // 4. 대표 사건 업데이트
	    editMainCases(paramMap);
	    
	    // 5. 전문 분야 업데이트 (NEW)
//	    String mainCategories1 = (String) paramMap.get("mainCategories1");
//	    String mainCategories2 = (String) paramMap.get("mainCategories2");
//
//	    HashMap<String, Object> categoriesParam = new HashMap<>();
//	    categoriesParam.put("lawyerId", lawyerId);
//	    categoriesParam.put("mainCategories1", mainCategories1);
//	    categoriesParam.put("mainCategories2", mainCategories2);
//	    profileMapper.updateLawyerCategories(categoriesParam);    
	    
	    resultMap.put("result", "success");
	    return resultMap;
	}

	public void editMainCases(HashMap<String, Object> paramMap) {
	    try {
	        String lawyerId = (String) paramMap.get("lawyerId");
	        List<?> boardNoListRaw = (List<?>) paramMap.get("selectedBoards");
	        List<Integer> boardNoList = new ArrayList<>();

	        for (Object item : boardNoListRaw) {
	            try {
	                boardNoList.add(Integer.parseInt(String.valueOf(item)));
	            } catch (Exception e) {
	                System.out.println("Invalid boardNo: " + item);
	            }
	        }

	        HashMap<String, Object> param = new HashMap<>();
	        param.put("lawyerId", lawyerId);
	        param.put("mainCase1No", boardNoList.size() > 0 ? boardNoList.get(0) : null);
	        param.put("mainCase2No", boardNoList.size() > 1 ? boardNoList.get(1) : null);
	        param.put("mainCase3No", boardNoList.size() > 2 ? boardNoList.get(2) : null);

	        profileMapper.updateMainCases(param);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	public List<Map<String, Object>> getCategories() {
		return profileMapper.selectCategories(); 
	}
  
	public HashMap<String, Object> getLReviewList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<Review> list = profileMapper.selectReviewList(map);
			int count = profileMapper.selectReviewCnt(map);			
			resultMap.put("list", list);
			resultMap.put("count", count);
			
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "failed");
		}

		return resultMap;	
		}

}