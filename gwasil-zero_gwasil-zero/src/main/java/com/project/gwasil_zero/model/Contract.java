package com.project.gwasil_zero.model;

import lombok.Data;

@Data
public class Contract {

	private int contractNo;
	private String userId;
	private String lawyer_Id;
	private int boardNo;
	private int contractPrice;
	private String refundAccuont;
	private String cdate;
	private String contractStatus;
	
}