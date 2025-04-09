package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Board;
import com.project.gwasil_zero.model.BoardFile;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.License;
import com.project.gwasil_zero.model.Review;

@Mapper
public interface ProfileMapper {

	// 소속 변호사 리스트
    List<Lawyer> selectInnerList(Map<String, Object> map);
    int selectInnerCnt(Map<String, Object> map);

    // 개인 변호사 리스트
    List<Lawyer> selectPersonalList(Map<String, Object> map);
    int selectPersonalCnt(Map<String, Object> map);

    // 상세 보기
    Lawyer selectLawyer(Map<String, Object> map);
    List<License> lawyerLicenseList(Map<String, Object> map);
    List<Board> lawyerBoardList(Map<String, Object> map);
    List<BoardFile> lawyerBoardFileList(Map<String, Object> map);
    
    // 기본 프로필 수정
    void updateLawyer(HashMap<String, Object> param);
    
    // 자격증 개별 삭제
    void deleteLicense(HashMap<String, Object> delMap);
    
    // LICENSE 삽입
    void insertLicense(HashMap<String, Object> fileMap);
	
    // 대표 사건 업데이트
    void updateMainCases(HashMap<String, Object> param);
    
    // 전문분야 리스트
	List<Map<String, Object>> selectCategories();
	
	// 전문분야 업데이트
//	void updateLawyerCategories(HashMap<String, Object> categoriesParam);

  // 리뷰리스트
	List<Review> selectReviewList(HashMap<String, Object> map);
	
	// 리뷰 개수
	int selectReviewCnt(HashMap<String, Object> map);
	
	
		
}