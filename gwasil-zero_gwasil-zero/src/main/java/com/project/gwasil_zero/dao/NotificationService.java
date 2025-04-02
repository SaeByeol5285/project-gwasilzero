package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.NotificationMapper;
import com.project.gwasil_zero.model.Notification;

@Service
public class NotificationService {
	@Autowired
	NotificationMapper notificationMapper;
	
	public HashMap<String, Object> getNotificationList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<>();
		
		try {
			List<Notification> list = notificationMapper.selectNotificationList(map);
			resultMap.put("result", "success");
			resultMap.put("list", list);
			
		}catch(Exception e) {
			e.printStackTrace();
			resultMap.put("result", "failed");
			
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> addNotification(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<>();
		
		try {
			 notificationMapper.insertNotification(map);
			resultMap.put("result", "success");
			
		}catch(Exception e) {
			e.printStackTrace();
			resultMap.put("result", "failed");
			
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> addNotificationToMessage(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<>();
		
		try {
			 notificationMapper.insertNotificationToMessage(map);
			resultMap.put("result", "success");
			
		}catch(Exception e) {
			e.printStackTrace();
			resultMap.put("result", "failed");
			
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> removeNotification(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<>();
		
		try {
			notificationMapper.deleteNotification(map);
			resultMap.put("result", "success");
			
		}catch(Exception e) {
			e.printStackTrace();
			resultMap.put("result", "failed");
			
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> notificationIsRead(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<>();
		
		try {
			notificationMapper.updateNotification(map);
			resultMap.put("result", "success");
			
		}catch(Exception e) {
			e.printStackTrace();
			resultMap.put("result", "failed");
			
		}
		
		return resultMap;
	}
}
