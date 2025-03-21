package com.project.gwasil_zero.dao;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.MemberMapper;
import com.project.gwasil_zero.model.Member;

@Service
public class MemberService {
	
	@Autowired // 두번째로 만들자
	MemberMapper memberMapper;
	
	@Autowired
	HttpSession session;
	
	@Autowired
	PasswordEncoder passwordEncoder;
	
	public HashMap<String, Object> memberLogin(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		Member member = memberMapper.getMember(map);
		// 단일 객체, 행이 여러개면 list로 감싸자
		
		
		// passwordEncoder.matches('해시안한 비밀번호', '해시한 비밀번호')
		// return은 true or false
		
		boolean pwdCheck = false;
		if(member != null){
			pwdCheck = passwordEncoder.matches((String) map.get("pwd"), member.getPassword());
			if(pwdCheck) {
				//System.out.println("로그인 성공");
				session.setAttribute("sessionId", member.getUserId());
				session.setAttribute("sessionName", member.getUserName());
				session.setAttribute("sessionStatus", member.getStatus());
				session.setMaxInactiveInterval(60*60); // 세션 지속시간 : 60 * 60초
				
				//session.invalidate(); 로그아웃등 이벤트 발생시 세션 정보 삭제
				//session.removeAttribute("sessionId"); 1개씩 세션 삭제
				resultMap.put("result", "success");
				resultMap.put("member", member);
			} else {
				System.out.println("로그인 실패");
				resultMap.put("result", "fail");
			}
		}
		return resultMap;
	}

}
