package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.TotalDocsMapper;
import com.project.gwasil_zero.model.TotalDocs;

@Service
public class TotalDocsService {
	@Autowired
	TotalDocsMapper totalDocsMapper;

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
			if(map.containsKey("option")){
				totalDocsMapper.updateCnt(map);			
			}
			resultMap.put("info", info);
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

}
