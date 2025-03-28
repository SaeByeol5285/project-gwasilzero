package com.project.gwasil_zero.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.UserMapper;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class UserService {

   @Autowired
   UserMapper userMapper;

   @Autowired
   HttpSession session;

   @Autowired
   PasswordEncoder passwordEncoder;

   // 로그인 및 로그아웃 처리
   public HashMap<String, Object> getInfo(HashMap<String, Object> map) {
      HashMap<String, Object> resultMap = new HashMap<String, Object>();
      User user = userMapper.searchUser(map); // 유저 찾기
      Lawyer lawyer = userMapper.searchLawyer(map); // 변호사 찾기
      boolean loginFlg = false;

      // 유저 로그인 처리
      if (user != null) {
         loginFlg = passwordEncoder.matches(map.get("pwd").toString(), user.getUserPassword()); // 비밀번호 확인
      }
      if (loginFlg) { // 유저 로그인 성공
         resultMap.put("list", userMapper.selectUser(map)); // 유저 정보 조회
         resultMap.put("result", "success");
         session.setAttribute("sessionId", user.getUserId());
         session.setAttribute("sessionName", user.getUserName());
         session.setAttribute("sessionStatus", user.getUserStatus());  
         session.setAttribute("role", "user"); // 25.03.28 연주가 추가
         
      } else if (lawyer != null && lawyer.getLawyerId() != null) { // 변호사 존재하고 lawyerId가 null이 아닌지 확인
         loginFlg = passwordEncoder.matches(map.get("pwd").toString(), lawyer.getLawyerPwd()); // 비밀번호 확인
         if (loginFlg) { // 변호사 로그인 성공
            resultMap.put("list", userMapper.selectLawyer(map)); // 변호사 정보 조회
            resultMap.put("result", "success");
            session.setAttribute("sessionId", lawyer.getLawyerId());
            session.setAttribute("sessionName", lawyer.getLawyerName());
            session.setAttribute("sessionStatus", lawyer.getLawyerStatus());
            session.setAttribute("role", "lawyer"); // 25.03.28 연주가 추가
         }
      }
      if (!loginFlg) {
         // 로그인 실패
         resultMap.put("result", "fail");
      }
      return resultMap;
   }

   public HashMap<String, Object> searchUser(HashMap<String, Object> map) {
      // TODO Auto-generated method stub
      HashMap<String, Object> resultMap = new HashMap<String, Object>();
      User user = userMapper.CheckUser(map);
      int count = user != null ? 1 : 0;
      resultMap.put("count", count);
      return resultMap;
   }

   public HashMap<String, Object> selectUserId(HashMap<String, Object> map) {
      // TODO Auto-generated method stub
      HashMap<String, Object> resultMap = new HashMap<String, Object>();
      User user = userMapper.selectUserId(map);
      Lawyer lawyer = userMapper.selectLawyerId(map);
      resultMap.put("user", user);
      resultMap.put("lawyer", lawyer);
      resultMap.put("result", "success");
      return resultMap;
   }

   public HashMap<String, Object> selectUserPwd(HashMap<String, Object> map) {
      // TODO Auto-generated method stub
      HashMap<String, Object> resultMap = new HashMap<String, Object>();
      userMapper.selectUserPwd(map);
      resultMap.put("result", "success");
      return resultMap;
   }

}
