package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.User;

@Mapper
public interface MypageMapper {

	List<User> selectUser(HashMap<String, Object> map);

	int deleteUser(HashMap<String, Object> map);

}
