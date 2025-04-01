package com.project.gwasil_zero.controller;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.type.TypeReference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.project.gwasil_zero.dao.MypageService;

@Controller
public class MypageController {

	@Autowired
	MypageService mypageService;
	
	//마이페이지 홈
	@RequestMapping("/mypage-home.do")
	public String search(Model model) throws Exception {

		return "/mypage/mypage-home";
	}
	//마이페이지 회원탈퇴
	@RequestMapping("/mypage-remove.do")
	public String delete(Model model) throws Exception {

		return "/mypage/mypage-remove";
	}
	
	@RequestMapping(value = "/mypage/mypage-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    resultMap = mypageService.getList(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/mypage/removeUser.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeUser(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    System.out.println("🔎 받은 데이터 (Controller): " + map);  // 추가
	    resultMap = mypageService.removeUser(map);  // Service 호출

	    System.out.println("🔎 Controller 응답 데이터: " + resultMap);  // 추가
	    return new Gson().toJson(resultMap);  // 🔥 반환값 null 방지
	}
	
	@RequestMapping(value = "/mypage/my-board-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String myBoardList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    resultMap =  mypageService.selectUserBoardList(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/mypage/my-chat-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String myChatList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    resultMap.put("list", mypageService.selectMyChatList(map));
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/mypage/my-pay-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String myPayList(@RequestParam HashMap<String, Object> map) throws Exception {
//	    System.out.println("📥 [myPayList] 전달받은 userId: " + map.get("userId"));  // 여기 null이면 큰일
	    HashMap<String, Object> resultMap = mypageService.selectMyPayList(map);
	    return new Gson().toJson(resultMap);
	}

}