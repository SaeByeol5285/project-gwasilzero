package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.User;

@Mapper
public interface MypageMapper {

	User selectUserInfo(HashMap<String, Object> map);

	void updateUser(HashMap<String, Object> map);

	void updateStatus(HashMap<String, Object> map);


	

}
