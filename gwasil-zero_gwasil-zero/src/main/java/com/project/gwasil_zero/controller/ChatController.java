package com.project.gwasil_zero.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.project.gwasil_zero.dao.ChatService;
import com.project.gwasil_zero.model.ChatFile;
import com.project.gwasil_zero.model.ChatMessage;
import com.project.gwasil_zero.model.MessageWrapper;

import jakarta.servlet.http.HttpServletRequest;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

@Controller
public class ChatController {
	
	@Autowired
	ChatService chatService;
	
	@Autowired
	private SimpMessagingTemplate messagingTemplate;
	
	@RequestMapping("/chat/chat.do") 
    public String chat(Model model) throws Exception{
        return "/chat/chat";
    }

	@MessageMapping("/sendMessage")
	@SendTo("/topic/public")
	public MessageWrapper sendMessage(MessageWrapper wrapper) {
	    if ("text".equals(wrapper.getType())) {
	        ChatMessage msg = new ObjectMapper().convertValue(wrapper.getPayload(), ChatMessage.class);
	        msg.setTime(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

	        chatService.saveChatMessage(msg); // ID로 저장
	        chatService.enrichSenderName(msg); // 이름 조회
	        wrapper.setPayload(msg); // 이름 담아서 다시 전송

	    }
	    return wrapper;
	}
	
	@PostMapping("/chat/uploadFiles")
	@ResponseBody
	public List<String> uploadFiles(
	        @RequestParam("files") MultipartFile[] files,
	        @RequestParam("chatNo") int chatNo,
	        @RequestParam("senderId") String senderId,
	        HttpServletRequest request
	) throws IOException {
	    List<String> savedPaths = new ArrayList<>();

	    String realPath = request.getServletContext().getRealPath("/img/chatFile");

	    File dir = new File(realPath);
	    if (!dir.exists()) {
	        dir.mkdirs();
	    }

	    for (MultipartFile file : files) {
	        if (!file.isEmpty()) {
	            String originalName = file.getOriginalFilename();
	            String newFileName = UUID.randomUUID() + "_" + originalName;
	            File dest = new File(realPath, newFileName);

	            file.transferTo(dest);

	            String filePath = "../img/chatFile/" + newFileName;
	            savedPaths.add(filePath);

	            // DB 저장
	            ChatFile chatFile = new ChatFile();
	            chatFile.setChatNo(chatNo);
	            chatFile.setSenderId(senderId);
	            chatFile.setChatFilePath(filePath);
	            chatFile.setTime(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

	            chatService.enrichSenderName(chatFile);
	            chatService.saveChatFile(chatFile);
	        }
	    }

	    return savedPaths;
	}

	
	@RequestMapping(value = "/chat/history.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getChatHistory(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = chatService.getChatHistory(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/chat/findOrCreate.dox", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> findOrCreateChat(@RequestParam HashMap<String, Object> map) throws Exception {
	    int chatNo = chatService.findOrCreateChat(map);
	    HashMap<String, Object> result = new HashMap<>();
	    result.put("chatNo", chatNo);
	    return result;
	}
	
	@RequestMapping(value = "/chat/getTargetName.dox", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> getTargetName(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    resultMap = chatService.getTargetName(map);
	    return resultMap;
	}
}