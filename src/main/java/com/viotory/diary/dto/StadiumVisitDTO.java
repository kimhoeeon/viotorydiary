package com.viotory.diary.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class StadiumVisitDTO {
    private Integer stadiumId;
    private String name;
    private boolean isVisited; // 방문 여부
}