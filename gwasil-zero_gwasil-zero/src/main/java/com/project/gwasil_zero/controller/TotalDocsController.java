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
	
	// 통합자료실 메인
	@RequestMapping("/totalDocs/main.do") 
    public String main(Model model) throws Exception{
        return "/totalDocs/totalDocs-main";
    }
	
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
	@RequestMapping("/guide/list.do") 
	public String guideList(Model model) throws Exception{
		return "/totalDocs/guide-list";
	}
	
	// 가이드라인 상세보기
	@RequestMapping("/guide/detail.do") 
	public String guideDetail(Model model) throws Exception{
		return "/totalDocs/guide-detail";
	}
	
	

}
