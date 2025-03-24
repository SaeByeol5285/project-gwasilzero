package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Lawyer;

@Mapper
public interface ProfileMapper {

	List<Lawyer> selectInnerList(HashMap<String, Object> map);

	int selectInnerCnt(HashMap<String, Object> map);

}
