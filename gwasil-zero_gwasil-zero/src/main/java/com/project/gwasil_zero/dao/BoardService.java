package com.project.gwasil_zero.dao;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.BoardMapper;
import com.project.gwasil_zero.mapper.BookmarkMapper;
import com.project.gwasil_zero.model.Board;
import com.project.gwasil_zero.model.BoardCmt;
import com.project.gwasil_zero.model.BoardFile;
import com.project.gwasil_zero.model.Bookmark;
import com.project.gwasil_zero.model.Lawyer;
@Service
public class BoardService {
	@Autowired
	BoardMapper boardMapper;

	@Autowired
	BookmarkMapper bookmarkMapper;
	
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
			resultMap.put("fileResult","success");
		}catch(Exception e) {
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
			List<Bookmark> bm = bookmarkMapper.selectBookmarkList(map);
			resultMap.put("result","success");
			resultMap.put("board", board);			
			resultMap.put("boardFile", bf);
			resultMap.put("comment", bc);
			resultMap.put("bookmark", bm);
		}catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "failed");
		}

		return resultMap;
	}

	public HashMap<String, Object> commentAdd(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			boardMapper.insertBoardCmt(map);
			resultMap.put("result","success");
			
		}catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "failed");
		}

		return resultMap;
	}
	public HashMap<String, Object> changeBoardStatus(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			boardMapper.updateBoardStatus(map);
			resultMap.put("result","success");
			
		}catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result","failed");
		}
		
		return resultMap;
	}
	public HashMap<String, Object> editBoard(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        // 제목/내용 수정만 처리 (컨트롤러에서 분기)
	        if (map.containsKey("boardTitle") && map.containsKey("contents")) {
	            boardMapper.updateBoard(map); // 이 메서드를 새로 추가해야 함
	        }

	        // 파일이 있다면 board_file 테이블에 추가 (컨트롤러에서 처리)
	        if (map.containsKey("fileList")) {
	            List<HashMap<String, Object>> fileList = (List<HashMap<String, Object>>) map.get("fileList");
	            for (HashMap<String, Object> fileMap : fileList) {
	                boardMapper.insertBoardFile(fileMap);
	            }
	        }

	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "failed");
	    }
	    return resultMap;
	}

	public HashMap<String, Object> deleteBoardFile(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        boardMapper.deleteBoardFile(map);  // 이걸 매퍼에 추가해야 함
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "failed");
	    }
	    return resultMap;
	}
	
	public HashMap<String, Object> markBoardAsDeleted(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        boardMapper.markBoardAsDeleted(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "failed");
	    }
	    return resultMap;
	}
	
	public HashMap<String, Object> deleteBoardCmt(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        boardMapper.deleteBoardCmt(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "failed");
	    }
	    return resultMap;
	}
	public HashMap<String, Object> updateBoardCmt(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        boardMapper.updateBoardCmt(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "failed");
	    }
	    return resultMap;
	}
	
	public HashMap<String, Object> checkLawyerStatus(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
	        Lawyer lawyer = boardMapper.checkLawyerStatus(map);
	        String result = "";
	        if(lawyer.getLawyerPass().equals("Y"))
	        	result = "true";
	        else
	        	result = "false";
	        resultMap.put("result", result);
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "failed");
	    }
	    return resultMap;
    }
	
	
	public void saveBoardKeywords(int boardNo, List<String> keywords) {
	    for (String keyword : keywords) {
	        HashMap<String, Object> keywordMap = new HashMap<>();
	        keywordMap.put("boardNo", boardNo);
	        keywordMap.put("keyword", keyword);
	        boardMapper.insertBoardKeyword(keywordMap);
	    }
	}
	
	public List<Board> getRelatedBoards(int boardNo) {
	    HashMap<String, Object> map = new HashMap<>();
	    map.put("boardNo", boardNo);
	    return boardMapper.selectRelatedBoards(map);
	}
}
