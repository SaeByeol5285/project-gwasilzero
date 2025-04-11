package com.project.gwasil_zero.controller;

import java.io.File;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.google.gson.Gson;
import com.project.gwasil_zero.dao.JoinService;
@Controller
public class JoinController {

	@Autowired
	JoinService joinService;

	// 일반 유저 / 변호사 유저 선택
	@RequestMapping("/join/select.do")
	public String select(Model model) throws Exception {

		return "/join/user-select";
	}

	// 일반 유저 회원가입
	@RequestMapping("/join/user-join.do")
	public String userJoin(Model model) throws Exception {

		return "/join/user-join";
	}

	// 변호사 유형 선택 페이지
	@RequestMapping("/join/lawyer-select.do")
	public String lawyerSelect(Model model) throws Exception {
		return "/join/lawyer-select";
	}

	// 변호사 회원가입
	@RequestMapping("/join/lawyer-join.do")
	public String lawyerJoin(Model model) throws Exception {
		return "/join/lawyer-join";
	}

	// 일반 유저 정보수정
	@RequestMapping("/join/edit.do")
	public String edit(Model model) throws Exception {

		return "/join/user-edit";
	}

	// 일반 유저 회원가입
	@RequestMapping(value = "/join/user-add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String joinUser(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = joinService.addUser(map);
		return new Gson().toJson(resultMap);
	}

	// 변호사 유저 회원가입
	@RequestMapping(value = "/join/lawyer-add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String joinLawyer(MultipartHttpServletRequest mRequest) throws Exception {
		HashMap<String, Object> map = new HashMap<>();
		Iterator<String> iter = mRequest.getFileNames();

		// 실제 업로드 경로
		String uploadPath = mRequest.getServletContext().getRealPath("/img");
		File folder = new File(uploadPath);
		if (!folder.exists())
			folder.mkdirs(); // 폴더 없으면 생성

		// 파일 처리
		while (iter.hasNext()) {
			String name = iter.next();
			MultipartFile file = mRequest.getFile(name);
			if (file != null && !file.isEmpty()) {
				String fileName = file.getOriginalFilename();
				File dest = new File(uploadPath, fileName);
				file.transferTo(dest); // 실제 저장

				// 파일 이름을 DB에 넣기 위한 경로 설정
				if (name.equals("lawyerImg")) {
					map.put("LAWYER_IMG", "/img/" + fileName);
				}
				if (name.equals("licenseFile")) {
					map.put("LAWYER_LICENSE_NAME", fileName);
					map.put("LAWYER_LICENSE_PATH", fileName);
				}
				if (name.equals("officeProofFile")) {
					map.put("OFFICEPROOF_NAME", fileName);
					map.put("OFFICEPROOF_PATH", fileName);
				}
			}
		}

		// 파라미터 값 받기
		Enumeration<String> paramNames = mRequest.getParameterNames();
		while (paramNames.hasMoreElements()) {
			String key = paramNames.nextElement();
			map.put(key, mRequest.getParameter(key));
		}

		// 서비스 호출
		return new Gson().toJson(joinService.addLawyer(map));
	}

	// 일반 유저 중복체크
	@RequestMapping(value = "/join/check.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String check(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = joinService.searchJoin(map);
		return new Gson().toJson(resultMap);
	}

	// 변호사 유저 중복체크
	@RequestMapping(value = "/join/checkLawyer.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String checkLawyer(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = joinService.searchJoinLawyer(map);
		return new Gson().toJson(resultMap);
	}

	// 일반 유저 정보수정
	@RequestMapping(value = "/join/user-edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editUser(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = joinService.editUser(map);
		return new Gson().toJson(resultMap);
	}
	//

}
