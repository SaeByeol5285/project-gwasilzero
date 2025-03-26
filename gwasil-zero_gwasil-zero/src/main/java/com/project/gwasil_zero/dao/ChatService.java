package com.project.gwasil_zero.dao;

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
    
    
}
