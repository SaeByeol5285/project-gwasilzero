package com.project.gwasil_zero.model;

import lombok.Data;

@Data
public class User {
	
	private String userName;
	private String userPwd;
	private String userStatus;
	private String userPhone;
	private String userId;
	private int reportCnt;
	
	public String getUserStatus() {
		return userStatus;
	}
	public void setUserStatus(String userStatus) {
		this.userStatus = userStatus;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}

}
