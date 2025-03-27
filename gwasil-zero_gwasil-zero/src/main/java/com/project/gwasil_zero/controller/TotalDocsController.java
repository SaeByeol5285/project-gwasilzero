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
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.project.gwasil_zero.common.Common;
import com.project.gwasil_zero.dao.TotalDocsService;

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

	// 공지사항 수정
	@RequestMapping("/totalDocs/edit.do")
	public String docsEdit(@RequestParam Map<String, Object> map, Model model) throws Exception {
		model.addAttribute("map", map);
		return "/totalDocs/docs-edit";
	}

	// 글쓰기
	@RequestMapping("/totalDocs/add.do")
	public String docsAdd(Model model) throws Exception {
		return "/totalDocs/docs-add";
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
	public Map<String, Object> editNotice(@RequestParam HashMap<String, Object> map,
			@RequestParam(value = "file1", required = false) List<MultipartFile> files) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			totalDocsService.editNotice(map); // 제목, 내용만 수정

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

	// 공지사항 글쓰기
	@RequestMapping(value = "/totalDocs/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String docsAdd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = totalDocsService.addDocs(map);
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

				System.out.println("uploadpath : " + uploadpath);
				System.out.println("originFilename : " + originFilename);
				System.out.println("extensionName : " + extName);
				System.out.println("size : " + size);
				System.out.println("saveFileName : " + saveFileName);
				String path2 = System.getProperty("user.dir");
				System.out.println("Working Directory = " + path2 + "\\src\\webapp\\img");

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
			System.out.println(e);
		}
		return "redirect:/notice/list.do";
	}

	// 공지사항 삭제
	@RequestMapping(value = "/notice/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String noticeRemove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = totalDocsService.removeNotice(map);
		return new Gson().toJson(resultMap);
	}

}
