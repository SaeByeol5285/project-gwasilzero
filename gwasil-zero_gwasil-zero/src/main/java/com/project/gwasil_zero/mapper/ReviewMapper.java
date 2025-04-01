package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Review;

@Mapper
public interface ReviewMapper {

	//작성가능 리뷰
	List<Review> selectAvailableReviewList(HashMap<String, Object> map);

	//작성완료 리뷰
	List<Review> selectWrittenReviewList(HashMap<String, Object> map);
	
	//리뷰 작성
	int insertReview(HashMap<String, Object> map);

	//리뷰 수정
	int updateReview(HashMap<String, Object> map);

	//리뷰 삭제
	int deleteReview(HashMap<String, Object> map);

	
	
	

}
