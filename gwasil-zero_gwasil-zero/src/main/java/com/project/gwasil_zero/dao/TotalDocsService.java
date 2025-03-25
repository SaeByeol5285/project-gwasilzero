package com.project.gwasil_zero.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.TotalDocsMapper;

@Service
public class TotalDocsService {
	@Autowired
	TotalDocsMapper totalDocsMapper;
	

}
