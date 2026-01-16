package com.viotory.diary.service;

import com.viotory.diary.mapper.DiaryMngMapper;
import com.viotory.diary.vo.Criteria;
import com.viotory.diary.vo.DiaryVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DiaryMngService {

    private final DiaryMngMapper diaryMngMapper;

    public List<DiaryVO> getDiaryList(Criteria cri) {
        return diaryMngMapper.selectDiaryList(cri);
    }

    public int getTotal(Criteria cri) {
        return diaryMngMapper.getTotalCount(cri);
    }

    public DiaryVO getDiary(Long diaryId) {
        return diaryMngMapper.selectDiaryById(diaryId);
    }

    @Transactional
    public void deleteDiary(Long diaryId) {
        diaryMngMapper.deleteDiary(diaryId);
    }
}