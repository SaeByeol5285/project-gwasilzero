package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Review;

@Mapper
public interface ReviewMapper {

	List<Review> selectAvailableReviewList(HashMap<String, Object> map);

	int insertReview(HashMap<String, Object> map);
	
	
	

}
