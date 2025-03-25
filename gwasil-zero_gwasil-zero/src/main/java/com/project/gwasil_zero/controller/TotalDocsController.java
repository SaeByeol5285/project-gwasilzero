package com.project.gwasil_zero.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.project.gwasil_zero.dao.TotalDocsService;
@Controller
public class TotalDocsController {
	@Autowired
	TotalDocsService totalDocsService;
	
	// 공지사항 리스트
	@RequestMapping("/notice/list.do") 
    public String noticeList(Model model) throws Exception{
        return "/totalDocs/notice-list";
    }
	
	// 공지사항 상세보기
	@RequestMapping("/notice/detail.do") 
	public String noticeDetail(Model model) throws Exception{
		return "/totalDocs/notice-detail";
	}
	
	// 글쓰기
	@RequestMapping("/notice/add.do") 
	public String noticeAdd(Model model) throws Exception{
		return "/totalDocs/notice-add";
	}
	
	// qna 리스트
	@RequestMapping("/qna/list.do") 
    public String qnaList(Model model) throws Exception{
        return "/totalDocs/qna-list";
    }
	
	// qna 상세보기
	@RequestMapping("/qna/detail.do") 
	public String qnaDetail(Model model) throws Exception{
		return "/totalDocs/qna-detail";
	}
	
	// qna 질문등록
	@RequestMapping("/qna/write.do") 
	public String qnaWrite(Model model) throws Exception{
		return "/totalDocs/qna-write";
	}
	
	// qna 답변등록
	@RequestMapping("/qna/answer.do") 
	public String qnaAnswer(Model model) throws Exception{
		return "/totalDocs/qna-answer";
	}
	
	
	// 가이드라인 리스트
	// 가이드라인 상세보기
	
	
//	@RequestMapping(value = "/menu.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
//	@ResponseBody
//	public String add(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
//		HashMap<String, Object> resultMap = new HashMap<String, Object>();
//		return new Gson().toJson(resultMap);
//	}

}
