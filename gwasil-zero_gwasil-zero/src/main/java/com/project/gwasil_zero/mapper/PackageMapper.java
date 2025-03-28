package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Packages;
import com.project.gwasil_zero.model.Pay;

@Mapper
public interface PackageMapper {

	List<Packages> selectPackageList(HashMap<String, Object> map);

	void insertPayment(HashMap<String, Object> map);

	List<Pay> selectpayList(HashMap<String, Object> map);
  
}
