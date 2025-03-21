package com.project.gwasil_zero.model;

import lombok.Data;

@Data
public class Member {

	private String userId;
	private String userName;
	private String address;
	private String status;
	private String password;
	
// 롬복을 쓰면 아래의 get set 없어도 된다
// 사용법은 @Data import	
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
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}

	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
}
