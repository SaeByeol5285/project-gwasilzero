package com.project.gwasil_zero.model;

import lombok.Data;

@Data
public class Review {
	
	private int reviewNo;
	private String userId;
	private String lawyerId;
	private int score;
	private String contents;
	private String cdate;
	private String udate;
	private int boardNo;
	private String boardTitle;
	private String boardStatus;
	private String lawyerName;
	private String highlight;

}