package com.project.gwasil_zero.mapper;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Board;
import com.project.gwasil_zero.model.Chat;
import com.project.gwasil_zero.model.Pay;
import com.project.gwasil_zero.model.User;

@Mapper
public interface MypageMapper {

	List<User> selectUser(HashMap<String, Object> map);
	
	List<Board> selectUserBoardList(HashMap<String, Object> map);

	List<Pay> selectMyPayList(HashMap<String, Object> map);
	
	List<User> selectUserForMypage(HashMap<String, Object> map);

	List<Chat> selectUserChatList(HashMap<String, Object> map);

	int updateUserInfo(HashMap<String, Object> map);
	
	User selectUserInfo(HashMap<String, Object> map);
	
	User selectUserById(HashMap<String, Object> map);

	int deleteUserByAdmin(HashMap<String, Object> map);

	

}