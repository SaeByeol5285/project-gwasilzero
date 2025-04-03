package com.project.gwasil_zero.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.project.gwasil_zero.dao.BoardService;


@Controller
public class BoardController {
	
	@Autowired
	BoardService boardService;
	
	@RequestMapping("/board/add.do") 
    public String boardAdd(Model model) throws Exception{
        return "/board/board-add";
    }

	@RequestMapping("/board/list.do") 
    public String boardList(Model model) throws Exception{
        return "/board/board-list";
    }
	
	 @RequestMapping("/board/view.do") 
	   public String boardView(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
			
			request.setAttribute("map", map);
			return "/board/board-view";
	   }
	 @RequestMapping("/board/edit.do") 
	   public String boardEdit(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
			
			request.setAttribute("map", map);
			return "/board/board-edit";
	   }
	 
	@RequestMapping(value = "/board/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String board_list(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getBoardList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/board/commentAdd.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String commentAdd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.commentAdd(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/board/view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String boardView(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getBoard(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/board/changeBoardStatus.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String changeBoardStatus(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.changeBoardStatus(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/board/delete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String deleteBoard(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = boardService.markBoardAsDeleted(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/board/commentDelete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String deleteComment(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = boardService.deleteBoardCmt(map);
	    return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/board/commentUpdate.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String commenUpdate(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = boardService.updateBoardCmt(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping("/board/fileUpload.dox")
	@ResponseBody
	public HashMap<String, Object> result(@RequestParam("file1") List<MultipartFile> files,
	                                      @RequestParam("title") String title,
	                                      @RequestParam("contents") String contents,
	                                      @RequestParam("category") String category,
	                                      @RequestParam("sessionId") String sessionId,

	                                      HttpServletRequest request,
	                                      HttpServletResponse response,
	                                      Model model) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    String path2 = System.getProperty("user.dir");
	    String originPath = path2 + "\\src\\main\\webapp\\img\\originVedio";
	    String cutPathDir = path2 + "\\src\\main\\webapp\\img\\cutVedio";
	    String mosaicPathDir = path2 + "\\src\\main\\webapp\\img\\mosaicVedio";
	    String thumbPathDir = path2 + "\\src\\main\\webapp\\img\\thumbnails";
	    String pythonExec = "C:\\pixelizer_env\\Scripts\\python.exe";
	    String scriptPath = "C:\\pixelizer\\pixelizer.py";

	    try {
	        // 게시판 저장
	        HashMap<String, Object> boardData = new HashMap<>();
	        boardData.put("title", title);
	        boardData.put("contents", contents);
	        boardData.put("userId", sessionId);
	        boardData.put("boardStatus", "A");
	        boardData.put("category", category);
	        resultMap = boardService.saveBoard(boardData);
	        int boardNo = (int) resultMap.get("boardNo");

	        // 마지막 파일 정보 저장용
	        String lastMosaicPath = "";
	        String lastOriginFilename = "";
	        String lastSaveFileName = "";

	        for (MultipartFile multi : files) {
	            if (!multi.isEmpty()) {
	                String originFilename = multi.getOriginalFilename();
	                String extName = originFilename.substring(originFilename.lastIndexOf("."));
	                long size = multi.getSize();
	                String saveFileName = genSaveFileName(extName);
	                File savedFile = new File(originPath, saveFileName);
	                multi.transferTo(savedFile);

	                String inputPath = savedFile.getAbsolutePath();
	                String cutPath = cutPathDir + "\\cut_" + saveFileName;
	                String mosaicPath = mosaicPathDir + "\\mosaic_" + saveFileName;

	                // 스크립트 커맨드
	                String fullCommand = String.join(" && ",
	                        "del \"" + mosaicPath + "\"",
	                        "ffmpeg -y -i \"" + inputPath + "\" -t 40 -vf scale=800:600 \"" + cutPath + "\"",
	                        "\"" + pythonExec + "\" \"" + scriptPath + "\" \"" + cutPath + "\" \"" + mosaicPath + "\""
	                );
	                System.out.println("CMD: " + fullCommand);

	                ProcessBuilder pb = new ProcessBuilder("cmd.exe", "/c", fullCommand);
	                pb.redirectErrorStream(true);
	                pb.directory(new File("C:\\pixelizer"));
	                Process process = pb.start();

	                BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
	                String line;
	                while ((line = in.readLine()) != null) {
	                    System.out.println("[CMD] " + line);
	                }
	                process.waitFor();

	                // DB 등록 (thumbnail = N)
	                HashMap<String, Object> fileMap = new HashMap<>();
	                fileMap.put("boardNo", boardNo);
	                fileMap.put("filePath", "../img/mosaicVedio/mosaic_" + saveFileName);
	                fileMap.put("fileName", "mosaic_" + saveFileName);
	                fileMap.put("fileRealName", originFilename);
	                fileMap.put("thumbnail", "N");
	                boardService.saveBoardFile(fileMap);

	                // 마지막 정보 저장
	                lastMosaicPath = mosaicPath;
	                lastSaveFileName = saveFileName;
	                lastOriginFilename = originFilename;
	            }
	        }

	        // 마지막 모자이크 영상에서 썸네일 추출
	        if (!lastMosaicPath.isEmpty()) {
	            String thumbnailName = "thumb_" + lastSaveFileName.replaceAll("\\.[^.]+$", ".jpg");
	            String thumbnailPath = thumbPathDir + "\\" + thumbnailName;

	            String thumbCommand = String.format(
	                    "ffmpeg -y -i \"%s\" -ss 00:00:02.000 -vframes 1 \"%s\"",
	                    lastMosaicPath, thumbnailPath
	            );
	            System.out.println("THUMB CMD: " + thumbCommand);

	            ProcessBuilder thumbPB = new ProcessBuilder("cmd.exe", "/c", thumbCommand);
	            thumbPB.redirectErrorStream(true);
	            Process thumbProcess = thumbPB.start();

	            BufferedReader thumbIn = new BufferedReader(new InputStreamReader(thumbProcess.getInputStream()));
	            String thumbLine;
	            while ((thumbLine = thumbIn.readLine()) != null) {
	                System.out.println("[THUMB] " + thumbLine);
	            }
	            thumbProcess.waitFor();

	            // 썸네일 DB 저장 (thumbnail = Y)
	            HashMap<String, Object> thumbMap = new HashMap<>();
	            thumbMap.put("boardNo", boardNo);
	            thumbMap.put("filePath", "../img/thumbnails/" + thumbnailName);
	            thumbMap.put("fileName", thumbnailName);
	            thumbMap.put("fileRealName", lastOriginFilename);
	            thumbMap.put("thumbnail", "Y");
	            boardService.saveBoardFile(thumbMap);
	        }

	        resultMap.put("fileResult", "success");
	        return resultMap;

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("fileResult", "failed");
	        return resultMap;
	    }
	}

	@RequestMapping(value = "/board/edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String boardEdit(@RequestParam("boardNo") int boardNo,
	                        @RequestParam("boardTitle") String boardTitle,
	                        @RequestParam("contents") String contents,
	                        @RequestParam(value = "files", required = false) List<MultipartFile> files,
	                        @RequestParam(value = "deletedFiles", required = false) List<String> deletedFiles,
	                        HttpServletRequest request) throws Exception {

	    String path2 = System.getProperty("user.dir");
	    String originPath = path2 + "\\src\\main\\webapp\\img\\originVedio";
	    String cutPathDir = path2 + "\\src\\main\\webapp\\img\\cutVedio";
	    String mosaicPathDir = path2 + "\\src\\main\\webapp\\img\\mosaicVedio";
	    String pythonExec = "C:\\pixelizer_env\\Scripts\\python.exe";
	    String scriptPath = "C:\\pixelizer\\pixelizer.py";

	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        // 1. 제목 및 내용 수정
	        HashMap<String, Object> paramMap = new HashMap<>();
	        paramMap.put("boardNo", boardNo);
	        paramMap.put("boardTitle", boardTitle);
	        paramMap.put("contents", contents);
	        boardService.editBoard(paramMap);

	        // 2. 삭제된 파일 처리
	        if (deletedFiles != null) {
	            for (String fileName : deletedFiles) {
	                HashMap<String, Object> delMap = new HashMap<>();
	                delMap.put("boardNo", boardNo);
	                delMap.put("fileName", fileName);
	                boardService.deleteBoardFile(delMap);
	            }
	        }

	        // 3. 새로운 파일 업로드 및 모자이크 처리
	        if (files != null) {
	            for (MultipartFile multi : files) {
	                if (!multi.isEmpty()) {
	                    String originFilename = multi.getOriginalFilename();
	                    String extName = originFilename.substring(originFilename.lastIndexOf("."));
	                    String saveFileName = genSaveFileName(extName);
	                    File savedFile = new File(originPath, saveFileName);
	                    multi.transferTo(savedFile);

	                    // ffmpeg + pixelizer 처리
	                    String inputPath = savedFile.getAbsolutePath();
	                    String cutPath = cutPathDir + "\\cut_" + saveFileName;
	                    String mosaicPath = mosaicPathDir + "\\mosaic_" + saveFileName;

	                    String fullCommand = String.join(" && ",
	                        "del \"" + mosaicPath + "\"",
	                        "ffmpeg -y -i \"" + inputPath + "\" -t 40 -vf scale=800:600 \"" + cutPath + "\"",
	                        "\"" + pythonExec + "\" \"" + scriptPath + "\" \"" + cutPath + "\" \"" + mosaicPath + "\""
	                    );

	                    ProcessBuilder pb = new ProcessBuilder("cmd.exe", "/c", fullCommand);
	                    pb.redirectErrorStream(true);
	                    pb.directory(new File("C:\\pixelizer"));
	                    Process process = pb.start();

	                    BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
	                    String line;
	                    while ((line = in.readLine()) != null) {
	                        System.out.println("[EDIT CMD] " + line);
	                    }
	                    process.waitFor();

	                    // DB에 저장
	                    HashMap<String, Object> fileMap = new HashMap<>();
	                    fileMap.put("boardNo", boardNo);
	                    fileMap.put("filePath", "../img/mosaicVedio/mosaic_" + saveFileName);
	                    fileMap.put("fileName", "mosaic_" + saveFileName);
	                    fileMap.put("fileRealName", originFilename);
	                    fileMap.put("thumbnail", "N");
	                    boardService.saveBoardFile(fileMap);
	                }
	            }
	        }

	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "failed");
	    }

	    return new Gson().toJson(resultMap);
	}

	
	
	private String genSaveFileName(String extName) {
		String fileName = "";
		
		Calendar calendar = Calendar.getInstance();
		fileName += calendar.get(Calendar.YEAR);
		fileName += calendar.get(Calendar.MONTH);
		fileName += calendar.get(Calendar.DATE);
		fileName += calendar.get(Calendar.HOUR);
		fileName += calendar.get(Calendar.MINUTE);
		fileName += calendar.get(Calendar.SECOND);
		fileName += calendar.get(Calendar.MILLISECOND);
		fileName += extName;
		
		return fileName;
	}
}
