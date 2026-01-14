package com.viotory.diary.mapper;

import com.viotory.diary.vo.LockerVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LockerMapper {
    List<LockerVO> selectPostList(LockerVO params);

    LockerVO selectPostById(Long postId);

    int insertPost(LockerVO lockerVO);

    int updateViewCount(Long postId);
}