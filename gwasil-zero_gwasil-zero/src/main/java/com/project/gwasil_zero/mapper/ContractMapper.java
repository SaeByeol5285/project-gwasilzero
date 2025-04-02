package com.project.gwasil_zero.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Lawyer;

@Mapper
public interface ContractMapper {
	public void insertContract(HashMap<String, Object> map);
	
	public Lawyer selectLawyer(HashMap<String, Object> map);
}
