package com.project.gwasil_zero.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BoardMapper {
	//board추가하고 해당 boardNo리턴
	int insertBoard(HashMap<String, Object> map);
	// boardFile추가
	void insertBoardFile(HashMap<String, Object> map);
}
