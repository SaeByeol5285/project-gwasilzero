package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.ReviewMapper;
import com.project.gwasil_zero.model.Board;
import com.project.gwasil_zero.model.Review;
import com.project.gwasil_zero.model.TotalDocs;

@Service
public class ReviewService {
   @Autowired
   ReviewMapper reviewMapper;


   public HashMap<String, Object> getReviewList(HashMap<String, Object> map) {
      HashMap<String, Object> resultMap = new HashMap<>();
      try {
         List<Review> availReviewList = reviewMapper.selectAvailableReviewList(map);
         List<Review> writtenReviewList = reviewMapper.selectWrittenReviewList(map);         
         resultMap.put("availReviewList", availReviewList);
         resultMap.put("writtenReviewList", writtenReviewList);
         resultMap.put("result", "success");
         
      } catch (Exception e) {
         e.printStackTrace();
         resultMap.put("result", "fail");
      }
      
      return resultMap;
   }


   public HashMap<String, Object> addReview(HashMap<String, Object> map) {
      HashMap<String, Object> resultMap = new HashMap<>();
      try {
         int num = reviewMapper.insertReview(map);
         if(num > 0) {
            resultMap.put("result", "success");
         }else {
            resultMap.put("result", "fail");            
         }
      } catch (Exception e) {
         e.printStackTrace();
         resultMap.put("result", "error");
      }
      return resultMap;
   }


   public HashMap<String, Object> editReview(HashMap<String, Object> map) {
      // TODO Auto-generated method stub
      HashMap<String, Object> resultMap = new HashMap<>();
      try {
         int num = reviewMapper.updateReview(map);
         if(num > 0) {
            resultMap.put("result", "success");
         }else {
            resultMap.put("result", "fail");            
         }
      } catch (Exception e) {
         e.printStackTrace();
         resultMap.put("result", "error");
      }
      return resultMap;
      
   }


   public HashMap<String, Object> removeReview(HashMap<String, Object> map) {
      // TODO Auto-generated method stub
      HashMap<String, Object> resultMap = new HashMap<>();
      try {
         int num = reviewMapper.deleteReview(map);
         if(num > 0) {
            resultMap.put("result", "success");
         }else {
            resultMap.put("result", "fail");            
         }
      } catch (Exception e) {
         e.printStackTrace();
         resultMap.put("result", "error");
      }
      return resultMap;
      
   }


}
