package com.project.gwasil_zero.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.MypageMapper;

@Service
public class MypageService {

	@Autowired
	MypageMapper mypagemapper;

	public HashMap<String, Object> getList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}
}
