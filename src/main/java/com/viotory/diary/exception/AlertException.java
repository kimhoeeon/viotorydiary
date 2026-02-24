package com.viotory.diary.exception;

// RuntimeException을 상속받는 커스텀 예외 클래스
public class AlertException extends RuntimeException {
    public AlertException(String message) {
        super(message);
    }
}