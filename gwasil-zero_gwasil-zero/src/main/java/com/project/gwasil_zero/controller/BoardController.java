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


//ffmpeg -i C:\pixelizer\examples\angelina.mp4 -t 60 -vf scale=1024:726 C:\pixelizer\examples\angelina_1min_1024x726.mp4 && python pixelizer.py C:\pixelizer\examples\angelina_1min_1024x726.mp4 C:\pixelizer\examples\testResult_1min.mp4

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

	
	
	@RequestMapping(value = "/menu.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String add(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		return new Gson().toJson(resultMap);
	}
	
	
	
	
	@RequestMapping("/board/fileUpload.dox")
	@ResponseBody
	public HashMap<String, Object> result(@RequestParam("file1") List<MultipartFile> files,
	                                      @RequestParam("title") String title,
	                                      @RequestParam("contents") String contents,
	                                      HttpServletRequest request,
	                                      HttpServletResponse response,
	                                      Model model) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    String path2 = System.getProperty("user.dir");
	    String originPath = path2 + "\\src\\main\\webapp\\img\\originVedio";
	    String cutPathDir = path2 + "\\src\\main\\webapp\\img\\cutVedio";
	    String mosaicPathDir = path2 + "\\src\\main\\webapp\\img\\mosaicVedio";
	    String pythonExec = "C:\\pixelizer_env\\Scripts\\python.exe";
	    String scriptPath = "C:\\pixelizer\\pixelizer.py";

	    try {
	        // 게시판
	        HashMap<String, Object> boardData = new HashMap<>();
	        boardData.put("title", title);
	        boardData.put("contents", contents);
	        boardData.put("userId", 1); // 임시값
	        boardData.put("boardStatus", "A");
	        resultMap = boardService.saveBoard(boardData);
	        int boardNo = (int) resultMap.get("boardNo");

	        // 멀티파트aa
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

	                // 📌 파일 DB 등록
	                HashMap<String, Object> fileMap = new HashMap<>();
	                fileMap.put("boardNo", boardNo);
	                fileMap.put("filePath", "../img/mosaicVedio/mosaic_" + saveFileName);
	                fileMap.put("fileName", "mosaic_" + saveFileName);
	                fileMap.put("fileRealName", originFilename);
	                fileMap.put("thumbnail", "N");
	                boardService.saveBoardFile(fileMap);
	            }
	        }

	        resultMap.put("fileResult", "success");
	        return resultMap;

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("fileResult", "failed");
	        return resultMap;
	    }
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
