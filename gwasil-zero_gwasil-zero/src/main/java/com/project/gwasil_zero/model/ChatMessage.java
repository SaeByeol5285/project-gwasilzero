package com.project.gwasil_zero.model;

import lombok.Data;

@Data
public class ChatMessage {

	private int chatNo;
	private String time;
	private String message;
	private String senderId;
	private String senderName; 

}