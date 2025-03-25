package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Packages;

@Mapper
public interface PackageMapper {

	List<Packages> selectPackageList(HashMap<String, Object> map);

	void insertPayment(HashMap<String, Object> map);

}

