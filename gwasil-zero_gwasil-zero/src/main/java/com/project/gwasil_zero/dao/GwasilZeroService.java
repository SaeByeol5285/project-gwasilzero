package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.GwasilZeroMapper;

import jakarta.servlet.http.HttpSession;


@Service
public class GwasilZeroService {
	
	@Autowired
	GwasilZeroMapper gwasilZeroMapper;
	
	@Autowired
	HttpSession session;
	

}
