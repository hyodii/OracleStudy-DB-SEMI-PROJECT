SELECT USER
FROM DUAL;
--==>> HR


-- 교수정보 테이블
CREATE TABLE PROFESSORS
( PRO_ID     VARCHAR2(30)                               -- 교수자번호
, PRO_NAME   VARCHAR2(10)                               -- 교수자명
, PRO_PW     VARCHAR2(30) DEFAULT SUBSTR(PRO_SSN,8,7)   -- 교수자 비밀번호(초기값은 주민번호 뒷자리)
, PRO_SSN    CHAR(14)                                   -- 교수자 주민번호
, CONSTRAINT PROFESSORS_PRO_ID_PK PRIMARY KEY(PRO_ID)
);

-- NOT NULL 제약조건 수정
ALTER TABLE PROFESSORS
MODIFY
( PRO_NAME CONSTRAINT PROFESSORS_PRO_NAME_NN NOT NULL
, PRO_SSN CONSTRAINT PROFESSORS_PRO_SSN_NN NOT NULL
);

-- 과목 테이블
CREATE TABLE SUBJECTS
( SUB_ID            VARCHAR2(30)        -- 과목코드
, C_START           DATE                -- 시작일
, C_END             DATE                -- 종료일
, CLASSROOM         VARCHAR2(30)        -- 강의실
, BOOK_NAME         VARCHAR2(30)        -- 책이름
, CONSTRAINT SUBJECTS_SUB_ID_PK PRIMARY KEY(SUB_ID)
, CONSTRAINT SUBJECTS_C_START_CK CHECK(C_DATE < C_END)
);


























