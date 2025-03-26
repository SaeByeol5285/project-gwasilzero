package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.project.gwasil_zero.model.TotalDocs;
import com.project.gwasil_zero.model.TotalFile;

@Mapper
public interface TotalDocsMapper {

	List<TotalDocs> selectNoticeList(HashMap<String, Object> map);

	int selectNoticeCnt(HashMap<String, Object> map);

	TotalDocs selectNoticeInfo(HashMap<String, Object> map);

	void updateCnt(HashMap<String, Object> map);

	TotalDocs selectPrevNotice(HashMap<String, Object> map);

	TotalDocs selectNextNotice(HashMap<String, Object> map);

	void insertNotice(HashMap<String, Object> map);

	void insertFiles(HashMap<String, Object> map);

	List<TotalFile> selectImgList(HashMap<String, Object> map);

	int deleteNotice(HashMap<String, Object> map);

    void updateNotice(HashMap<String,Object> map);
    
    void insertFile(HashMap<String,Object> map);


}
