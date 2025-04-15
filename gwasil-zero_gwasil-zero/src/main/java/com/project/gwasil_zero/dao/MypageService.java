package com.project.gwasil_zero.dao;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.MypageMapper;
import com.project.gwasil_zero.model.Board;
import com.project.gwasil_zero.model.Chat;
import com.project.gwasil_zero.model.ChatMessage;
import com.project.gwasil_zero.model.Contract;
import com.project.gwasil_zero.model.Pay;
import com.project.gwasil_zero.model.Lawyer;
import com.project.gwasil_zero.model.Notification;
import com.project.gwasil_zero.model.User;

@Service
public class MypageService {

	@Autowired
	MypageMapper mypageMapper;
	
	@Autowired
	private PasswordEncoder passwordEncoder;

	public HashMap<String, Object> getList(HashMap<String, Object> map) {
	    if (map.get("sessionId") != null) {
	        map.put("userId", map.get("sessionId"));  
	    }


	    HashMap<String, Object> resultMap = new HashMap<>();
	    List<User> user = mypageMapper.selectUserForMypage(map);  

	    resultMap.put("user", user);
	    return resultMap;
	}
	
	public HashMap<String, Object> removeUser(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    // 사용자 정보 조회
	    User user = mypageMapper.selectUserById(map);

	    // 비밀번호 비교
	    String rawPassword = (String) map.get("password");
	    if (user != null && passwordEncoder.matches(rawPassword, user.getUserPassword())) {
	        int result = mypageMapper.deleteUserByAdmin(map);
	        resultMap.put("result", result > 0 ? "success" : "fail");
	    } else {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "비밀번호가 일치하지 않습니다.");
	    }

	    return resultMap;
	}
	
	public HashMap<String, Object> selectUserBoardList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
	    
	    try {
		    List<Board> boardList = mypageMapper.selectUserBoardList(map);
		    resultMap.put("boardList", boardList);
		    
		    int boardCnt = mypageMapper.selectBoardCount(map);
			resultMap.put("boardCnt", boardCnt);
		    
			resultMap.put("result", "success");		
			
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage()); //개발자 확인하기 위한 용도
			resultMap.put("result", "fail");						
		}
		return resultMap;
		
	}
			

	public HashMap<String, Object> selectMyPayList(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    
	    try {
		    List<Pay> payList = mypageMapper.selectMyPayList(map);
		    resultMap.put("payList", payList);
			resultMap.put("result", "success");		
			
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage()); //개발자 확인하기 위한 용도
			resultMap.put("result", "fail");						
		}
		return resultMap;
		
	}

	public HashMap<String, Object> selectMyChatList(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        List<ChatMessage> chatList = mypageMapper.selectUserChatList(map);
	        resultMap.put("chatList", chatList);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}

	public HashMap<String, Object> updateUser(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
	    int result = mypageMapper.updateUserInfo(map);
	    resultMap.put("result", result > 0 ? "success" : "fail");
	    return resultMap;
	}
	
	public HashMap<String, Object> selectUserInfo(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    User user = mypageMapper.selectUserInfo(map);
	    resultMap.put("info", user);
	    return resultMap;
	}
	
   public HashMap<String, Object> getLawyer(HashMap<String, Object> map) {
	   // TODO Auto-generated method stub
	   HashMap<String, Object> resultMap = new HashMap<String, Object>();
	   Lawyer view = mypageMapper.selectLawyerView(map);
	   resultMap.put("view", view);
	   return resultMap;
   }
	
   public HashMap<String, Object> editLawyer(HashMap<String, Object> map) {
	   // TODO Auto-generated method stub
	   HashMap<String, Object> resultMap = new HashMap<String, Object>();
	   mypageMapper.updateLawyer(map);
	   resultMap.put("result", "success");      
	   return resultMap;
   }
   
   public HashMap<String, Object> counselUpdate(HashMap<String, Object> map) {
	      // TODO Auto-generated method stub
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    mypageMapper.updateCounsel(map);
	    resultMap.put("result", "success");      
	    return resultMap;
	   }

	public HashMap<String, Object> getLawyerBoard(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    List<Board> boardList = mypageMapper.selectLawyerBoard(map);
	    
	    int count = mypageMapper.selectBoardCnt(map);
		resultMap.put("count", count);
	    
	    resultMap.put("boardList", boardList);
	    resultMap.put("result", "success");
	    return resultMap;
	}

	public HashMap<String, Object> boardUpdate(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    mypageMapper.updateBoardStatus(map);
	    resultMap.put("result", "success");      
	    return resultMap;
	}

	public HashMap<String, Object> getLawyerPay(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		 HashMap<String, Object> resultMap = new HashMap<>();
		    try {
		        List<Pay> lawyerPayList = mypageMapper.selectLawyerPay(map);
		        resultMap.put("lawyerPayList", lawyerPayList);
		        resultMap.put("result", "success");
		    } catch (Exception e) {
		        e.printStackTrace();
		        resultMap.put("result", "fail");
		    }
		    return resultMap;
	}

	public HashMap<String, Object> payStatusUpdate(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    mypageMapper.updatePayStatus(map);
	    resultMap.put("result", "success");      
	    return resultMap;
	}

	public HashMap<String, Object> cancelUpdate(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    mypageMapper.updateCancel(map);
	    resultMap.put("result", "success");      
	    return resultMap;
	}

	public HashMap<String, Object> getChatList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<ChatMessage> chatList = mypageMapper.selectLastChat(map);
		resultMap.put("chatList", chatList);
	    
	    resultMap.put("result", "success");
	    return resultMap;
	}

	public HashMap<String, Object> getContractList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        List<Contract> contractList = mypageMapper.selectContractList(map);
	        resultMap.put("contractList", contractList);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}

	public HashMap<String, Object> selectLawyerInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
	    Lawyer lawyerInfo = mypageMapper.selectLawyerInfo(map);
	    resultMap.put("lawyerInfo", lawyerInfo);
	    return resultMap;
	}

	public void updateLawyerImg(Map<String, Object> param) {
		// TODO Auto-generated method stub
		mypageMapper.updateLawyerImg(param);
	}

	public HashMap<String, Object> selectRefundNotification(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		   List<Notification> notifications = mypageMapper.selectRefundNoti(map);
		   resultMap.put("notifications", notifications);
		   resultMap.put("result", "success");
		   return resultMap;
	}

	public HashMap<String, Object> updateNotificationRead(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    mypageMapper.updateNoti(map);
	    resultMap.put("result", "success");      
	    return resultMap;
	}

	public HashMap<String, Object> upadatePhoneConsult(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    
	    int count = mypageMapper.selectConsult(map);
	    if (count > 0) {
	    	resultMap.put("result", "success");   
	    	mypageMapper.updateConsult(map);
	    }
	    else {
	    	resultMap.put("result", "fail");
	    	resultMap.put("message", "차감할 패키지가 없습니다.");
	    }
	       
	    return resultMap;
	}

	public HashMap<String, Object> lawyerRemove(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		 HashMap<String, Object> resultMap = new HashMap<>();

		    // 변호사 정보 조회
		    Lawyer lawyer = mypageMapper.selectLawyerById(map);

		    // 비밀번호 비교
		    String rawPassword = (String) map.get("pwd");
		    if (lawyer != null && passwordEncoder.matches(rawPassword, lawyer.getLawyerPwd())) {
		        int result = mypageMapper.deleteLawyerByAdmin(map);
		        resultMap.put("result", result > 0 ? "success" : "fail");
		    } else {
		        resultMap.put("result", "fail");
		        resultMap.put("message", "비밀번호가 일치하지 않습니다.");
		    }

		    return resultMap;
	}

	public HashMap<String, Object> selectPhoneList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Pay> usedList = mypageMapper.selectPayUsed(map);
		resultMap.put("usedList", usedList);
		resultMap.put("result", "success");
		return resultMap;
	}

}