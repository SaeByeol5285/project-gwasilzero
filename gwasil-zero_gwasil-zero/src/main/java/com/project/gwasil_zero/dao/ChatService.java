package com.project.gwasil_zero.dao;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.ChatMapper;
import com.project.gwasil_zero.model.ChatFile;
import com.project.gwasil_zero.model.ChatMessage;

@Service
public class ChatService {

    @Autowired
    private ChatMapper chatMapper;

    public void saveChatMessage(ChatMessage message) {
        chatMapper.insertChatMessage(message);
    }

    public void saveChatFile(ChatFile file) {
        chatMapper.insertChatFile(file);
    }

    public void enrichSenderName(ChatMessage message) {
        String name = chatMapper.selectSenderName(message.getSenderId());
        message.setSenderName(name);
    }

    public void enrichSenderName(ChatFile file) {
        String name = chatMapper.selectSenderName(file.getSenderId());
        file.setSenderName(name);
    }
    
    public HashMap<String, Object> getChatHistory(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        List<ChatMessage> chatMessageList = chatMapper.selectChatMessages(map);
        List<ChatFile> chatFileList = chatMapper.selectChatFiles(map);

        List<Object> chatHistory = new ArrayList<>();
        chatHistory.addAll(chatMessageList);
        chatHistory.addAll(chatFileList);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        chatHistory.sort(Comparator.comparing(obj -> {
            try {
                if (obj instanceof ChatMessage) {
                    String timeStr = ((ChatMessage) obj).getTime();
                    return LocalDateTime.parse(timeStr, formatter);
                } else if (obj instanceof ChatFile) {
                    String timeStr = ((ChatFile) obj).getTime();
                    return LocalDateTime.parse(timeStr, formatter);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return LocalDateTime.MIN; 
        }));

        resultMap.put("history", chatHistory);
        return resultMap;
    }


}
