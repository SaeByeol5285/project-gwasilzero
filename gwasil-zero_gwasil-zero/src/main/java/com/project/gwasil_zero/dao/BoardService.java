package com.project.gwasil_zero.dao;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.BoardMapper;
import com.project.gwasil_zero.model.Board;
import com.project.gwasil_zero.model.BoardCmt;
import com.project.gwasil_zero.model.BoardFile;

@Service
public class BoardService {
	@Autowired
	BoardMapper boardMapper;

	public HashMap<String, Object> saveBoard(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			boardMapper.insertBoard(map); // boardNo는 이 map 안에 들어옴
			System.out.println("Inserted Board Map: " + map);

			// boardNo를 BigDecimal로 받고 int로 변환
			Object boardNoObj = map.get("boardNo");
			int boardNo = 0;

			if (boardNoObj instanceof BigDecimal) {
				boardNo = ((BigDecimal) boardNoObj).intValue();
				map.put("boardNo", boardNo);
				boardMapper.insertCategory(map);
			} else if (boardNoObj instanceof Integer) {
				boardNo = (Integer) boardNoObj;
			}

			resultMap.put("result", "success");
			resultMap.put("boardNo", boardNo);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "failed");
		}

		return resultMap;
	}

	public HashMap<String, Object> saveBoardFile(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			boardMapper.insertBoardFile(map);
			System.out.println(map);
			resultMap.put("fileResult", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("fileResult", "failed");
		}

		return resultMap;
	}

	public HashMap<String, Object> getBoardList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Board> boardList = boardMapper.selectBoardList(map);
			int count = boardMapper.selectBoardCnt(map);
			resultMap.put("list", boardList);
			resultMap.put("result", "success");
			resultMap.put("count", count);

			System.out.println(count);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "failed");
		}

		return resultMap;
	}

	public HashMap<String, Object> getBoard(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Board board = boardMapper.selectBoard(map);
			List<BoardFile> bf = boardMapper.selectBoardFiles(map);
			List<BoardCmt> bc = boardMapper.selectBoardCmttList(map);
			System.out.println(map);
			resultMap.put("result", "success");
			resultMap.put("board", board);
			resultMap.put("boardFile", bf);
			resultMap.put("comment", bc);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "failed");
		}

		return resultMap;
	}

	public HashMap<String, Object> commentAdd(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			boardMapper.insertBoardCmt(map);
			System.out.println(map);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "failed");
		}

		return resultMap;
	}
}
