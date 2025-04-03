package com.project.gwasil_zero.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.UserMapper;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class UserService {

	@Autowired
	UserMapper userMapper;

	@Autowired
	HttpSession session;

	@Autowired
	PasswordEncoder passwordEncoder;

	public HashMap<String, Object> getInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		User user = userMapper.searchUser(map);
		Lawyer lawyer = userMapper.searchLawyer(map);
		boolean loginFlg = false;

		if (user != null) {
			if ("OUT".equals(user.getUserStatus())) {
				if (map.get("recover") != null && map.get("recover").equals("true")) {
					int updateCount = userMapper.updateUserStatus(map); // 계정 복구
					if (updateCount > 0) {
						resultMap.put("result", "success");
						resultMap.put("message", "계정이 복구되었습니다.");
					} else {
						resultMap.put("result", "fail");
						resultMap.put("message", "계정 복구에 실패했습니다.");
					}
					return resultMap;
				}
				resultMap.put("result", "fail");
				resultMap.put("message", "탈퇴한 계정입니다. 계정을 복구하시겠습니까?");
				return resultMap;
			}
			loginFlg = passwordEncoder.matches(map.get("pwd").toString(), user.getUserPassword());
		}

		if (loginFlg) {
			resultMap.put("list", userMapper.selectUser(map));
			resultMap.put("result", "success");
			session.setAttribute("sessionId", user.getUserId());
			session.setAttribute("sessionName", user.getUserName());
			session.setAttribute("sessionStatus", user.getUserStatus());
			session.setAttribute("sessionType", "user");
			session.setAttribute("role", "user");
		} else if (lawyer != null && lawyer.getLawyerId() != null) {
			loginFlg = passwordEncoder.matches(map.get("pwd").toString(), lawyer.getLawyerPwd());
			if (loginFlg) {
				resultMap.put("list", userMapper.selectLawyer(map));
				resultMap.put("result", "success");
				session.setAttribute("sessionId", lawyer.getLawyerId());
				session.setAttribute("sessionName", lawyer.getLawyerName());
				session.setAttribute("sessionStatus", lawyer.getLawyerStatus());
				session.setAttribute("sessionType", "lawyer");
				session.setAttribute("role", "lawyer");
			}
		}

		if (!loginFlg) {
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> searchUser(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    User user = userMapper.CheckUser(map); // 일반 유저 조회
	    Lawyer lawyer = userMapper.CheckLawyer(map); // 변호사 조회

	    int count = (user != null || lawyer != null) ? 1 : 0;

	    if (user != null) {
	        resultMap.put("userId", user.getUserId());
	        resultMap.put("userName", user.getUserName());
	        resultMap.put("userType", "user");
	    } else if (lawyer != null) {
	        resultMap.put("userId", lawyer.getLawyerId());
	        resultMap.put("userName", lawyer.getLawyerName());
	        resultMap.put("userType", "lawyer");
	    }

	    resultMap.put("count", count);
	    return resultMap;
	}


	public HashMap<String, Object> selectUserPwd(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		userMapper.selectUserPwd(map);
		resultMap.put("result", "success");
		return resultMap;
	}
	
	public HashMap<String, Object> updateUserPassword(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		String id = (String) map.get("id");
		String rawPwd = (String) map.get("pwd");
		String encodedPwd = passwordEncoder.encode(rawPwd);
		map.put("pwd", encodedPwd);
		map.put("id", id);

		User user = userMapper.searchUser(map);
		if (user != null) {
			int result = userMapper.updateUserPassword(map);
			resultMap.put("result", result > 0 ? "success" : "fail");
			return resultMap;
		}

		Lawyer lawyer = userMapper.searchLawyer(map);
		if (lawyer != null) {
			int result = userMapper.updateLawyerPassword(map);
			resultMap.put("result", result > 0 ? "success" : "fail");
			return resultMap;
		}

		resultMap.put("result", "fail");
		resultMap.put("message", "사용자 정보 없음");
		return resultMap;
	}
	
	public HashMap<String, Object> checkUserIdExist(HashMap<String, Object> map) {
		map.put("id", map.get("userId"));
		User user = userMapper.searchUser(map);
		Lawyer lawyer = userMapper.searchLawyer(map);

		HashMap<String, Object> result = new HashMap<>();
		result.put("count", (user != null || lawyer != null) ? 1 : 0);
		return result;
	}
	

}
