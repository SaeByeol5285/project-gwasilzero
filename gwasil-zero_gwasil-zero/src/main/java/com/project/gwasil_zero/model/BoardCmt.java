package com.project.gwasil_zero.model;

import lombok.Data;

@Data
public class BoardCmt {

	private String cmtNo;
	private String boardNo;
	private String contents;
	private String lawyerId;
	private String lawyerName;
	private String cdate;
	private String udate;

}