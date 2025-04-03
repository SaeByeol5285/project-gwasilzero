package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Board;

@Mapper
public interface CommonMapper {
	
	List<Board> selectBoardList(HashMap<String, Object> map);


}
