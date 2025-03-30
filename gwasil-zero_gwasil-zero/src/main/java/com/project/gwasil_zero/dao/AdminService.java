package com.project.gwasil_zero.dao;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.AdminMapper;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.Report;
import com.project.gwasil_zero.model.User;

@Service
public class AdminService {
	
	@Autowired
	AdminMapper adminMapper;

	public HashMap<String, Object> getNewMemList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<User> newMemList = adminMapper.selectNewMemList(map);
						
			resultMap.put("newMemList", newMemList);
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> getLawAdminWaitList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Lawyer> lawAdminWaitList = adminMapper.selectLawAdminWaitList(map);
			
			resultMap.put("lawAdminWaitList", lawAdminWaitList);
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> getRepoAdminList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Report> repoAdminList = adminMapper.selectRepoAdminList(map);
			
			resultMap.put("repoAdminList", repoAdminList);
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> getUserList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<User> userList = adminMapper.selectUserList(map);
			int count = adminMapper.userCnt(map);
						
			resultMap.put("userList", userList);
			resultMap.put("count", count);
			resultMap.put("result", "success");
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> getLawWaitList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Lawyer> lawWaitList = adminMapper.selectLawWaitList(map);
			int count = adminMapper.selectLawWaitCount(map);
			
			resultMap.put("lawWaitList", lawWaitList);
			resultMap.put("count", count);
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public void approveLawyer(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		try {
	        adminMapper.updateLawyerPass(map);  // LAWYER_PASS = 'Y'로 업데이트
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	public HashMap<String, Object> getLawPassedList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Lawyer> lawPassedList = adminMapper.selectLawPassedList(map);
			int count = adminMapper.selectLawPassedCount(map);
			
			resultMap.put("lawPassedList", lawPassedList);
			resultMap.put("count", count);
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public void cencelLawyer(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		try {
	        adminMapper.updateLawyerCencel(map);  // LAWYER_PASS = 'Y'로 업데이트
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	public HashMap<String, Object> getLawOutList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Lawyer> lawOutList = adminMapper.selectLawOutList(map);
			int count = adminMapper.selectLawOutCount(map);
			
			resultMap.put("lawOutList", lawOutList);
			resultMap.put("count", count);
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public void comeBackLawyer(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		try {
	        adminMapper.updateLawyerComeBack(map);  // LAWYER_PASS = 'Y'로 업데이트
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	public HashMap<String, Object> getReportList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Report> reportList = adminMapper.selectReportList(map);
			int count = adminMapper.selectReportCount(map);
			
			resultMap.put("reportList", reportList);
			resultMap.put("count", count);
		} catch(Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public void updateReportStatus(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		try {
	        adminMapper.updateReportStatus(map);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
		
	}

	public HashMap<String, Object> getStatChart(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    // 1. 그룹 타입 기본값 설정
	    String groupType = (String) map.get("groupType");
	    if (groupType == null || groupType.equals("")) {
	        groupType = "monthly"; // 기본값
	    }
	    map.put("groupType", groupType);

	    // 2. 통계 데이터 조회
	    List<HashMap<String, Object>> list = adminMapper.selectStatChart(map);

	    // 3. 카테고리 및 데이터 정리
	    Set<String> categorySet = new TreeSet<>();
	    Set<String> packageSet = new LinkedHashSet<>();
	    Map<String, Map<String, Integer>> chartMap = new LinkedHashMap<>();

	    for (HashMap<String, Object> row : list) {
	        String category = (String) row.get("TIME_GROUP");
	        String pkg = (String) row.get("PACKAGE_NAME");
	        Object priceObj = row.get("TOTAL_PRICE");
	        int price = priceObj != null ? ((BigDecimal) priceObj).intValue() : 0;

	        categorySet.add(category);
	        packageSet.add(pkg);

	        chartMap.putIfAbsent(pkg, new HashMap<>());
	        chartMap.get(pkg).put(category, price);
	    }

	    List<String> categories = new ArrayList<>(categorySet);
	    List<HashMap<String, Object>> series = new ArrayList<>();

	    for (String pkg : packageSet) {
	        HashMap<String, Object> seriesItem = new HashMap<>();
	        seriesItem.put("name", pkg);

	        List<Integer> data = new ArrayList<>();
	        for (String cat : categories) {
	            Integer value = chartMap.get(pkg).get(cat);
	            data.add(value != null ? value : 0);
	        }
	        seriesItem.put("data", data);
	        series.add(seriesItem);
	    }

	    resultMap.put("series", series);
	    resultMap.put("categories", categories);
	    resultMap.put("result", "success");

	    // (선택) 검색조건 반환
	    resultMap.put("startDate", map.get("startDate"));
	    resultMap.put("endDate", map.get("endDate"));

	    return resultMap;
	}

	public HashMap<String, Object> getStatDonut(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        // 도넛 차트용 데이터 조회
	        List<HashMap<String, Object>> list = adminMapper.selectStatDonut(map);

	        List<String> labels = new ArrayList<>();
	        List<Integer> series = new ArrayList<>();

	        for (HashMap<String, Object> row : list) {
	            labels.add((String) row.get("PACKAGE_NAME"));
	            // PRICE는 VARCHAR2라서 TO_NUMBER 처리 후 intValue로 변환
	            BigDecimal price = (BigDecimal) row.get("TOTAL_PRICE");
	            series.add(price.intValue());
	        }

	        resultMap.put("labels", labels);
	        resultMap.put("series", series);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println("도넛 차트 서비스 에러: " + e.getMessage());
	        resultMap.put("result", "fail");
	    }

	    return resultMap;
	}
}
