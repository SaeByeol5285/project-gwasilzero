package com.project.gwasil_zero.model;

import lombok.Data;

@Data
public class Board {
	
	private int boardNo;
	private String boardTitle;
	private String contents;
	private String userId;
	private int cnt;
	private String cdate;
	private String udate;
	private String boardStatus;
	private String lawyerId;
	private String lawyerReview;
	private String thumbnailPath;
	private String lawyerName;
	private String userName;
	
}