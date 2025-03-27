package com.project.gwasil_zero.dao;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.MypageMapper;
import com.project.gwasil_zero.model.User;

@Service
public class MypageService {

   @Autowired
   MypageMapper mypageMapper;

   public HashMap<String, Object> getUser(HashMap<String, Object> map) {
      // TODO Auto-generated method stub
      HashMap<String, Object> resultMap = new HashMap<String, Object>();
      User info = mypageMapper.selectUserInfo(map);
      resultMap.put("info", info);
      return resultMap;
   }

   public HashMap<String, Object> editUser(HashMap<String, Object> map) {
      // TODO Auto-generated method stub
      HashMap<String, Object> resultMap = new HashMap<String, Object>();
      mypageMapper.updateUser(map);
      resultMap.put("result", "success");      
      return resultMap;
   }

   public HashMap<String, Object> removeUser(HashMap<String, Object> map) {
      // TODO Auto-generated method stub
      HashMap<String, Object> resultMap = new HashMap<String, Object>();
      mypageMapper.updateStatus(map);
      resultMap.put("result", "success");      
      return resultMap;
   }

   
}
   
