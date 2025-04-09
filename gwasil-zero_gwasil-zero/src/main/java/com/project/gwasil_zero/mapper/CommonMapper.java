package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Board;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.Review;

@Mapper
public interface CommonMapper {
	
	List<Board> selectBoardList(HashMap<String, Object> map);

	List<Lawyer> selectLawyerList(HashMap<String, Object> map);

	List<Review> selectReviewList(HashMap<String, Object> map);


}
