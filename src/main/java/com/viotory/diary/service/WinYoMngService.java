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

    private final WinYoMentionMapper winYoMentionMapper;

    public List<WinYoMentionVO> getMentionList(String filterCategory, String searchType, String searchWord) {
        return winYoMentionMapper.selectMentionList(filterCategory, searchType, searchWord);
    }

    public WinYoMentionVO getMention(Long mentionId) {
        return winYoMentionMapper.selectMention(mentionId);
    }

    public void modifyMention(WinYoMentionVO vo) {
        winYoMentionMapper.updateMention(vo);
    }
}