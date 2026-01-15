package com.viotory.diary.service;

import com.viotory.diary.mapper.WinYoMentionMapper;
import com.viotory.diary.vo.WinYoMentionVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
public class WinYoMngService {

    private final WinYoMentionMapper winYoMapper;

    public List<WinYoMentionVO> getMentionList(String category) {
        return winYoMapper.selectMentionList(category);
    }

    public WinYoMentionVO getMention(Long mentionId) {
        return winYoMapper.selectMentionById(mentionId);
    }

    @Transactional
    public void saveMention(WinYoMentionVO vo) {
        if (vo.getMentionId() == null) {
            winYoMapper.insertMention(vo);
        } else {
            winYoMapper.updateMention(vo);
        }
    }

    @Transactional
    public void deleteMention(Long mentionId) {
        winYoMapper.deleteMention(mentionId);
    }
}