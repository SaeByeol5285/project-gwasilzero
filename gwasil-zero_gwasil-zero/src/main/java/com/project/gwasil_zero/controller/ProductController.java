package com.project.gwasil_zero.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.project.gwasil_zero.dao.ProductService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ProductController {
	
	@Autowired
	ProductService productService;
	
	
	@RequestMapping("/admin/product.do") 
	public String adminProduct(@RequestParam(value = "page", required = false) String page, Model model) {
		if (page == null || page.isEmpty()) {
	        page = "main";
	    }
		
		model.addAttribute("currentPage", page);
        return "/product/product"; 
    }
	
	@RequestMapping("/admin/product/add.do") 
    public String add(Model model) throws Exception{
		
        return "/product/product-add"; 
    }
	
	@RequestMapping("/admin/product/edit.do") 
    public String edit(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
        return "/product/product-edit"; 
    }
	
	
	
	// 패키지 목록
	@RequestMapping(value = "/admin/product.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = productService.getProductList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 상품 일괄 삭제
	@RequestMapping(value = "/admin/product/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String selectRemove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
			
		String json = map.get("selectList").toString(); 
		ObjectMapper mapper = new ObjectMapper();
		List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>(){});
		map.put("list", list);
			
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
		resultMap = productService.deleteAll(map);
		return new Gson().toJson(resultMap);
	}
	
	// 상품 추가
	@RequestMapping(value = "/admin/product/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String ProductAdd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
		resultMap = productService.addProduct(map);
		return new Gson().toJson(resultMap);
	}
	
	// 상품 수정
	@RequestMapping(value = "/admin/product/edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String ProductInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = productService.getProduct(map);
		return new Gson().toJson(resultMap);
	}
	
	// 상품 수정 저장
	@RequestMapping(value = "/admin/product/editSave.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String ProductEdit(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
		resultMap = productService.editProduct(map);
		return new Gson().toJson(resultMap);
	}
	
	// 상품 환불 리스트
	@RequestMapping(value = "/admin/product/refund.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String ProductRefund(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
		resultMap = productService.refundProduct(map);
		return new Gson().toJson(resultMap);
	}
	
	// 상품 환불 완료
	@RequestMapping(value = "/admin/product/refund-complete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String refundComplete(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = productService.refundUpdate(map);
		return new Gson().toJson(resultMap);
	}
	
	// 상품 환불 취소
	@RequestMapping(value = "/admin/product/refund-cancel.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String refundCancel(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = productService.refundCancel(map);
		return new Gson().toJson(resultMap);
	}
	
	// 환불 처리 알림
	@RequestMapping(value = "/admin/product/notification.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addAlert(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = productService.notificationAdd(map); // 이게 있어야 함
		return new Gson().toJson(resultMap);
	}
	
}
