package com.project.gwasil_zero.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.ProfileMapper;
import com.project.gwasil_zero.model.Board;
import com.project.gwasil_zero.model.BoardFile;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.License;

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

	public HashMap<String, Object> editLawyer(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			// 1. LAWYER 기본 정보 수정
			profileMapper.updateLawyer(map);
			
			resultMap.put("result", "success");
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
		
	}

	public HashMap<String, Object> editLicense(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
	        String lawyerId = (String) map.get("lawyerId");
	        Object rawList = map.get("licenseList");

	        List<Map<String, Object>> licenseList = new ArrayList<>();
	        
	        // 디버깅용 데이타 확인
//	        System.out.println("=== [editLicense] ===");
//	        System.out.println("lawyerId: " + lawyerId);
//	        System.out.println("rawList: " + rawList);

	        if (rawList instanceof List) {
	            for (Object item : (List<?>) rawList) {
	                if (item instanceof Map) {
	                    Map<String, Object> licenseItem = (Map<String, Object>) item;

	                    // 공백 체크 및 null 방지
	                    String licenseName = (String) licenseItem.get("licenseName");
	                    if (licenseName != null && !licenseName.trim().isEmpty()) {
	                        licenseItem.put("lawyerId", lawyerId); // FK 설정
	                        licenseList.add(licenseItem);
	                    }
	                }
	            }
	        }

	        // 디버깅 로그
//	        System.out.println("=== [editLicense] lawyerId: " + lawyerId);
//	        System.out.println("=== [editLicense] 최종 등록될 licenseList: " + licenseList);

	        // 기존 삭제 후 삽입
	        profileMapper.deleteLicenseByLawyerId(lawyerId);
	        for (Map<String, Object> license : licenseList) {
	            profileMapper.insertLicense(license);
	        }

	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	    }

	    return resultMap;
	}

	public void editMainCases(HashMap<String, Object> map) {
	    try {
	        String lawyerId = (String) map.get("lawyerId");
	        Object rawList = map.get("selectedBoards");

	        List<Integer> boardNoList = new ArrayList<>();
	        if (rawList instanceof List) {
	            for (Object item : (List<?>) rawList) {
	                try {
	                    boardNoList.add(Integer.parseInt(String.valueOf(item)));
	                } catch (Exception e) {
	                    System.out.println("Invalid boardNo: " + item);
	                }
	            }
	        }

	        Integer case1 = boardNoList.size() > 0 ? boardNoList.get(0) : null;
	        Integer case2 = boardNoList.size() > 1 ? boardNoList.get(1) : null;
	        Integer case3 = boardNoList.size() > 2 ? boardNoList.get(2) : null;
	       
	        HashMap<String, Object> param = new HashMap<>();
	        param.put("lawyerId", lawyerId);
	        param.put("mainCase1No", case1);
	        param.put("mainCase2No", case2);
	        param.put("mainCase3No", case3);

	        profileMapper.updateMainCases(param);

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

}
