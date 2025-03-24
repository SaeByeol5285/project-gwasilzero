package com.project.gwasil_zero.model;

import lombok.Data;

@Data
public class Pay {

	private String orderId;
	private String packageName;
	private String payTime;
	private String userId;
	private String lawyerId;
	private String payStatus;
	private String packagePrice;
}
