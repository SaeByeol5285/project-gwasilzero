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

	List<Lawyer> selectInnerList(HashMap<String, Object> map);

	int selectInnerCnt(HashMap<String, Object> map);
	
	List<Lawyer> selectPersonalList(HashMap<String, Object> map);
	
	int selectPersonalCnt(HashMap<String, Object> map);

	Lawyer selectLawyer(HashMap<String, Object> map);

	List<BoardFile> lawyerBoardFileList(HashMap<String, Object> map);

	List<License> lawyerLicenseList(HashMap<String, Object> map);

	void updateLawyer(HashMap<String, Object> map);
	
}
