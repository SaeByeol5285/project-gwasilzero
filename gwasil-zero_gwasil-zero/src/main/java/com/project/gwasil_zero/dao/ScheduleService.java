package com.project.gwasil_zero.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gwasil_zero.mapper.ScheduleMapper;

@Service
public class ScheduleService {

    @Autowired
    ScheduleMapper scheduleMapper;

    public void notifyAboutSoonExpiringBoards() {
        // 조건에 맞는 boardNo 리스트 가져오기
        List<Integer> boardNos = scheduleMapper.selectExpiringBoards();

        // 해당 게시글들에 대해 변호사에게 알림 전송
        for (Integer boardNo : boardNos) {
            int commentCount = scheduleMapper.selectCommentCount(boardNo);

            // 댓글이 하나도 없는 경우만 알림 전송
            if (commentCount == 0) {
                List<String> lawyerIds = scheduleMapper.selectActiveLawyers();
                for (String lawyerId : lawyerIds) {
                    HashMap<String, Object> noti = new HashMap<>();
                    noti.put("receiverId", lawyerId);
                    noti.put("notiType", "BROADCAST");
                    noti.put("contents", "3시간 미만으로 남은 빠른답변 게시글이 있습니다");
                    noti.put("isRead", "N");
                    noti.put("senderId", boardNo);  // boardNo를 senderId로 보냄
                    noti.put("boardNo", boardNo);
                    scheduleMapper.insertNotification(noti);
                }
            }
        }
    }
}
