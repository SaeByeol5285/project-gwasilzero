package com.project.gwasil_zero.mapper;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Board;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.User;

@Mapper
public interface MypageMapper {

   User selectUserInfo(HashMap<String, Object> map);

   void updateUser(HashMap<String, Object> map);

   void updateStatus(HashMap<String, Object> map);

   Lawyer selectLawyerInfo(HashMap<String, Object> map);

   void updateLawyer(HashMap<String, Object> map);

   void deleteLawyer(HashMap<String, Object> map);

   void updateCounsel(HashMap<String, Object> map);

   List<Board> selectLawyerBoard(HashMap<String, Object> map);

   void updateBoardStatus(HashMap<String, Object> map);

   int selectBoardCnt(HashMap<String, Object> map);

}