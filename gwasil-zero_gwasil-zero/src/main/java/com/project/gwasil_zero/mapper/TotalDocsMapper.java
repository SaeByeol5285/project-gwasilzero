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

	//리스트
	List<TotalDocs> selectDocsList(HashMap<String, Object> map);

	//페이징
	int selectDocsCnt(HashMap<String, Object> map);

	//상세보기
	TotalDocs selectDocsInfo(HashMap<String, Object> map);

	//이전글
	TotalDocs selectPrevDocs(HashMap<String, Object> map);

	//다음글
	TotalDocs selectNextDocs(HashMap<String, Object> map);

	//이미지리스트
	List<TotalFile> selectImgList(HashMap<String, Object> map);

	//글쓰기
	void insertDocs(HashMap<String, Object> map);

	
	
	void updateCnt(HashMap<String, Object> map);
	

	void insertFiles(HashMap<String, Object> map);


	int deleteNotice(HashMap<String, Object> map);

    void updateNotice(HashMap<String,Object> map);
    
    void insertFile(HashMap<String,Object> map);

	List<TotalDocs> selectHelpList(HashMap<String, Object> map);

	int selectHelpCnt(HashMap<String, Object> map);







}
