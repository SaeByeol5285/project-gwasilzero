package com.project.gwasil_zero.mapper;

import java.util.HashMap;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.User;

@Mapper
public interface UserMapper {

	List<User> selectUser(HashMap<String, Object> map);

	User searchUser(HashMap<String, Object> map);

	Lawyer searchLawyer(HashMap<String, Object> map);

	List<Lawyer> selectLawyer(HashMap<String, Object> map);

	Lawyer selectLawyerId(HashMap<String, Object> map);

	User CheckUser(HashMap<String, Object> map);

	User selectUserId(HashMap<String, Object> map);

	void selectUserPwd(HashMap<String, Object> map);


	int updateUserStatus(HashMap<String, Object> map);

}