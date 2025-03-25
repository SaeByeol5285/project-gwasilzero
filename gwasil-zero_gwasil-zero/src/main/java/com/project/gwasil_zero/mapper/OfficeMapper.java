package com.project.gwasil_zero.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.gwasil_zero.model.Area;
import com.project.gwasil_zero.model.Lawyer;

@Mapper
public interface OfficeMapper {
	List<Area> getSi(HashMap<String, Object> map);

	List<Area> getGu(HashMap<String, Object> map);

	List<Area> getDong(HashMap<String, Object> map);

	List<Lawyer> getLawyerList(HashMap<String, Object> map);
}
