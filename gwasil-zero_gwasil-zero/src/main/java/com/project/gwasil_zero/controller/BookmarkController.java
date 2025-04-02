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
import com.project.gwasil_zero.dao.BookmarkService;

@Controller
public class BookmarkController {
	@Autowired
	BookmarkService bookmarkService;
	
	@RequestMapping("/bookmark/list.do") 
    public String bookmark(Model model) throws Exception{
        return "/bookmark/bookmark-list";
    }
	
	@RequestMapping(value = "/bookmark/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBookmarkList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = bookmarkService.getBookmarkList(map);
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/bookmark/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String bookmarkAdd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = bookmarkService.addBookmark(map);
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/bookmark/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String bookmarkRemove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = bookmarkService.removeBookmark(map);
		return new Gson().toJson(resultMap);
	}
}
