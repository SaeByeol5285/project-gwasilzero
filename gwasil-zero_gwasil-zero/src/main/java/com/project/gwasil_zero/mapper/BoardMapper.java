package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Board;

@Mapper
public interface BoardMapper {
	//board추가하고 해당 boardNo리턴
	int insertBoard(HashMap<String, Object> map);
	
	void insertCategory(HashMap<String, Object> map);
	// boardFile추가
	void insertBoardFile(HashMap<String, Object> map);

	Board selectBoard(HashMap<String, Object> map);
	 
	int selectBoardCnt(HashMap<String, Object> map);


	List<Board> selectBoardList(HashMap<String, Object> map);
}
