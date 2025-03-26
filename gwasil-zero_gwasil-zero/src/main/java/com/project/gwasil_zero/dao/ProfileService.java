package com.project.gwasil_zero.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.ProfileMapper;
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
			List<BoardFile> fileList = profileMapper.lawyerBoardFileList(map);
			List<License> license = profileMapper.lawyerLicenseList(map);
			
			resultMap.put("info", info);
			resultMap.put("fileList", fileList);
			resultMap.put("license", license);
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

	        if (rawList instanceof List) {
	            for (Object item : (List<?>) rawList) {
	                if (item instanceof Map) {
	                    licenseList.add((Map<String, Object>) item);
	                }
	            }
	        }

	        // 기존 삭제 후 insert
	        profileMapper.deleteLicenseByLawyerId(lawyerId);
	        for (Map<String, Object> license : licenseList) {
	            license.put("lawyerId", lawyerId);
	            profileMapper.insertLicense(license);
	        }

	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	    }

	    return resultMap;
	}
}
