package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Notification;

@Mapper
public interface NotificationMapper {
	
	public List<Notification> selectNotificationList(HashMap<String, Object> map);
	
	public void insertNotification(HashMap<String, Object> map);
	
	public void deleteNotification(HashMap<String, Object> map);
	
	public void updateNotification(HashMap<String, Object> map);
	
	public void insertNotificationToMessage(HashMap<String, Object> map);
	
	int countUnreadNotificationByChatNo(HashMap<String, Object> map);
	
	public void boardcastNotification(HashMap<String, Object> map);
	
	public List<String> selectLawyerIdsByStatus(HashMap<String, Object> map);
}
