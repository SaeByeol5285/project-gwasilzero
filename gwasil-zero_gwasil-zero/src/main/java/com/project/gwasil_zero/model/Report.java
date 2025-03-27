package com.project.gwasil_zero.model;

import lombok.Data;

@Data
public class Report {
	
	private int reportNo;
	private String userId;
	private int boardNo;
	private String reportStatus;
	private String cdate;
	private String contents;


}
