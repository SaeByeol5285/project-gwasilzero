package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.ChatFile;
import com.project.gwasil_zero.model.ChatMessage;

@Mapper
public interface ChatMapper {

	  void insertChatMessage(ChatMessage message);

	  void insertChatFile(ChatFile file);
	  
	  String selectSenderName(String senderId); // 유저 변호사 페이지 조회해서 이름 갖고옴

	  List<ChatMessage> selectChatMessages(HashMap<String, Object> map);

	  List<ChatFile> selectChatFiles(HashMap<String, Object> map);
	
	  String selectReceiverIdFromChat(HashMap<String, Object> map);
}
