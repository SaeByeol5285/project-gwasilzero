package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.TotalDocs;

@Mapper
public interface TotalDocsMapper {

	List<TotalDocs> selectNoticeList(HashMap<String, Object> map);

	int selectNoticeCnt(HashMap<String, Object> map);

	TotalDocs selectNoticeInfo(HashMap<String, Object> map);

	void updateCnt(HashMap<String, Object> map);

	TotalDocs selectPrevNotice(HashMap<String, Object> map);

	TotalDocs selectNextNotice(HashMap<String, Object> map);


}
