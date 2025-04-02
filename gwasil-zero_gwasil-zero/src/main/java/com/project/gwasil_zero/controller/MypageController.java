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
import com.project.gwasil_zero.dao.MypageService;

@Controller
public class MypageController {

   @Autowired
   MypageService mypageService;
   
   

   // 유저 마이페이지
   @RequestMapping("/mypage-home.do")
   public String userMyPage(@RequestParam Map<String, Object> map, Model model) throws Exception {
      model.addAttribute("map", map);
      return "/mypage/mypage-home"; // 뷰 이름 반환
   }

   // 정보수정
   @RequestMapping("/mypage/edit.do")
   public String mypageEdit(@RequestParam Map<String, Object> map, Model model) throws Exception {
      model.addAttribute("map", map);
      return "/mypage/mypage-edit";
   }

   // 회원탈퇴
   @RequestMapping("/mypage/remove.do")
   public String remove(@RequestParam Map<String, Object> map, Model model) throws Exception {
      model.addAttribute("map", map);
      return "/mypage/mypage-remove";
   }

   @RequestMapping(value = "/mypage/mypage-view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String view(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
       System.out.println("map: " + map); // 여기 추가
       HashMap<String, Object> resultMap = mypageService.getUser(map);
       return new Gson().toJson(resultMap);
   }

   @RequestMapping(value = "/mypage/mypage-edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String edit(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
      HashMap<String, Object> resultMap = new HashMap<String, Object>();

      resultMap = mypageService.editUser(map);
      return new Gson().toJson(resultMap);
   }
   
   @RequestMapping(value = "/mypage/mypage-remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String remove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
      HashMap<String, Object> resultMap = new HashMap<String, Object>();

      resultMap = mypageService.removeUser(map);
      return new Gson().toJson(resultMap);
   }
   
   
   // 변호사 마이페이지
   @RequestMapping("/mypage/lawyerMyPage.do")
   public String lawyerMyPage(@RequestParam Map<String, Object> map, Model model) throws Exception {
      model.addAttribute("map", map);
      return "/mypage/lawyerMyPage"; 
   }
   
   // 변호사 마이페이지 정보 보기
   @RequestMapping(value = "/lawyerMyPage/view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String lawyerView(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
       System.out.println("map: " + map); // 여기 추가
       HashMap<String, Object> resultMap = mypageService.getLawyer(map);
       return new Gson().toJson(resultMap);
   }
   
   // 변호사 마이페이지 정보 수정
   @RequestMapping(value = "/lawyerMyPage/edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String lawyerEdit(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
      HashMap<String, Object> resultMap = new HashMap<String, Object>();

      resultMap = mypageService.editLawyer(map);
      return new Gson().toJson(resultMap);
   }
   
   // 변호사 마이페이지 정보 삭제
   @RequestMapping(value = "/lawyerMyPage/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String lawyerRemove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
      HashMap<String, Object> resultMap = new HashMap<String, Object>();

      resultMap = mypageService.removeLawyer(map);
      return new Gson().toJson(resultMap);
   }
   
   // 변호사 상담 상태 
   @RequestMapping(value = "/lawyerMyPage/updateStatus.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String lawyerCounsel(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
      HashMap<String, Object> resultMap = new HashMap<String, Object>();

      resultMap = mypageService.counselUpdate(map);
      return new Gson().toJson(resultMap);
   }
   
   // 변호사가 맡은 사건 게시글 가져오기
   @RequestMapping(value = "/lawyerMyPage/board.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String lawyerBoard(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
       HashMap<String, Object> resultMap = new HashMap<String, Object>();
       resultMap = mypageService.getLawyerBoard(map);
       return new Gson().toJson(resultMap);
   }
   
   // 변호사가 맡은 사건 상태 변경
   @RequestMapping(value = "/lawyerMyPage/updateBoardStatus.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String updateBoardStatus(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
      HashMap<String, Object> resultMap = new HashMap<String, Object>();

      resultMap = mypageService.boardUpdate(map);
      return new Gson().toJson(resultMap);
   }
   
   
}
