package com.project.gwasil_zero.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.AdminMapper;

@Service
public class AdminService {
	
	@Autowired
	AdminMapper adminMapper;

}
