package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.BoardFile;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.License;

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
    List<BoardFile> lawyerBoardFileList(Map<String, Object> map);
    List<License> lawyerLicenseList(Map<String, Object> map);

    // 수정
    void updateLawyer(Map<String, Object> map);

    // 라이선스 갱신
    void deleteLicenseByLawyerId(String lawyerId);
    void insertLicense(Map<String, Object> license);
	
}
