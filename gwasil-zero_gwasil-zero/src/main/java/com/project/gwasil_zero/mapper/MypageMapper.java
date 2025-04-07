package com.project.gwasil_zero.mapper;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Board;
import com.project.gwasil_zero.model.Chat;
import com.project.gwasil_zero.model.ChatMessage;
import com.project.gwasil_zero.model.Contract;
import com.project.gwasil_zero.model.Pay;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.Notification;
import com.project.gwasil_zero.model.User;

@Mapper
public interface MypageMapper {
	
	List<Board> selectUserBoardList(HashMap<String, Object> map);

	List<Pay> selectMyPayList(HashMap<String, Object> map);
	
	List<User> selectUserForMypage(HashMap<String, Object> map);

	List<ChatMessage> selectUserChatList(HashMap<String, Object> map);

	int updateUserInfo(HashMap<String, Object> map);
	
	User selectUserInfo(HashMap<String, Object> map);
	
	User selectUserById(HashMap<String, Object> map);

	int deleteUserByAdmin(HashMap<String, Object> map);

	Lawyer selectLawyerView(HashMap<String, Object> map);

	void updateLawyer(HashMap<String, Object> map);

	void deleteLawyer(HashMap<String, Object> map);

	void updateCounsel(HashMap<String, Object> map);

	List<Board> selectLawyerBoard(HashMap<String, Object> map);

	void updateBoardStatus(HashMap<String, Object> map);

	int selectBoardCnt(HashMap<String, Object> map);

	List<Pay> selectLawyerPay(HashMap<String, Object> map);

	void updatePayStatus(HashMap<String, Object> map);

	void updateCancel(HashMap<String, Object> map);

	List<ChatMessage> selectLastChat(HashMap<String, Object> map);

	int selectBoardCount(HashMap<String, Object> map);

	List<Contract> selectContractList(HashMap<String, Object> map);

	Lawyer selectLawyerInfo(HashMap<String, Object> map);

	void updateLawyerImg(Map<String, Object> param);

	void insertNotification(HashMap<String, Object> map);

	List<Notification> selectRefundNoti(HashMap<String, Object> map);

	void updateNoti(HashMap<String, Object> map);

}