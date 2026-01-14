package com.viotory.diary.mapper;

import com.viotory.diary.vo.PredictionVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface PredictionMapper {
    int savePrediction(@Param("memberId") Long memberId, @Param("gameId") Long gameId, @Param("predictedTeam") String predictedTeam);

    List<PredictionVO> selectMyPredictionHistory(Long memberId);

    PredictionVO selectMyPredictionByGameId(@Param("memberId") Long memberId, @Param("gameId") Long gameId);

    Map<String, Object> selectPredictionStats(Long memberId);

    List<PredictionVO> selectPredictionsByGameId(Long gameId);

    int updatePredictionResult(@Param("predictionId") Long predictionId, @Param("isCorrect") Boolean isCorrect);

    void updateAlarmSent(Long predictionId);
}