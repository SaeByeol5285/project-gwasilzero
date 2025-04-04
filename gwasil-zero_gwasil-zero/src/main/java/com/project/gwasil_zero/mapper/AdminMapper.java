package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.Report;
import com.project.gwasil_zero.model.User;

@Mapper
public interface AdminMapper {

	List<User> selectNewMemList(HashMap<String, Object> map);

	List<Lawyer> selectLawAdminWaitList(HashMap<String, Object> map);

	List<Report> selectRepoAdminList(HashMap<String, Object> map);

	List<User> selectUserList(HashMap<String, Object> map);

	int userCnt(HashMap<String, Object> map);

	List<Lawyer> selectLawWaitList(HashMap<String, Object> map);

	int selectLawWaitCount(HashMap<String, Object> map);
	
	void updateLawyerPass(HashMap<String, Object> map);

	List<Lawyer> selectLawPassedList(HashMap<String, Object> map);

	int selectLawPassedCount(HashMap<String, Object> map);

	void updateLawyerCencel(HashMap<String, Object> map);

	List<Lawyer> selectLawOutList(HashMap<String, Object> map);

	int selectLawOutCount(HashMap<String, Object> map);

	void updateLawyerComeBack(HashMap<String, Object> map);

	List<Report> selectReportList(HashMap<String, Object> map);

	int selectReportCount(HashMap<String, Object> map);

	void updateReportStatus(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectStatChart(HashMap<String, Object> map);

	List<String> selectAvailableYears();

	List<String> selectAvailableMonths(HashMap<String, Object> map);

	List<String> selectAvailableDays(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectStatPie(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectStatUserLine(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectStatLawyerLine(HashMap<String, Object> map);

	
	
}
