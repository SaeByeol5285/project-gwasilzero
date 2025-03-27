package com.project.gwasil_zero.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.User;

@Mapper
public interface JoinMapper {

	int insertUser(HashMap<String, Object> map);

	User selectUser(HashMap<String, Object> map);

	int insertLawyer(HashMap<String, Object> map);

	Lawyer selectLawyer(HashMap<String, Object> map);

	void updateBoard(HashMap<String, Object> map);

}