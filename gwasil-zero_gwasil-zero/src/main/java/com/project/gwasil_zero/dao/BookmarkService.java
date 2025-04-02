package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.BookmarkMapper;
import com.project.gwasil_zero.model.Bookmark;

@Service
public class BookmarkService {
	@Autowired
	BookmarkMapper bookmarkMapper;
	
	
	public HashMap<String, Object> getBookmarkList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<Bookmark> bm = bookmarkMapper.selectBookmarkList(map);
			resultMap.put("list", bm);
			resultMap.put("result","success");
		}catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result","failed");
		}
		return resultMap;
	}
	
	public HashMap<String, Object> addBookmark(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			bookmarkMapper.insertBookmark(map);
			resultMap.put("result","성공적으로 등록되었습니다");
		}catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result","등록 실패");
		}
		return resultMap;
	}
	
	public HashMap<String, Object> removeBookmark(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			bookmarkMapper.deleteBookmark(map);
			resultMap.put("result","성공적으로 삭제되었습니다");
		}catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result","삭제 실패");
		}
		return resultMap;
	}
}
