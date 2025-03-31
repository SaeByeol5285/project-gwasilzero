package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Bookmark;

@Mapper
public interface BookmarkMapper {

	public List<Bookmark> selectBookmarkList(HashMap<String, Object> map);
	
	public void insertBookmark(HashMap<String, Object> map);
	
	public void deleteBookmark(HashMap<String, Object> map);
}
