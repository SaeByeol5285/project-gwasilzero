package com.project.gwasil_zero.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.User;

@Mapper
public interface MemberMapper {
	
	User getMember(HashMap<String, Object> map);

}
