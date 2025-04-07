package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Packages;
import com.project.gwasil_zero.model.Pay;

@Mapper
public interface ProductMapper {

	List<Packages> selectProductList(HashMap<String, Object> map);

	void deleteProductList(HashMap<String, Object> map);

	void insertProduct(HashMap<String, Object> map);

	Packages selectProduct(HashMap<String, Object> map);

	void updateProduct(HashMap<String, Object> map);

	List<Pay> selectRefundList(HashMap<String, Object> map);

	void updateRefund(HashMap<String, Object> map);

	void CancelRefund(HashMap<String, Object> map);

	void insertNotification(HashMap<String, Object> map);

}
