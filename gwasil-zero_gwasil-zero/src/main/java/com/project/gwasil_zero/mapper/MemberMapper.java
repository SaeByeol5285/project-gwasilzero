package com.project.gwasil_zero.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Member;

@Mapper
public interface MemberMapper {
	
	Member getMember(HashMap<String, Object> map);

}
