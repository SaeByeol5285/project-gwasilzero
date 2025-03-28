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
   
   

   // 마이페이지
   @RequestMapping("/mypage-home.do")
   public String mypage(@RequestParam Map<String, Object> map, Model model) throws Exception {
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

}
