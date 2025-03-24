package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.User;

@Mapper
public interface AdminMapper {

	List<User> selectNewMemList(HashMap<String, Object> map);

	List<Lawyer> selectLawPassList(HashMap<String, Object> map);
	
}
