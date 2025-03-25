package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PackageMapper {

	List<Package> selectPackageList(HashMap<String, Object> map);

	void insertPayment(HashMap<String, Object> map);

}

