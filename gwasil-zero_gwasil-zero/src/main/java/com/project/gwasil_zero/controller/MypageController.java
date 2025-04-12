package com.project.gwasil_zero.controller;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.project.gwasil_zero.dao.MypageService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class MypageController {

	@Autowired
	MypageService mypageService;

	// 유저 마이페이지\
	@RequestMapping("/mypage-home.do")
	public String userMyPage(@RequestParam Map<String, Object> map, Model model) throws Exception {
		model.addAttribute("map", map);
		return "/mypage/mypage-home"; // 뷰 이름 반환
	}

	// 정보수정
	@RequestMapping("/mypage/edit.do")
	public String mypageEdit(@RequestParam Map<String, Object> map, Model model) throws Exception {
		model.addAttribute("map", map);
		return "/mypage/mypage-edit";
	}

	// 일반 사용자 회원탈퇴
	@RequestMapping("/mypage/remove.do")
	public String remove(@RequestParam Map<String, Object> map, Model model) throws Exception {
		model.addAttribute("map", map);
		return "/mypage/mypage-remove";
	}
	
	// 변호사 회원탈퇴
	@RequestMapping("/lawyerMyPage/out.do")
	public String out(@RequestParam Map<String, Object> map, Model model) throws Exception {
		model.addAttribute("map", map);
		return "/mypage/lawyerMyPage-out";
	}

	@RequestMapping("/mypage-edit.do")
	public String edit(Model model) throws Exception {

		return "/mypage/mypage-edit";
	}
	
	@RequestMapping("/lawyerMyPage/edit.do")
	public String lawyerEdit(Model model) throws Exception {

		return "/mypage/lawyerMyPage-edit";
	}

	@RequestMapping(value = "/mypage/mypage-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = mypageService.getList(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/mypage/mypage-remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeUser(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = mypageService.removeUser(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/mypage/mypage-view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getInfo(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = mypageService.selectUserInfo(map); // 이게 있어야 함
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/mypage/mypage-edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editInfo(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = mypageService.updateUser(map); // 이게 있어야 함
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/mypage/my-board-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String myBoardList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = mypageService.selectUserBoardList(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/mypage/my-chat-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String myChatList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = mypageService.selectMyChatList(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/mypage/my-pay-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String myPayList(@RequestParam HashMap<String, Object> map) throws Exception {
//	    System.out.println("📥 [myPayList] 전달받은 userId: " + map.get("userId"));  // 여기 null이면 큰일
		HashMap<String, Object> resultMap = mypageService.selectMyPayList(map);
		return new Gson().toJson(resultMap);
	}

	// 변호사 마이페이지
	@RequestMapping("/mypage/lawyerMyPage.do")
	public String lawyerMyPage(@RequestParam Map<String, Object> map, Model model) throws Exception {
		model.addAttribute("map", map);
		return "/mypage/lawyerMyPage";
	}

	// 변호사 마이페이지 정보 보기
	@RequestMapping(value = "/lawyerMyPage/view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String lawyerView(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		System.out.println("map: " + map); // 여기 추가
		HashMap<String, Object> resultMap = mypageService.getLawyer(map);
		return new Gson().toJson(resultMap);
	}

	// 변호사 마이페이지 정보 수정
	@RequestMapping(value = "/lawyerMyPage/edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String lawyerEdit(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = mypageService.editLawyer(map);
		return new Gson().toJson(resultMap);
	}

	// 변호사 상담 상태
	@RequestMapping(value = "/lawyerMyPage/updateStatus.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String lawyerCounsel(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = mypageService.counselUpdate(map);
		return new Gson().toJson(resultMap);
	}

	// 변호사가 맡은 사건 게시글 가져오기
	@RequestMapping(value = "/lawyerMyPage/board.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String lawyerBoard(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = mypageService.getLawyerBoard(map);
		return new Gson().toJson(resultMap);
	}

	// 변호사가 맡은 사건 상태 변경
	@RequestMapping(value = "/lawyerMyPage/updateBoardStatus.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateBoardStatus(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = mypageService.boardUpdate(map);
		return new Gson().toJson(resultMap);
	}
	
	// 변호사 마이페이지 결제 내역
	@RequestMapping(value = "/lawyerMyPage/payList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getLawyerPay(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = mypageService.getLawyerPay(map);
		return new Gson().toJson(resultMap);
	}
	
	// 결제 내역 환불
	@RequestMapping(value = "/mypage/Refund.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String refund(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = mypageService.payStatusUpdate(map);
		return new Gson().toJson(resultMap);
	}
	
	// 결제 내역 환불 취소
	@RequestMapping(value = "/mypage/RefundCancel.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String refundCancel(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = mypageService.cancelUpdate(map);
		return new Gson().toJson(resultMap);
	}
	
	// 채팅 내역 불러오기
	@RequestMapping(value = "/mypage/chatList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String chatList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = mypageService.getChatList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 사용자 마이페이지 변호사 선임 결제 내역
	@RequestMapping(value = "/mypage/contractList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String contract(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = mypageService.getContractList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 변호사 마이페이지 사진 수정
	@PostMapping("/lawyerMyPage/uploadImg.dox")
	@ResponseBody
	public Map<String, Object> uploadImg(@RequestParam("uploadFile") MultipartFile file,
	                                     @RequestParam("lawyerId") String lawyerId,
	                                     HttpServletRequest request) {
	    Map<String, Object> result = new HashMap<>();
	    try {
	        String uploadDir = request.getServletContext().getRealPath("/img/");
	        String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename();
	        File dest = new File(uploadDir, fileName);
	        file.transferTo(dest);

	        String imgPath = "/img/" + fileName;

	        // DB 업데이트
	        Map<String, Object> param = new HashMap<>();
	        param.put("lawyerId", lawyerId);
	        param.put("lawyerImg", imgPath);
	        mypageService.updateLawyerImg(param);

	        result.put("result", "success");
	        result.put("imgPath", imgPath);
	    } catch (Exception e) {
	        result.put("result", "fail");
	    }
	    return result;
	}
	
	// 변호사 마이페이지 정보 수정
	@RequestMapping(value = "/lawyerMyPage/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getlawyerInfo(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = mypageService.selectLawyerInfo(map); // 이게 있어야 함
		return new Gson().toJson(resultMap);
	}
	
	// 마이페이지 환불 처리 알림
	@RequestMapping(value = "/mypage/notification.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getRefundNotification(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = mypageService.selectRefundNotification(map);
		return new Gson().toJson(resultMap);
	}
	
	// 마이페이지 알림 읽음 처리
	@RequestMapping(value = "/mypage/notificationRead.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String notificationRead(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = mypageService.updateNotificationRead(map);
		return new Gson().toJson(resultMap);
	}
	
	// 전화 상담 차감
	@RequestMapping(value = "/lawyerMyPage/usePhoneConsult.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String upadatePhoneConsult(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = mypageService.upadatePhoneConsult(map);
		return new Gson().toJson(resultMap);
	}
	
	// 변호사 마이페이지 회원 탈퇴
	@RequestMapping(value = "/lawyerMyPage/out.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeLawyer(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = mypageService.lawyerRemove(map);
		return new Gson().toJson(resultMap);
	}
	
	// 사용자 전화 상담 패키지 차감 내역
	@RequestMapping(value = "/lawyerMyPage/usedPhoneList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String userPhoneList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap = mypageService.selectPhoneList(map);
		return new Gson().toJson(resultMap);
	}

}