package com.project.gwasil_zero.controller;

import java.util.HashMap;
import java.util.Map;

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
	public String noticeDetail(@RequestParam Map<String, Object> map, Model model) throws Exception {
	    model.addAttribute("map", map);
	    return "/totalDocs/notice-detail";
	}

	// 공지사항 글쓰기
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
	
	// 공지사항 리스트
	@RequestMapping(value = "/notice/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String noticeList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = totalDocsService.getNoticeList(map);
		return new Gson().toJson(resultMap);
	}
	// 공지사항 상세보기
	@RequestMapping(value = "/notice/view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String noticeView(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = totalDocsService.getNoticeInfo(map);
		return new Gson().toJson(resultMap);
	}
	// 공지사항 이전,다음 글 보기
	@RequestMapping(value = "/notice/adjacent.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String noticeAdjacent(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = totalDocsService.getNoticeAdjacent(map);
		return new Gson().toJson(resultMap);
	}

}
