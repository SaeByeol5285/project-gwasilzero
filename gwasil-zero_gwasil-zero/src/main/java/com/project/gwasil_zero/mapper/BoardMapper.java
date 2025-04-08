package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Board;
import com.project.gwasil_zero.model.BoardCmt;
import com.project.gwasil_zero.model.BoardFile;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.Pay;

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

	List<BoardFile> selectBoardFiles(HashMap<String, Object> map);

	List<BoardCmt> selectBoardCmttList(HashMap<String, Object> map);

	void insertBoardCmt(HashMap<String, Object> map);
	
	void updateBoardStatus(HashMap<String, Object> map);

	void updateBoard(HashMap<String, Object> map);
	
	void deleteBoardFile(HashMap<String, Object> map);

	void markBoardAsDeleted(HashMap<String, Object> map);

	void deleteBoardCmt(HashMap<String, Object> map);
	
	void updateBoardCmt(HashMap<String, Object> map);
	
	Lawyer checkLawyerStatus(HashMap<String, Object> map);
	
	void insertBoardKeyword(HashMap<String, Object> map);
	
	List<Board> selectRelatedBoards(HashMap<String, Object> map);

	void deleteBoardKeywords(int boardNo);
	
	int increaseViewCount(int boardNo);
	
	int selectPackageCount(HashMap<String, Object> map);
	
	List<Pay> selectAvailablePackages(HashMap<String, Object> map);
	
	void updatePayStatusToUsed(HashMap<String, Object> map);
	
}
