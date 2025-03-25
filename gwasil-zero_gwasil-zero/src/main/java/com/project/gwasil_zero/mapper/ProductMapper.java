package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ProductMapper {

	List<Package> selectPackageList(HashMap<String, Object> map);

	void deleteProductList(HashMap<String, Object> map);

	void insertProduct(HashMap<String, Object> map);

}
