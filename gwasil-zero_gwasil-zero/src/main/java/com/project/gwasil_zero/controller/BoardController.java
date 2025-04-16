package com.project.gwasil_zero.controller;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.project.gwasil_zero.dao.BoardService;
import com.project.gwasil_zero.model.Board;


@Controller
public class BoardController {
	
	@Autowired
	BoardService boardService;
	
	@RequestMapping("/board/add.do") 
	public String boardAdd(HttpSession session, HttpServletRequest request) throws Exception {
	    String sessionId = (String) session.getAttribute("sessionId");

	    if (sessionId == null || sessionId.equals("")) {
	        // 로그인 안 한 경우, redirect 경로 저장
	        String category = request.getParameter("category"); // 글쓰기 시 파라미터 있을 수 있음
	        session.setAttribute("redirectURI", "/board/add.do" + (category != null ? "?category=" + category : ""));

	        return "redirect:/user/login.do";
	    }

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
	                                      @RequestParam("usedPayOrderId") String usedPayOrderId,
	                                      @RequestParam("usePackage") String usePackage,

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
	        boardData.put("boardStatus", "WAIT");
	        boardData.put("category", category);
	        boardData.put("usedPayOrderId", usedPayOrderId);
	        boardData.put("usePackage", usePackage);
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

	                // 커맨드 실행
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
	                	System.out.println("[SCRIPT LOG] " + line);
	                }
	                process.waitFor();

	                // 모자이크 파일이 없으면 cut 비디오 복사로 대체
	                File mosaicFile = new File(mosaicPath);
	                if (!mosaicFile.exists()) {
	                    Files.copy(
	                        new File(cutPath).toPath(),
	                        mosaicFile.toPath(),
	                        StandardCopyOption.REPLACE_EXISTING
	                    );
	                }

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

	            ProcessBuilder thumbPB = new ProcessBuilder("cmd.exe", "/c", thumbCommand);
	            thumbPB.redirectErrorStream(true);
	            Process thumbProcess = thumbPB.start();

	            BufferedReader thumbIn = new BufferedReader(new InputStreamReader(thumbProcess.getInputStream()));
	            String thumbLine;
	            while ((thumbLine = thumbIn.readLine()) != null) {
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
	        try {
	            String textScriptPath = "C:\\KR-WordRank\\keyword_extract.py";

	            File tempTextFile = File.createTempFile("contents_", ".txt");
	            try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(tempTextFile), StandardCharsets.UTF_8))) {
	                writer.write(contents);
	            }

	            ProcessBuilder pbText = new ProcessBuilder(
	                "python",
	                textScriptPath,
	                tempTextFile.getAbsolutePath()
	            );

	            pbText.redirectErrorStream(true);
	            Process processText = pbText.start();

	            BufferedReader reader = new BufferedReader(new InputStreamReader(processText.getInputStream(), "MS949")); // 또는 UTF-8
	            StringBuilder output = new StringBuilder();
	            String line;
	            while ((line = reader.readLine()) != null) {
	                output.append(line);
	            }

	            int exitCode = processText.waitFor();
	            if (exitCode == 0) {
	                System.out.println(output.toString());

	                // 파이썬에서 출력한 JSON 파싱 후 저장
	                Gson gson = new Gson();
	                Type type = new TypeToken<Map<String, Double>>() {}.getType();
	                Map<String, Double> keywordMap = gson.fromJson(output.toString(), type);

	                List<String> keywords = new ArrayList<>(keywordMap.keySet());

	                // 최대 3개까지만 저장
	                if (keywords.size() > 3) {
	                    keywords = keywords.subList(0, 3);
	                }

	                boardService.saveBoardKeywords(boardNo, keywords);
	            } else {
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        
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
	                    }
	                    process.waitFor();
	                    
	                 // 모자이크 파일이 없으면 cut 비디오 복사로 대체
		                File mosaicFile = new File(mosaicPath);
		                if (!mosaicFile.exists()) {
		                    Files.copy(
		                        new File(cutPath).toPath(),
		                        mosaicFile.toPath(),
		                        StandardCopyOption.REPLACE_EXISTING
		                    );
		                }
	                    
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

	        // 4. 키워드 분석 및 DB 저장
	        try {
	            String textScriptPath = "C:\\KR-WordRank\\keyword_extract.py";
	            
	            File tempTextFile = File.createTempFile("contents_", ".txt");
	            try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(tempTextFile), StandardCharsets.UTF_8))) {
	                writer.write(contents);
	            }

	            ProcessBuilder pbText = new ProcessBuilder(
	            	    "python",
	            	    textScriptPath,
	            	    tempTextFile.getAbsolutePath()  //  본문 파일 경로만 넘김
	            	);

	            pbText.redirectErrorStream(true);
	            Process processText = pbText.start();

	            BufferedReader reader = new BufferedReader(
	            	    new InputStreamReader(processText.getInputStream(), Charset.forName("MS949"))
	            	);
	            StringBuilder output = new StringBuilder();
	            String line;
	            while ((line = reader.readLine()) != null) {
	                output.append(line);
	            }

	            int exitCode = processText.waitFor();
	            if (exitCode == 0) {
	                System.out.println(output.toString());

	                Gson gson = new Gson();
	                Type type = new TypeToken<Map<String, Double>>() {}.getType();
	                Map<String, Double> keywordMap = gson.fromJson(output.toString(), type);

	                List<String> keywords = new ArrayList<>(keywordMap.keySet());

	                // 최대 3개까지만 저장
	                if (keywords.size() > 3) {
	                    keywords = keywords.subList(0, 3);
	                }


					boardService.updateBoardKeywords(boardNo, keywords);
	            } else {

	            }

	        } catch (Exception e) {
	            e.printStackTrace();
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
	
	@RequestMapping(value = "/board/checkLawyerStatus.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String checkLawyerStatus(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.checkLawyerStatus(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/board/related.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getRelatedBoards(@RequestParam("boardNo") int boardNo) {
	    List<Board> relatedBoards = boardService.getRelatedBoards(boardNo);
	    HashMap<String, Object> resultMap = new HashMap<>();
	    resultMap.put("related", relatedBoards);
	    return new Gson().toJson(resultMap);
	}
	
	@PostMapping("/board/increaseView.dox")
	@ResponseBody
	public HashMap<String, Object> increaseView(@RequestParam int boardNo) {
	    HashMap<String, Object> result = new HashMap<>();
	    int updated = boardService.increaseViewCount(boardNo); // 조회수 증가 처리
	    result.put("result", "success");
	    return result;
	}
	
	@PostMapping("/board/packageCount.dox")
	@ResponseBody
	public HashMap<String, Object> getPackageCount(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    resultMap = boardService.getPackageCount(map);
	    return resultMap;
	}
	
	@PostMapping("/board/boardReport.dox")
	@ResponseBody
	public HashMap<String, Object> boardReport(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    resultMap = boardService.boardReport(map);
	    return resultMap;
	}
	
	@PostMapping("/board/addReview.dox")
	@ResponseBody
	public HashMap<String, Object> addReview(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    resultMap = boardService.addReview(map);
	    return resultMap;
	}

	@PostMapping("/board/updateReview.dox")
	@ResponseBody
	public HashMap<String, Object> updateReview(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    resultMap = boardService.updateReview(map);
	    return resultMap;
	}
	
	@PostMapping("/board/reportCheck.dox")
	@ResponseBody
	public HashMap<String, Object> reportCheck(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    resultMap = boardService.reportCheck(map);
	    return resultMap;
	}
	
	@PostMapping("/board/checkUserPacakge.dox")
	@ResponseBody
	public HashMap<String, Object> checkUserPacakge(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    resultMap = boardService.checkUserPacakge(map);
	    return resultMap;
	}
	

	
}
