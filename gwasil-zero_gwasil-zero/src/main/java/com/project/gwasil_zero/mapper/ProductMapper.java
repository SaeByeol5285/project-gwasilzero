package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Packages;

@Mapper
public interface ProductMapper {

	List<Packages> selectProductList(HashMap<String, Object> map);

	void deleteProductList(HashMap<String, Object> map);

	void insertProduct(HashMap<String, Object> map);

	Packages selectProduct(HashMap<String, Object> map);

	void updateProduct(HashMap<String, Object> map);

}
