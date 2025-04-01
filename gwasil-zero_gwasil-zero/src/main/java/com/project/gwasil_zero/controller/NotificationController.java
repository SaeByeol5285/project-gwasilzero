package com.project.gwasil_zero.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.project.gwasil_zero.dao.NotificationService;

@Controller
public class NotificationController {
	@Autowired
	NotificationService notificationService;
	
	@RequestMapping("/notification/list.do") 
    public String notificationList(Model model) throws Exception{
        return "/notification/notification-list";
    }
	
	@RequestMapping(value = "/notification/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getNotificationList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = notificationService.getNotificationList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/notification/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addNotification(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = notificationService.addNotification(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/notification/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeNotification(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = notificationService.removeNotification(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/notification/read.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String notificationIsRead(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = notificationService.notificationIsRead(map);
		return new Gson().toJson(resultMap);
	}
}
