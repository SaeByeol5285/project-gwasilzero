package com.project.gwasil_zero.model;

import lombok.Data;

@Data
public class Notification {
	
	private int notiNo;
	private String receiverId;
	private String notiType;
	private String contents;
	private boolean isRead;
	private String createdAt;
	private String senderId;
	private int boardNo;
	private int chatNo;
	
}