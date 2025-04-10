package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ScheduleMapper {
	 // 조건에 맞는 게시글 번호 리스트
    List<Integer> selectExpiringBoards();

    // 게시글의 댓글 수
    int selectCommentCount(int boardNo);

    // 상태가 I(활성)인 변호사 아이디 목록
    List<String> selectActiveLawyers();

    // 알림 등록
    void insertNotification(HashMap<String, Object> map);
}
