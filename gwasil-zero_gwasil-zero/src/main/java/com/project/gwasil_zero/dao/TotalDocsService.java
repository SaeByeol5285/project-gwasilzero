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

	//
	public HashMap<String, Object> getNoticeList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<TotalDocs> list = totalDocsMapper.selectNoticeList(map);
			int count = totalDocsMapper.selectNoticeCnt(map);
			resultMap.put("list", list);
			resultMap.put("count", count);
			resultMap.put("result", "success");

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> getNoticeInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			TotalDocs info = totalDocsMapper.selectNoticeInfo(map);
			List<TotalFile>imgList= totalDocsMapper.selectImgList(map);
			if (map.containsKey("option")) {
				totalDocsMapper.updateCnt(map);
			}
			resultMap.put("info", info);
			resultMap.put("imgList", imgList);
			resultMap.put("result", "success");
			

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> getNoticeAdjacent(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			TotalDocs prev = totalDocsMapper.selectPrevNotice(map);
			TotalDocs next = totalDocsMapper.selectNextNotice(map);

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

	public HashMap<String, Object> addNotice(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			totalDocsMapper.insertNotice(map);
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

	public HashMap<String, Object> addFiles(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		totalDocsMapper.insertFiles(map);
		resultMap.put("result", "success");		
		
		return resultMap;
		
	}

	public HashMap<String, Object> removeNotice(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int num = totalDocsMapper.deleteNotice(map);
		if(num > 0) {
			resultMap.put("result", "success");
		} else {
			resultMap.put("result", "fail");
		}
		
		
		return resultMap;
	}

	//제목, 내용 수정
	public HashMap<String, Object> editNotice(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        totalDocsMapper.updateNotice(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
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
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}

	


	

}
