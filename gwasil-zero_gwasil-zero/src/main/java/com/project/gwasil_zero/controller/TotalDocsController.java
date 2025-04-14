package com.project.gwasil_zero.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.project.gwasil_zero.common.Common;
import com.project.gwasil_zero.dao.TotalDocsService;

import jakarta.servlet.http.HttpSession;

@Controller
public class TotalDocsController {
	@Autowired
	TotalDocsService totalDocsService;

	// 리스트
	@RequestMapping("/totalDocs/list.do")
	public String docsList(@RequestParam Map<String, Object> map, Model model) throws Exception {
		model.addAttribute("map", map);
		return "/totalDocs/docs-list";
	}

	// 상세보기
	@RequestMapping("/totalDocs/detail.do")
	public String docsDetail(@RequestParam Map<String, Object> map, Model model) throws Exception {
		model.addAttribute("map", map);
		return "/totalDocs/docs-detail";
	}

	// 글수정
	@RequestMapping("/totalDocs/edit.do")
	public String docsEdit(@RequestParam Map<String, Object> map, Model model) throws Exception {
		model.addAttribute("map", map);
		return "/totalDocs/docs-edit";
	}

	// 공지사항 글쓰기
	@RequestMapping("/totalDocs/addNotice.do")
	public String noticeAdd(Model model) throws Exception {
		return "/totalDocs/notice-add";
	}
	
	// 이용문의 글쓰기
	@RequestMapping("/totalDocs/addHelp.do")
	public String helpAdd(Model model) throws Exception {
		return "/totalDocs/help-add";
	}
	
	// 가이드라인 전체
	@RequestMapping("/totalDocs/guide.do")
	public String guideList(Model model) throws Exception {
		return "/totalDocs/guide-list";
	}


	// 리스트
	@RequestMapping(value = "/totalDocs/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String docsList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = totalDocsService.getDocsList(map);
		return new Gson().toJson(resultMap);
	}

	// 상세보기
	@RequestMapping(value = "/totalDocs/view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String docsView(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = totalDocsService.getDocsInfo(map);
		return new Gson().toJson(resultMap);
	}

	// 이전글,다음글
	@RequestMapping(value = "/totalDocs/adjacent.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String docsAdjacent(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = totalDocsService.getAdjacent(map);
		return new Gson().toJson(resultMap);
	}

	// 글수정
	@RequestMapping("/totalDocs/edit.dox")
	@ResponseBody
	public HashMap<String, Object> editNotice(@RequestParam HashMap<String, Object> map,
			@RequestParam(value = "file1", required = false) List<MultipartFile> files,
			@RequestParam(value = "deleteList", required = false) List<String> deleteList) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			totalDocsService.editDocs(map); // 제목, 내용만 수정
			
			// 선택한 첨부파일 삭제
			if (deleteList != null) {
			    for (String path : deleteList) {
			        HashMap<String, Object> delMap = new HashMap<>();
			        delMap.put("filePath", path);
			        totalDocsService.deleteFile(delMap);
			    }
			}

			// 파일 업로드 처리
			if (files != null && !files.isEmpty()) {
				for (MultipartFile file : files) {
					String originFilename = file.getOriginalFilename();
					String extName = originFilename.substring(originFilename.lastIndexOf("."));
					String saveFileName = Common.genSaveFileName(extName);

					String path = System.getProperty("user.dir") + "\\src\\main\\webapp\\img";
					File dest = new File(path, saveFileName);
					file.transferTo(dest);

					HashMap<String, Object> fileMap = new HashMap<>();
					fileMap.put("totalNo", map.get("totalNo"));
					fileMap.put("fileName", originFilename);
					fileMap.put("filePath", "../img/" + saveFileName);

					totalDocsService.insertFile(fileMap);
				}
			}
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
	
	// 글삭제
	@RequestMapping(value = "/totalDocs/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String docsRemove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = totalDocsService.removeDocs(map);
		return new Gson().toJson(resultMap);
	}
	
	// 글쓰기
	@RequestMapping(value = "/totalDocs/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String docsAdd(Model model, @RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    // 임시로 관리자 권한 부여
	    String sessionStatus = (String) session.getAttribute("sessionStatus");
	    String kind = (String) map.get("kind");

	    //공지사항은 관리자만 작성 가능
	    if ("NOTICE".equals(kind) && !"ADMIN".equals(sessionStatus)) {
	        resultMap.put("result", "forbidden");
	        resultMap.put("message", "관리자만 공지사항을 등록할 수 있습니다.");
	        return new Gson().toJson(resultMap);
	    }

	    // 그 외 종류는 일반 사용자도 등록 가능
	    resultMap = totalDocsService.addDocs(map);
	    return new Gson().toJson(resultMap);
	}
	
	// quill 이미지 파일 
	@RequestMapping(value = "/upload/image.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String uploadImage(@RequestParam("image") MultipartFile file) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    String path = System.getProperty("user.dir") + "\\src\\main\\webapp\\img";
	    
	    try {
	        if (!file.isEmpty()) {
	            String originFilename = file.getOriginalFilename();
	            String extName = originFilename.substring(originFilename.lastIndexOf("."));
	            String saveFileName = Common.genSaveFileName(extName);

	            File saveFile = new File(path, saveFileName);
	            file.transferTo(saveFile);

	            resultMap.put("result", "success");
	            resultMap.put("url", "/img/" + saveFileName); // ← 이 URL을 Quill이 삽입함
	        } else {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "파일이 비어있습니다.");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", "업로드 중 오류 발생");
	    }

	    return new Gson().toJson(resultMap);
	}



	// 글쓰기 첨부파일
	@RequestMapping(value = "/fileUpload.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String result(@RequestParam("file1") List<MultipartFile> files, @RequestParam("totalNo") int totalNo,
			Model model) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		String url = null;
		String path = "c:\\img";
		try {
			for (MultipartFile multi : files) {
				String uploadpath = path;
				String originFilename = multi.getOriginalFilename();
				String extName = originFilename.substring(originFilename.lastIndexOf("."), originFilename.length());
				long size = multi.getSize();
				String saveFileName = Common.genSaveFileName(extName);

				String path2 = System.getProperty("user.dir");

				if (!multi.isEmpty()) {
					File file = new File(path2 + "\\src\\main\\webapp\\img", saveFileName);
					multi.transferTo(file);

					HashMap<String, Object> map = new HashMap<String, Object>();
					map.put("totalNo", totalNo);
					map.put("filePath", "../img/" + saveFileName);
					map.put("fileName", originFilename);

					// insert 쿼리 실행
					resultMap = totalDocsService.addFiles(map);
				}
			}
			return new Gson().toJson(resultMap); // redirect:주소 => 리턴하면서 페이지 이동됨
		} catch (Exception e) {
		}
		return "redirect:/notice/list.do";
	}
	
	// 댓글 리스트 불러오기
	@RequestMapping(value = "/totalDocs/cmtList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String docsCmtList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = totalDocsService.getCmtList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 댓글추가
	@RequestMapping(value = "/totalDocs/addCmt.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String docsCmtAdd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = totalDocsService.addCmt(map);
		return new Gson().toJson(resultMap);
	}

	// 댓글수정
	@RequestMapping(value = "/totalDocs/editCmt.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String docsCmtEdit(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = totalDocsService.editCmt(map);
		return new Gson().toJson(resultMap);
	}
	
	// 댓글삭제
	@RequestMapping(value = "/totalDocs/removeCmt.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String docsCmtRemove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = totalDocsService.removeCmt(map);
		return new Gson().toJson(resultMap);
	}



}
