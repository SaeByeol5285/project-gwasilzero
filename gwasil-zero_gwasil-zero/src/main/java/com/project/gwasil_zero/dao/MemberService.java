package com.project.gwasil_zero.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.MemberMapper;
import com.project.gwasil_zero.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class MemberService {
	
	@Autowired // 두번째로 만들자
	MemberMapper memberMapper;
	
	@Autowired
	HttpSession session;
	
	public HashMap<String, Object> memberLogin(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		User member = memberMapper.getMember(map);
		// 단일 객체, 행이 여러개면 list로 감싸자
		
		if(member != null){
			System.out.println("로그인 성공");
			session.setAttribute("sessionId", member.getUserId());
			session.setAttribute("sessionName", member.getUserName());
			session.setAttribute("sessionStatus", member.getUserStatus());
			session.setMaxInactiveInterval(60*60); // 세션 지속시간 : 60 * 60초
			
			//session.invalidate(); 로그아웃등 이벤트 발생시 세션 정보 삭제
			//session.removeAttribute("sessionId"); 1개씩 세션 삭제
			
			resultMap.put("result", "success");
			resultMap.put("member", member);
		} else {
			System.out.println("로그인 실패");
			resultMap.put("result", "fail");
		}
		return resultMap;
		 
	}
	

	
	
}
