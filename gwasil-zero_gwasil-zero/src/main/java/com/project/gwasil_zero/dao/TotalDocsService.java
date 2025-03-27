package com.project.gwasil_zero.dao;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.project.gwasil_zero.mapper.TotalDocsMapper;
import com.project.gwasil_zero.model.TotalDocs;
import com.project.gwasil_zero.model.TotalFile;

@Service
public class TotalDocsService {
	@Autowired
	TotalDocsMapper totalDocsMapper;

	//리스트
	public HashMap<String, Object> getDocsList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<TotalDocs> list = totalDocsMapper.selectDocsList(map);
			int count = totalDocsMapper.selectDocsCnt(map);
			resultMap.put("list", list);
			resultMap.put("count", count);
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
	
	//상세보기
	public HashMap<String, Object> getDocsInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
	        TotalDocs info = totalDocsMapper.selectDocsInfo(map);
			List<TotalFile> imgList = totalDocsMapper.selectImgList(map);
			
			if(map.containsKey("option")){
				totalDocsMapper.updateCnt(map);
			}
			
	        resultMap.put("result", "success");
	        resultMap.put("info", info);
	        resultMap.put("imgList", imgList);
	        
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", e.getMessage());
	    }
	    return resultMap;
	}


	//이전글,다음글
	public HashMap<String, Object> getAdjacent(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			TotalDocs prev = totalDocsMapper.selectPrevDocs(map);
			TotalDocs next = totalDocsMapper.selectNextDocs(map);

			resultMap.put("prev", prev);
			resultMap.put("next", next);
			resultMap.put("result", "success");

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
	
	// 글삭제
	public HashMap<String, Object> removeDocs(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int num = totalDocsMapper.deleteDocs(map);
		if(num > 0) {
			resultMap.put("result", "success");
		} else {
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
	
	//글쓰기
	public HashMap<String, Object> addDocs(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			totalDocsMapper.insertDocs(map);
			System.out.println("key ==> " + map.get("totalNo"));
			resultMap.put("totalNo", map.get("totalNo"));
			resultMap.put("result", "success");

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");

		}
		return resultMap;
	}

	// 글쓰기 첨부파일
	public HashMap<String, Object> addFiles(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		totalDocsMapper.insertFiles(map);
		resultMap.put("result", "success");		
		
		return resultMap;
		
	}


	//제목, 내용 수정
	public HashMap<String, Object> editNotice(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        totalDocsMapper.updateNotice(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
			System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}
	
	// 파일 수정
	public HashMap<String, Object> insertFile(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        totalDocsMapper.insertFile(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
			System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}


	

	


	

}
