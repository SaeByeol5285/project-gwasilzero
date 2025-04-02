package com.project.gwasil_zero.controller;

import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.project.gwasil_zero.dao.UserService;

@Controller
public class UserController {

	@Autowired
	UserService userService;

	@Value("${client_id}")
	private String client_id;

	@Value("${redirect_uri}")
	private String redirect_uri;

	@Autowired
	HttpSession session;

	// 로그인 페이지 이동
	@RequestMapping("/user/login.do")
	public String login(Model model) throws Exception {
		String location = "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=" + client_id
				+ "&redirect_uri=" + redirect_uri;
		model.addAttribute("location", location);
		return "/user/user-login";
	}

	// 아이디/비밀번호 찾기 페이지 이동
	@RequestMapping("/user/search.do")
	public String search(Model model) throws Exception {
		return "/user/user-search";
	}

	@RequestMapping("/user/userId-search.do")
	public String id(Model model) throws Exception {
		return "/user/userId-search";
	}

	@RequestMapping("/user/userPwd-search.do")
	public String pwd(Model model) throws Exception {
		return "/user/userPwd-search";
	}

	@RequestMapping("/user/reMakePwd.do")
	public String reMakePwd(Model model) throws Exception {
		return "/user/user-reMakePwd";
	}

	// 로그인 처리
	@RequestMapping(value = "/user/user-login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = userService.getInfo(map);
		return new Gson().toJson(resultMap);
	}

	// 로그아웃
	@RequestMapping("/user/logout.dox")
	@ResponseBody
	public HashMap<String, Object> logout(HttpSession session) {
		HashMap<String, Object> resultMap = new HashMap<>();
		session.invalidate();
		resultMap.put("result", "success");
		return resultMap;
	}

	// 아이디 찾기
	@RequestMapping(value = "/user/userId-search.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String findId(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = userService.selectUserId(map);
		return new Gson().toJson(resultMap);
	}

	// 비밀번호 찾기
	@RequestMapping(value = "/user/user-search-pwd.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String findPwd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = userService.selectUserPwd(map);
		return new Gson().toJson(resultMap);
	}

	// 비밀번호 재설정
	@RequestMapping(value = "/user/user-reMakePwd.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String remakePwd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = userService.updateUserPassword(map);
		return new Gson().toJson(resultMap);
	}

	// 중복 체크
	@RequestMapping(value = "/user/check.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String check(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = userService.searchUser(map);
		return new Gson().toJson(resultMap);
	}

	// 카카오 로그인 연동
	@RequestMapping(value = "/kakao.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String kakao(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		String tokenUrl = "https://kauth.kakao.com/oauth/token";

		RestTemplate restTemplate = new RestTemplate();
		MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
		params.add("grant_type", "authorization_code");
		params.add("client_id", client_id);
		params.add("redirect_uri", redirect_uri);
		params.add("code", (String) map.get("code"));

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
		ResponseEntity<Map> response = restTemplate.postForEntity(tokenUrl, request, Map.class);

		Map<String, Object> responseBody = response.getBody();
		HashMap<String, Object> resultMap = (HashMap<String, Object>) getUserInfo(
				(String) responseBody.get("access_token"));
		return new Gson().toJson(resultMap);
	}

	private Map<String, Object> getUserInfo(String accessToken) {
		String userInfoUrl = "https://kapi.kakao.com/v2/user/me";
		RestTemplate restTemplate = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.setBearerAuth(accessToken);
		HttpEntity<String> entity = new HttpEntity<>(headers);

		ResponseEntity<String> response = restTemplate.exchange(userInfoUrl, HttpMethod.GET, entity, String.class);

		try {
			ObjectMapper objectMapper = new ObjectMapper();
			return objectMapper.readValue(response.getBody(), Map.class);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@RequestMapping(value = "/user/naver-session.dox", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> naverSession(@RequestParam HashMap<String, Object> map, HttpSession session) {
		session.setAttribute("sessionId", map.get("email")); // 또는 map.get("id") 등
		session.setAttribute("sessionName", map.get("name"));
		session.setAttribute("role", "user"); // 권한도 설정해두면 좋음

		HashMap<String, Object> result = new HashMap<>();
		result.put("result", "success");
		return result;
	}

}
