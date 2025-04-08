package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.ProductMapper;
import com.project.gwasil_zero.model.Packages;
import com.project.gwasil_zero.model.Pay;

@Service
public class ProductService {
	
	@Autowired
	ProductMapper productMapper;

	public HashMap<String, Object> getProductList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Packages> list = productMapper.selectProductList(map);	
			int productCount = productMapper.selectProductCount(map);
			resultMap.put("productCount", productCount);
			resultMap.put("list", list);
			resultMap.put("result", "success");		
			
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage()); //개발자 확인하기 위한 용도
			resultMap.put("result", "fail");						
		}
		return resultMap;
	}

	public HashMap<String, Object> deleteAll(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		productMapper.deleteProductList(map);
		resultMap.put("result", "success");
		return resultMap;
	}

	public HashMap<String, Object> addProduct(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		productMapper.insertProduct(map);
		resultMap.put("result", "success");
		
		return resultMap;
	}
	
	
	public HashMap<String, Object> getProduct(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		Packages info = productMapper.selectProduct(map);
		
		resultMap.put("info", info);
		resultMap.put("result", "success");
		return resultMap;
	}

	public HashMap<String, Object> editProduct(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		productMapper.updateProduct(map);
		resultMap.put("result", "success");
		return resultMap;
	}

	public HashMap<String, Object> refundProduct(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Pay> refundList = productMapper.selectRefundList(map);		
			int refundCount = productMapper.selectRefundCount(map);
			resultMap.put("refundCount", refundCount);
			resultMap.put("refundList", refundList);
			resultMap.put("result", "success");		
			
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage()); //개발자 확인하기 위한 용도
			resultMap.put("result", "fail");						
		}
		return resultMap;
	}

	public HashMap<String, Object> refundUpdate(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		productMapper.updateRefund(map);
		resultMap.put("result", "success");
		return resultMap;
	}

	public HashMap<String, Object> refundCancel(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		productMapper.CancelRefund(map);
		resultMap.put("result", "success");
		return resultMap;
	}
	
	public HashMap<String, Object> notificationAdd(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		productMapper.insertNotification(map);
	    resultMap.put("result", "success");
	    return resultMap;
	}

}
