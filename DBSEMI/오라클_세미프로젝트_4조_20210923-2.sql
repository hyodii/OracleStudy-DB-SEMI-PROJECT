SELECT USER
FROM DUAL;
--==>> HR
/*
[테이블 생성 순서]
1. 관리자
2. 교수
3. 학생
4. 과목
5. 과정
6. 개설과목
7. 시험
8. 수강신청
9. 성적
10. 중도포기
--> 절대적으로 이 순서여야만 하는 것은 아닙니다.

교수정보, 학생정보 패스워드 -  데이터 입력 구문 작성 시에 SSN에서 
                               주민번호 뒷자리만 문자열 추출해서 저장
                               
SCORE 테이블 - SCORE테이블에서 출결, 실기, 필기 점수는 각각 100점으로 입력하되 
               나중에 개설과목 테이블에서 비중을 가져와서 출력창에 100점 만점으로 
               표시하는 방식은 어떨까요? 제약조건 에러가 나서 한번 생각해봤습니다. 
               우선 그 제약조건들 제외하고 테이블 생성했습니다.
               
MID_DROP - 테이블.컬럼명 이 방식을 테이블 생성할 때 인식을 못하는 것 같아요! 
           이것도 아마 프로시저 등으로 나중에 예외처리하는 방식으로 하는 건 
           어떨지 생각해봤고 우선 그 제약조건 제외하고 테이블 생성했습니다.
*/

/*
SELECT USER
FROM DUAL;
--==>> HR

--① 관리자
CREATE TABLE ADMINISTRATOR
( ADMIN_ID  VARCHAR2(30)
, ADMIN_PW  VARCHAR2(30) 
, CONSTRAINT ADMINISTRATOR_ADMIN_ID_PK PRIMARY KEY(ADMIN_ID)
);

ALTER TABLE ADMINISTRATOR
MODIFY
( ADMIN_PW CONSTRAINT ADMINISTRATOR_ADMIN_PW_NN NOT NULL );


--② 교수자
CREATE TABLE PROFESSORS
( PRO_ID     VARCHAR2(30)                               -- 교수자번호
, PRO_NAME   VARCHAR2(10)                               -- 교수자명
, PRO_PW     VARCHAR2(30)                               -- 교수자 비밀번호(초기값은 주민번호 뒷자리)
, PRO_SSN    CHAR(14)                                   -- 교수자 주민번호
, CONSTRAINT PROFESSORS_PRO_ID_PK PRIMARY KEY(PRO_ID)
, CONSTRAINT PROFESSORS_PRO_SSN_UK UNIQUE(PRO_SSN)
);

-- NOT NULL 제약조건 수정
ALTER TABLE PROFESSORS
MODIFY
( PRO_NAME CONSTRAINT PROFESSORS_PRO_NAME_NN NOT NULL
, PRO_PW CONSTRAINT PROFESSORS_PRO_PW_NN NOT NULL
, PRO_SSN CONSTRAINT PROFESSORS_PRO_SSN_NN NOT NULL
);


--③ 학생
CREATE TABLE STUDENTS
( ST_ID     VARCHAR2(30) 
, ST_PW     VARCHAR2(30)         -- ★초기값 주민번호 뒷자리
, ST_NAME   VARCHAR2(10)  
, ST_SSN    CHAR(14)     UNIQUE
, ST_DATE   DATE         DEFAULT SYSDATE
, CONSTRAINT STUDENTS_ST_ID_PK PRIMARY KEY(ST_ID)
);

-- 제약조건 수정
ALTER TABLE STUDENTS
MODIFY
( ST_ID CONSTRAINT STUDENTS_STUDENT_ID_NN NOT NULL
, ST_NAME CONSTRAINT STUDENTS_STUDENT_NAME_NN NOT NULL
, ST_PW CONSTRAINT STUDENTS_STUDENT_PASSWORD_NN NOT NULL
, ST_SSN CONSTRAINT STUDENTS_STUDENT_SSN_NN NOT NULL
, ST_DATE CONSTRAINT STUDENTS_STUDENT_DATE_NN NOT NULL
);


--④ 과목
CREATE TABLE SUBJECTS
( SUB_ID            VARCHAR2(30)        -- 과목코드
, SUB_NAME            VARCHAR2(30)
, S_START           DATE                -- 시작일
, S_END             DATE                -- 종료일
, CLASSROOM         VARCHAR2(30)        -- 강의실
, BOOK_NAME         VARCHAR2(30)        -- 책이름
, CONSTRAINT SUBJECTS_SUB_ID_PK PRIMARY KEY(SUB_ID)
, CONSTRAINT SUBJECTS_S_START_CK CHECK(S_START < S_END)
);


--⑤ 과정
CREATE TABLE COURSE
( COURSE_ID     VARCHAR2(30)  
, COURSE_NAME   VARCHAR2(30)
, PRO_ID        VARCHAR2(30)
, C_START       DATE
, C_END         DATE
, CLASSROOM     VARCHAR2(30)
, CONSTRAINT COURSE_COURSE_ID_PK PRIMARY KEY(COURSE_ID)
, CONSTRAINT COURSE_COURSE_NAME_FK FOREIGN KEY(PRO_ID)
                                            REFERENCES PROFESSORS(PRO_ID)
, CONSTRAINT COURSE_C_START_CK CHECK(C_START < C_END)
);


--⑥ 개설과목
CREATE TABLE ESTABLISHED_SUB
( EST_SUB_ID        VARCHAR2(30)
, PRO_ID            VARCHAR2(30)
, COURSE_ID         VARCHAR2(30)
, SUB_ID            VARCHAR2(30)
, ATTEND_PER        NUMBER(3)
, PRACTICAL_PER     NUMBER(3)
, WRITING_PER       NUMBER(3)
, CONSTRAINT EST_SUB_EST_SUB_ID_PK PRIMARY KEY(EST_SUB_ID)
, CONSTRAINT EST_SUB_PRO_ID_FK FOREIGN KEY(PRO_ID) 
                                       REFERENCES PROFESSORS(PRO_ID)
, CONSTRAINT SUBJECTS_COURSE_ID_FK FOREIGN KEY(COURSE_ID) 
                                       REFERENCES COURSE(COURSE_ID)
, CONSTRAINT EST_SUB_SUB_ID_FK FOREIGN KEY(SUB_ID) 
                                       REFERENCES SUBJECTS(SUB_ID)
, CONSTRAINT EST_SUB_ATTEND_PER_CK CHECK(ATTEND_PER BETWEEN 0 AND 100)
, CONSTRAINT EST_SUB_PRACTICAL_PER_CK CHECK(PRACTICAL_PER BETWEEN 0 AND 100)
, CONSTRAINT EST_SUB_WRITING_PER_CK CHECK(WRITING_PER BETWEEN 0 AND 100)
, CONSTRAINT EST_SUB_TOTAL_PER_CK CHECK( (ATTEND_PER + PRACTICAL_PER + WRITING_PER) = 100 )
);


--⑦ 시험
CREATE TABLE TEST
(
 TEST_ID          VARCHAR2(30)
,EST_SUB_ID       VARCHAR2(30)
,TEST_DATE        DATE
,CONSTRAINT TEST_TEST_ID_PK PRIMARY KEY(TEST_ID)
,CONSTRAINT TEST_EST_SUB_ID_FK FOREIGN KEY(EST_SUB_ID) REFERENCES ESTABLISHED_SUB(EST_SUB_ID)
);


--⑧ 수강신청
CREATE TABLE ENROLL
( E_ID          VARCHAR2(30)
, ST_ID         VARCHAR2(30)
, COURSE_ID     VARCHAR2(30)
, E_DATE        DATE    DEFAULT SYSDATE
, CONSTRAINT ENROLL_E_ID_PK PRIMARY KEY(E_ID)
, CONSTRAINT ENROLL_ST_ID_FK FOREIGN KEY(ST_ID) 
                                       REFERENCES STUDENTS(ST_ID)
, CONSTRAINT ENROLL_COURSE_ID_FK FOREIGN KEY(COURSE_ID) 
                                       REFERENCES COURSE(COURSE_ID)
);

--수강신청 제약조건 수정
ALTER TABLE ENROLL
MODIFY
(E_DATE   CONSTRAINT ENROLL_E_DATE_NN NOT NULL);


--⑨ 성적
CREATE TABLE SCORE
( SCORE_ID              VARCHAR2(30) 
, E_ID             VARCHAR2(30)
, EST_SUB_ID            VARCHAR2(30)
, ATTEND_SCORE          NUMBER(3)
, PRACTICAL_SCORE       NUMBER(3)
, WRITING_SCORE         NUMBER(3)
, CONSTRAINT SOCRE_ID_PK PRIMARY KEY(SCORE_ID)
, CONSTRAINT SCORE_E_ID_FK FOREIGN KEY(E_ID)
             REFERENCES ENROLL(E_ID)
, CONSTRAINT SCORE_ESTABLISHED_SUB_ID_FK FOREIGN KEY(EST_SUB_ID)
             REFERENCES ESTABLISHED_SUB(EST_SUB_ID)
, CONSTRAINT SCORE_ATTEND_SCORE_CK CHECK(ATTEND_SCORE BETWEEN 0 AND 100)            
, CONSTRAINT SCORE_PRACTICAL_SCORE_CK CHECK(PRACTICAL_SCORE BETWEEN 0 AND 100)            
, CONSTRAINT SCOREWRITING_SCORE_CK CHECK(WRITING_SCORE BETWEEN 0 AND 100)

);


--⑩ 중도포기
CREATE TABLE MID_DROP
( DROP_ID       VARCHAR2(30)
, E_ID     VARCHAR2(30)
, DROP_DATE     DATE           NOT NULL
, CONSTRAINT MID_DPOP_ID_PK PRIMARY KEY(DROP_ID)
, CONSTRAINT MID_DPOP_E_ID_FK FOREIGN KEY(E_ID)
             REFERENCES ENROLL(E_ID)
-- 등록일보다 중도포기 날짜가 뒤여야 한다는 제약조건
);


--○ 교수자 이벤트로그 테이블
CREATE TABLE PRO_EVENTLOG
( PRO_ID    VARCHAR2(30)
, MEMO      VARCHAR2(200)
, ILJA      DATE DEFAULT SYSDATE
, CONSTRAINT PRO_EVENTLOG_PRO_ID_FK FOREIGN KEY(PRO_ID)
                REFERENCES PROFESSORS(PRO_ID)
);
--==>> Table PRO_EVENTLOG이(가) 생성되었습니다.


--○ 학생 이벤트로그 테이블
CREATE TABLE STD_EVENTLOG
( ST_ID         VARCHAR2(30)
, ILJA          DATE DEFAULT SYSDATE
, MEMO          VARCHAR2(200)
, CONSTRAINT TBL_EVENTLOG_ST_ID_FK FOREIGN KEY(ST_ID) 
                                       REFERENCES STUDENTS(ST_ID)
);
--==>> Table STD_EVENTLOG이(가) 생성되었습니다.


DROP TABLE ADMINISTRATOR;
DROP TABLE PROFESSORS;
DROP TABLE STUDENTS;
DROP TABLE SUBJECTS;
DROP TABLE COURSE;
DROP TABLE ESTABLISHED_SUB;
DROP TABLE TEST;
DROP TABLE ENROLL;
DROP TABLE SCORE;
DROP TABLE MID_DROP;


--------------------------------------------------------------------------------
--PLSQL
--○학생 로그인 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_LOGIN_ST 
(
    V_USERID IN STUDENTS.ST_ID%TYPE
,   V_USERPW IN STUDENTS.ST_PW%TYPE
)
IS
    V_COUNT            NUMBER;
BEGIN
    SELECT COUNT(ST_ID) INTO V_COUNT FROM STUDENTS
    WHERE ST_ID=V_USERID AND ST_PW=V_USERPW;
 
    IF(V_COUNT > 0) THEN
        DBMS_OUTPUT.PUT_LINE(V_USERID||'님 로그인 되었습니다.');  
    ELSE
        DBMS_OUTPUT.PUT_LINE('아이디 또는 비밀번호가 잘못되었습니다.');
    END IF;
 
END;
--==>> Procedure PRC_LOGIN_ST이(가) 컴파일되었습니다.


--○관리자 로그인 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_LOGIN_AD 
(
    V_USERID IN ADMINISTRATOR.ADMIN_ID%TYPE
,   V_USERPW IN ADMINISTRATOR.ADMIN_PW%TYPE
)
IS
    V_COUNT            NUMBER;
BEGIN
    SELECT COUNT(ADMIN_ID) INTO V_COUNT FROM ADMINISTRATOR
    WHERE ADMIN_ID=V_USERID AND ADMIN_PW=V_USERPW;
    
    IF(V_COUNT > 0) THEN
        DBMS_OUTPUT.PUT_LINE(V_USERID||'님 로그인 되었습니다.');  
    ELSE
        DBMS_OUTPUT.PUT_LINE('아이디 또는 비밀번호가 잘못되었습니다.');
    END IF;
END;
--==>> Procedure PRC_LOGIN_AD이(가) 컴파일되었습니다.

--○교수 로그인 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_LOGIN_PRO 
(
    V_USERID IN PROFESSORS.PRO_ID%TYPE
,   V_USERPW IN PROFESSORS.PRO_PW%TYPE
)
IS
    V_COUNT            NUMBER;
BEGIN
    SELECT COUNT(PRO_ID) INTO V_COUNT FROM PROFESSORS
    WHERE PRO_ID=V_USERID AND PRO_PW=V_USERPW;
 
    IF(V_COUNT > 0) THEN
        DBMS_OUTPUT.PUT_LINE(V_USERID||'님 로그인 되었습니다.');  
    ELSE
        DBMS_OUTPUT.PUT_LINE('아이디 또는 비밀번호가 잘못되었습니다.');    
    END IF;
  
END;
--==>> Procedure PRC_LOGIN_PR이(가) 컴파일되었습니다.

--○로그인 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_LOGIN
(
    V_USER    IN NUMBER    
,   V_USERID  IN PROFESSORS.PRO_ID%TYPE
,   V_USERPW  IN PROFESSORS.PRO_PW%TYPE
)
IS
    INPUT_ERROR    EXCEPTION;
    --V_COUNT        NUMBER;                        -- 안사용해서 빼고 될듯?
BEGIN
    IF(V_USER = 1) -- 관리자
        THEN PRC_LOGIN_AD(V_USERID, V_USERPW);
      
    ELSIF(V_USER = 2) -- 교수
        THEN PRC_LOGIN_PRO(V_USERID, V_USERPW);
  
    ELSIF(V_USER = 3) -- 학생
        THEN PRC_LOGIN_ST(V_USERID, V_USERPW);  
    ELSIF (V_USER != 1 AND V_USER != 2 AND V_USER != 3)
        THEN RAISE INPUT_ERROR;
    END IF; 
    
    EXCEPTION
    WHEN INPUT_ERROR
        THEN RAISE_APPLICATION_ERROR(-20005, '해당하는 사용자를 선택하세요. (1.관리자, 2.교수, 3.학생)');
             ROLLBACK;
    WHEN OTHERS
        THEN ROLLBACK;
 
END;
--==>> Procedure PRC_LOGIN이(가) 컴파일되었습니다


--○ STUDENT_INSERT 프로시저
CREATE OR REPLACE PROCEDURE PRC_STUDENT_INSERT
(
   V_ST_ID IN STUDENTS.ST_ID%TYPE
 , V_ST_NAME IN STUDENTS.ST_NAME%TYPE
 , V_ST_SSN IN STUDENTS.ST_SSN%TYPE
)
IS
BEGIN

    INSERT INTO STUDENTS(ST_ID, ST_PW, ST_NAME, ST_SSN)
    VALUES(V_ST_ID,SUBSTR(V_ST_SSN,8),V_ST_NAME,V_ST_SSN);

    COMMIT;
END;
--==>> Procedure PRC_STUDENT_INSERT이(가) 컴파일되었습니다.


--○ STUDENT_UPDATE 프로시저
CREATE OR REPLACE PROCEDURE PRC_STUDENT_UPDATE
(
  V_ST_ID   IN STUDENTS.ST_ID%TYPE
, V_ST_NAME IN STUDENTS.ST_NAME%TYPE
, V_ST_SSN  IN STUDENTS.ST_SSN%TYPE
)
IS
    NONEXIST_ERROR  EXCEPTION;
BEGIN
    UPDATE STUDENTS
    SET ST_NAME = V_ST_NAME, ST_SSN = V_ST_SSN
    WHERE ST_ID = V_ST_ID;
    
    IF SQL%NOTFOUND
        THEN RAISE NONEXIST_ERROR;
    END IF;
       
    COMMIT;
    
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20006,'일치하는 데이터가 없습니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_STUDENT_UPDATE이(가) 컴파일되었습니다.


--○ STUDENT_DELETE 프로시저
CREATE OR REPLACE PROCEDURE PRC_STUDENT_DELETE 
(
    V_ST_ID      STUDENTS.ST_ID%TYPE          
  , V_ST_PW      STUDENTS.ST_PW%TYPE      
  , V_ST_NAME    STUDENTS.ST_NAME%TYPE      
  , V_ST_SSN     STUDENTS.ST_SSN%TYPE      -- 학생 주민번호 뒷자리
)
IS
BEGIN
        DELETE      
            FROM STUDENTS      
            WHERE ST_ID = V_ST_ID             -- 학생 아이디 체크
                  AND ST_PW = V_ST_PW          -- 학생 비밀번호 체크
                  AND ST_NAME = V_ST_NAME      -- 학생 이름 체크
                  AND ST_SSN = V_ST_SSN;         -- 학생 주민번호 뒷자리 체크
        COMMIT;

        EXCEPTION
            WHEN OTHERS
                THEN RAISE_APPLICATION_ERROR(-20003,'다시 입력해주세요');
                     ROLLBACK; 
END;
--==>> Procedure PRC_STUDENT_DELETE이(가) 컴파일되었습니다.


--○ 학생 테이블 이벤트로그 트리거
CREATE OR REPLACE TRIGGER TRG_STD_EVENTLOG
            AFTER
            INSERT OR UPDATE ON STUDENTS
DECLARE
    V_ST_ID    STD_EVENTLOG.ST_ID%TYPE;
BEGIN

    IF(INSERTING)
        THEN INSERT INTO STD_EVENTLOG(ST_ID, MEMO) 
            VALUES(V_ST_ID,'학생 정보 추가 완료');    
    ELSIF(UPDATING)
        THEN INSERT INTO STD_EVENTLOG(ST_ID, MEMO) 
            VALUES(V_ST_ID,'학생 정보 업데이트 완료');
            
    END IF; 
END;
--==>> Trigger TRG_STD_EVENTLOG이(가) 컴파일되었습니다.

--○ 수강신청 INSERT 프로시저
-- 아래의 조건을 확인 후 데이터를 입력한다.
-- 1) 계정등록일과 개강일
-- 2) 동일한 과정 신청 여부
-- 3) 수강 날짜 중복
CREATE OR REPLACE PROCEDURE PRC_ENROLL_INSERT
( V_E_ID       IN ENROLL.E_ID%TYPE
, V_ST_ID      IN ENROLL.ST_ID%TYPE
, V_COURSE_ID  IN ENROLL.COURSE_ID%TYPE
, V_E_DATE     IN ENROLL.E_DATE%TYPE
)

IS
   V_ST_DATE           STUDENTS.ST_DATE%TYPE;
   V_C_START           COURSE.C_START%TYPE;     -- 등록하려는 과정의 시작일
   V_C_END             COURSE.C_END%TYPE;       -- 등록하려는 과정의 종료일
   nCNT                NUMBER;
   USER_DEFINE_ERROR   EXCEPTION;
   SAME_COURSE         EXCEPTION;
   SAME_DATE           EXCEPTION;

BEGIN
    -- 예외 처리 1. 계정등록일과 개강일
    -- 수강신청일은 계정등록일보다 빠르거나, 개강일보다 느리거나 같을 수 없다.
    SELECT ST_DATE INTO V_ST_DATE
    FROM STUDENTS
    WHERE ST_ID = V_ST_ID;
    
    SELECT C_START, C_END INTO V_C_START, V_C_END
    FROM COURSE
    WHERE COURSE_ID = V_COURSE_ID;    

    IF (V_E_DATE < V_ST_DATE OR V_E_DATE >= V_C_START)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    
    -- 예외 처리 2. 동일한 과정 신청 여부
    -- 한 학생이 같은 과정을 신청할 수 없다.
    SELECT COUNT(*) INTO nCNT
    FROM ENROLL
    WHERE ST_ID = V_ST_ID AND COURSE_ID = V_COURSE_ID;    
    
    IF (nCNT > 0)
        THEN RAISE SAME_COURSE;
    END IF;

    
    -- 예외 처리 3. 수강 날짜 중복
    -- 한 학생이 기존에 수강한 과정의 날짜가, 새로 수강하려는 과정의 날짜와 겹칠 수 없다.
    SELECT COUNT(*) INTO nCNT
    FROM ENROLL E JOIN COURSE C
      ON E.COURSE_ID = C.COURSE_ID      
    WHERE E.ST_ID = V_ST_ID
      AND ( V_C_START > C.C_START AND V_C_START < C.C_END     -- 등록하려는 과정의 시작 날짜 조건 확인
       OR   V_C_END > C.C_START AND V_C_END < C.C_END );      -- 등록하려는 과정의 종료 날짜 조건 확인

    IF (nCNT > 0)
        THEN RAISE SAME_DATE;
    END IF; 


    -- INSERT
    INSERT INTO ENROLL(E_ID, ST_ID, COURSE_ID, E_DATE)
    VALUES (V_E_ID, V_ST_ID, V_COURSE_ID, V_E_DATE);

    -- 커밋
    COMMIT;
        
    -- 예외 발생
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '수강 신청이 불가능합니다.');
                 ROLLBACK;
        WHEN SAME_COURSE
            THEN RAISE_APPLICATION_ERROR(-20003, '이미 신청한 과목입니다.');
                 ROLLBACK;
        WHEN SAME_DATE
            THEN RAISE_APPLICATION_ERROR(-20004, '날짜가 중복되는 과목입니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;            
END;
--==>> Procedure PRC_ENROLL_INSERT이(가) 컴파일되었습니다.


--○ 중도포기 INSERT 프로시저
--> 중도포기 레코드를 입력 시, "과정 시작일 < 중도포기일 < 과정종료일"이 맞는지 확인하는 프로시저
CREATE OR REPLACE PROCEDURE PRC_MID_DROP_INSERT
( V_DROP_ID     IN MID_DROP.DROP_ID%TYPE
, V_E_ID        IN MID_DROP.E_ID%TYPE
, V_DROP_DATE   IN MID_DROP.DROP_DATE%TYPE
)
IS
    V_COURSE_ID         COURSE.COURSE_ID%TYPE;
    V_C_START           COURSE.C_START%TYPE;
    V_C_END             COURSE.C_END%TYPE;
    USER_DEFINE_ERROR   EXCEPTION;

BEGIN
    -- 변수에 값 담기
    SELECT COURSE_ID INTO V_COURSE_ID
    FROM ENROLL
    WHERE E_ID = V_E_ID;  
    
    SELECT C_START, C_END INTO V_C_START, V_C_END
    FROM COURSE
    WHERE COURSE_ID = V_COURSE_ID;
    
    -- 예외 처리 : "과정 시작일 < 중도포기일 < 과정종료일"이 아닐 경우
    IF (V_DROP_DATE < V_C_START OR V_DROP_DATE > V_C_END)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    -- INSERT
    INSERT INTO MID_DROP(DROP_ID, E_ID, DROP_DATE)
    VALUES (V_DROP_ID, V_E_ID, V_DROP_DATE);
    
    -- 커밋
    COMMIT;
    
    -- 예외 발생
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '중도포기 날짜가 잘못 입력되었습니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_MID_DROP_INSERT이(가) 컴파일되었습니다.


--○ 교수 INSERT 프로시저
CREATE OR REPLACE PROCEDURE PRC_PRO_PW_INSERT
( V_PRO_ID      IN PROFESSORS.PRO_ID%TYPE
, V_PRO_NAME    IN PROFESSORS.PRO_NAME%TYPE
, V_PRO_SSN     IN PROFESSORS.PRO_SSN%TYPE
)
IS
BEGIN
    -- INSERT 쿼리문
    INSERT INTO PROFESSORS(PRO_ID, PRO_NAME, PRO_PW, PRO_SSN)
    VALUES(V_PRO_ID, V_PRO_NAME, SUBSTR(V_PRO_SSN,8), V_PRO_SSN);
    
    -- 커밋
    COMMIT;
    
END;
--==>> Procedure PRC_PRO_PW_INSERT이(가) 컴파일되었습니다.


--○ 교수 이벤트로그 트리거 생성
-- 에러남!
CREATE OR REPLACE TRIGGER TRG_PRO_EVENTLOG
            AFTER
            INSERT OR UPDATE ON PROFESSORS
DECLARE
    V_PRO_ID    PRO_EVENTLOG.PRO_ID%TYPE;
BEGIN
    IF (INSERTING)
        THEN INSERT INTO PRO_EVENTLOG(PRO_ID,MEMO)
            VALUES(PRO_ID,'교수정보 INSERT 쿼리문이 수행되었습니다.');
    ELSIF (UPDATING)
        THEN INSERT INTO PRO_EVENTLOG(PRO_ID,MEMO)
            VALUES(PRO_ID,'교수정보 UPDATE 쿼리문이 수행되었습니다.');
    END IF;
END;
--==>> Trigger TRG_PRO_EVENTLOG이(가) 컴파일되었습니다.
/*
LINE/COL  ERROR
--------- -------------------------------------------------------------
5/14      PL/SQL: SQL Statement ignored
6/20      PL/SQL: ORA-00984: column not allowed here
8/14      PL/SQL: SQL Statement ignored
9/20      PL/SQL: ORA-00984: column not allowed here
오류: 컴파일러 로그를 확인하십시오.
*/

DROP TRIGGER TRG_PRO_EVENTLOG;

--○ 교수정보 삭제 트리거
-- 삭제할 때 과정에 참조하고 있지 않으면 바로 삭제하도록 하면 되고 
-- 과정이나 개설과목 이런 테이블에 참조하고 있는 교수면 교수를 삭제할 때 가지고 있는 정보 모두 NULL값으로 처리
CREATE OR REPLACE TRIGGER TRG_PROFESSORS_DELETE
        AFTER
        DELETE ON PROFESSORS
        FOR EACH ROW
BEGIN
    UPDATE COURSE
    SET PRO_ID = NULL
    WHERE PRO_ID = :OLD.PRO_ID;

    UPDATE ESTABLISHED_SUB
    SET PRO_ID = NULL
    WHERE PRO_ID = :OLD.PRO_ID;
    
END;
--==>> Trigger TRG_PROFESSORS_DELETE이(가) 컴파일되었습니다.

--○ 삭제된 교수 대체하는 프로시저
CREATE OR REPLACE PROCEDURE PRC_PRO_CHANGE
( V_COURSE_ID   IN COURSE.COURSE_ID%TYPE
, V_PRO_ID      IN PROFESSORS.PRO_ID%TYPE
)
IS
BEGIN
    -- COURSE(과정테이블) 교수코드 업데이트
    UPDATE COURSE
    SET PRO_ID = V_PRO_ID
    WHERE COURSE_ID = V_COURSE_ID;
    
    -- CREATE TABLE ESTABLISHED_SUB(개설과목테이블) 교수코드 업데이트
    UPDATE ESTABLISHED_SUB
    SET PRO_ID = V_PRO_ID
    WHERE COURSE_ID = V_COURSE_ID;

END;
--==>> Procedure PRC_PRO_CHANGE이(가) 컴파일되었습니다.


--○ 교수 정보 수정 프로시저
CREATE OR REPLACE PROCEDURE PRC_PRO_UPDATE
( V_PRO_ID      IN PROFESSORS.PRO_ID%TYPE
, V_PRO_NAME    IN PROFESSORS.PRO_NAME%TYPE
, V_PRO_PW     IN PROFESSORS.PRO_PW%TYPE
)
IS
BEGIN
    -- PROFESSORS(교수테이블) 이름, 비밀번호 업데이트
    UPDATE PROFESSORS
    SET PRO_NAME = V_PRO_NAME, PRO_PW = V_PRO_PW
    WHERE PRO_ID = V_PRO_ID;
END;
--==>> Procedure PRC_PRO_UPDATE이(가) 컴파일되었습니다.



--○ 개설과목 INSERT 프로시저
CREATE OR REPLACE PROCEDURE PRC_ESTABLISHED_SUB
( V_EST_SUB_ID      IN ESTABLISHED_SUB.EST_SUB_ID%TYPE
, V_PRO_ID          IN ESTABLISHED_SUB.PRO_ID%TYPE
, V_COURSE_ID       IN ESTABLISHED_SUB.COURSE_ID%TYPE
, V_SUB_ID          IN ESTABLISHED_SUB.SUB_ID%TYPE
, V_ATTEND_PER      IN ESTABLISHED_SUB.ATTEND_PER%TYPE
, V_PRACTICAL_PER   IN ESTABLISHED_SUB.PRACTICAL_PER%TYPE
, V_WRITING_PER     IN ESTABLISHED_SUB.WRITING_PER%TYPE
)
IS
    V_C_START           COURSE.C_START%TYPE;
    V_C_END             COURSE.C_END%TYPE;
    V_S_START           SUBJECTS.S_START%TYPE;
    V_S_END             SUBJECTS.S_END%TYPE;
    
    USER_DEFINE_ERROR   EXCEPTION;

BEGIN
    -- 변수에 값 담기
    SELECT C_START, C_END INTO V_C_START, V_C_END
    FROM COURSE
    WHERE COURSE_ID = V_COURSE_ID;
    
    SELECT S_START, S_END INTO V_S_START, V_S_END
    FROM SUBJECTS
    WHERE SUB_ID = V_SUB_ID;
    
    IF (V_C_START > V_S_START OR V_S_END > V_C_END) --과정 시작일이 과목 시작일보다 뒤거나 과목 종료일이 과정 종료일보다 뒤면 에러발생
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    -- INSERT
    INSERT INTO ESTABLISHED_SUB(EST_SUB_ID,PRO_ID,COURSE_ID,SUB_ID,ATTEND_PER,PRACTICAL_PER,WRITING_PER)
    VALUES (V_EST_SUB_ID, V_PRO_ID,V_COURSE_ID,V_SUB_ID,V_ATTEND_PER,V_PRACTICAL_PER,V_WRITING_PER);
    
    -- 커밋
    COMMIT;
    
    -- 예외 발생
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '과목 설정 날짜가 잘못 입력되었습니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_ESTABLISHED_SUB이(가) 컴파일되었습니다.


--제 컴에서는 돌아가지 않아요!!!!(현정)
--○ 과정 삭제 트리거
--> 수강신청 테이블, 개설과목 테이블에서도 과정 삭제
CREATE OR REPLACE TRIGGER DEL_COURSE
        AFTER
        DELETE ON COURSE
        FOR EACH ROW
BEGIN
    DELETE
    FROM ENROLL
    WHERE COURSE_ID=:OLD.COURSE_ID;
    
    DELETE
    FROM ESTABLISHED_SUB
    WHERE COURSE_ID=:OLD.COURSE_ID;
    
END;




--○ 강의진행여부(강의 예정, 강의 중, 강의 종료)
CREATE OR REPLACE FUNCTION FN_STATUS
( V_S_START    IN SUBJECTS.S_START%TYPE
, V_S_END     IN SUBJECTS.S_END%TYPE
)
RETURN VARCHAR2     -- 반환 자료형 : 자릿수(길이) 지정 안 함
IS
    -- 주요 변수 선언
    VRESULT VARCHAR2(20);
BEGIN
    -- 연산 및 처리
    IF ( V_S_START > SYSDATE )
        THEN VRESULT := '강의 예정';
    ELSIF ( V_S_END <= SYSDATE )
        THEN VRESULT := '강의 중';
    ELSE
        VRESULT := '강의 종료';
    END IF;
    
    -- 최종 결과값 반환
    RETURN VRESULT;
    
END;
--==>> Function FN_STATUS이(가) 컴파일되었습니다.


--○ 수강과목 총점
CREATE OR REPLACE FUNCTION FN_TOTAL_SCORE
( V_ST_ID    IN STUDENTS.ST_ID%TYPE
, V_SUB_ID   IN ESTABLISHED_SUB.SUB_ID%TYPE
)
RETURN NUMBER     -- 반환 자료형 : 자릿수(길이) 지정 안 함
IS
    -- 주요 변수 선언
    VRESULT NUMBER;
    
    V_A_PER ESTABLISHED_SUB.ATTEND_PER%TYPE;
    V_P_PER ESTABLISHED_SUB.ATTEND_PER%TYPE;
    V_W_PER ESTABLISHED_SUB.ATTEND_PER%TYPE;
    
    V_A_SCORE SCORE.ATTEND_SCORE%TYPE;
    V_P_SCORE SCORE.ATTEND_SCORE%TYPE;
    V_W_SCORE SCORE.ATTEND_SCORE%TYPE;
    
BEGIN

    -- 비중 받아오기
    SELECT NVL(ATTEND_PER, 0), NVL(PRACTICAL_PER, 0), NVL(WRITING_PER, 0) INTO V_A_PER, V_P_PER, V_W_PER
    FROM ESTABLISHED_SUB
    WHERE SUB_ID = V_SUB_ID;
    
    -- 점수 받아오기
    SELECT NVL(ATTEND_SCORE, 0), NVL(PRACTICAL_SCORE, 0), NVL(WRITING_SCORE, 0) INTO V_A_SCORE, V_P_SCORE, V_W_SCORE
    FROM SCORE
    WHERE E_ID = (SELECT E.E_ID
                  FROM ENROLL E
                  WHERE E.ST_ID = V_ST_ID)
          AND EST_SUB_ID = (SELECT ES.EST_SUB_ID
                            FROM ESTABLISHED_SUB ES
                            WHERE ES.SUB_ID = V_SUB_ID);

    VRESULT := (V_A_SCORE*V_A_PER + V_P_SCORE*V_P_PER + V_W_SCORE*V_W_PER)/100;
    
    -- 최종 결과값 반환
    RETURN VRESULT;
    
END;
--==>> Function FN_TOTAL_SCORE이(가) 컴파일되었습니다.


--성적코드 시퀀스 생성
CREATE SEQUENCE SEQ_SCORE_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==>> Sequence SEQ_SCORE_ID이(가) 생성되었습니다.


--○ 성적입력 프로시저
CREATE OR REPLACE PROCEDURE PRC_SCORE_INSERT 
( V_E_ID                IN SCORE.E_ID%TYPE                -- 수강신청한 과정
, V_EST_SUB_ID          IN SCORE.EST_SUB_ID%TYPE            -- 개설된 과목
, V_ATTEND_SCORE        IN SCORE.ATTEND_SCORE%TYPE
, V_PRACTICAL_SCORE     IN SCORE.PRACTICAL_SCORE%TYPE
, V_WRITING_SCORE       IN SCORE.WRITING_SCORE%TYPE
)
IS
BEGIN
    

    -- SCORE(성적테이블) INSERT 
    INSERT INTO SCORE(SCORE_ID, E_ID, EST_SUB_ID, ATTEND_SCORE, PRACTICAL_SCORE, WRITING_SCORE)
    VALUES('SCORE' || SEQ_SCORE_ID.NEXTVAL, V_E_ID, V_EST_SUB_ID, V_ATTEND_SCORE, V_PRACTICAL_SCORE, V_WRITING_SCORE);

END;
--==>> Procedure PRC_SCORE_INSERT이(가) 컴파일되었습니다.


--○ 성적수정 프로시저
CREATE OR REPLACE PROCEDURE PRC_SCORE_UPDATE
( V_SCORE_ID            IN SCORE.SCORE_ID%TYPE
, V_ATTEND_SCORE        IN SCORE.ATTEND_SCORE%TYPE
, V_PRACTICAL_SCORE     IN SCORE.PRACTICAL_SCORE%TYPE
, V_WRITING_SCORE       IN SCORE.WRITING_SCORE%TYPE
)
IS
BEGIN
    -- SCORE(성적테이블) 출결, 실기, 필기 업데이트
    UPDATE SCORE
    SET ATTEND_SCORE = V_ATTEND_SCORE, PRACTICAL_SCORE = V_PRACTICAL_SCORE, WRITING_SCORE = V_WRITING_SCORE
    WHERE SCORE_ID = V_SCORE_ID;

END;
--==>> Procedure PRC_SCORE_UPDATE이(가) 컴파일되었습니다.

--○ 성적삭제 프로시저
CREATE OR REPLACE PROCEDURE PRC_SCORE_DELETE
( V_SCORE_ID            IN SCORE.SCORE_ID%TYPE
)
IS
BEGIN
    -- SCORE(성적테이블) 에서 삭제
    DELETE
    FROM SCORE
    WHERE SCORE_ID = V_SCORE_ID;

END;
--==>> Procedure PRC_SCORE_DELETE이(가) 컴파일되었습니다.

--과정코드 시퀀스 생성
CREATE SEQUENCE SEQ_COURSE_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==>> Sequence SEQ_COURSE_ID이(가) 생성되었습니다.


--○ 과정 입력 프로시저
CREATE OR REPLACE PROCEDURE PRC_COR_INSERT
( V_COURSE_NAME  IN COURSE.COURSE_NAME%TYPE
, V_C_START     IN COURSE.C_START%TYPE
, V_C_END       IN COURSE.C_END%TYPE
, V_CLASSROOM   IN COURSE.CLASSROOM%TYPE
)
IS
BEGIN

    INSERT INTO COURSE(COURSE_ID, COURSE_NAME, C_START,C_END, CLASSROOM)
    VALUES ('COURSE' || SEQ_COURSE_ID.NEXTVAL, V_COURSE_NAME, V_C_START,V_C_END,V_CLASSROOM);

END;
--==>> Procedure PRC_COR_INSERT이(가) 컴파일되었습니다.


--○ 과정 수정 프로시저
CREATE OR REPLACE PROCEDURE PRC_COR_UPDATE
( V_COURSE_ID    IN COURSE.COURSE_ID%TYPE 
, V_COURSE_NAME  IN COURSE.COURSE_NAME%TYPE
, V_C_START      IN COURSE.C_START%TYPE
, V_C_END        IN COURSE.C_END%TYPE
, V_CLASSROOM    IN COURSE.CLASSROOM%TYPE
)
IS
BEGIN

    UPDATE COURSE
    SET COURSE_NAME = V_COURSE_NAME, C_START = V_C_START, C_END = V_C_END, CLASSROOM = V_CLASSROOM
    WHERE COURSE_ID = V_COURSE_ID; 

END;
--==>> Procedure PRC_COR_UPDATE이(가) 컴파일되었습니다.



--○ 과목별 배점(비중) 부여
CREATE OR REPLACE PROCEDURE PRC_SUB_SCORE_RATIO
( V_EST_SUB_ID     IN ESTABLISHED_SUB.EST_SUB_ID%TYPE 
, V_ATTEND_PER     IN ESTABLISHED_SUB.ATTEND_PER%TYPE
, V_PRACTICAL_PER  IN ESTABLISHED_SUB.PRACTICAL_PER%TYPE
, V_WRITING_PER    IN ESTABLISHED_SUB.WRITING_PER%TYPE
)
IS
BEGIN
    
    UPDATE ESTABLISHED_SUB
    SET ATTEND_PER = V_ATTEND_PER, PRACTICAL_PER = V_PRACTICAL_PER, WRITING_PER = V_WRITING_PER
    WHERE EST_SUB_ID = V_EST_SUB_ID; 
    
END;
--==>> Procedure PRC_SUB_SCORE_RATIO이(가) 컴파일되었습니다.




--지윤
--○과목 DELETE 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_SUB_DELETE
(
    V_SUB_ID IN SUBJECTS.SUB_ID%TYPE
)
IS
    NONEXIST_ERROR  EXCEPTION;
BEGIN
    DELETE
    FROM SUBJECTS
    WHERE SUB_ID = V_SUB_ID;
    
    IF SQL%NOTFOUND
    THEN RAISE NONEXIST_ERROR;
    END IF;
        
    COMMIT;

    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20009,'일치하는 데이터가 없습니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>>Procedure PRC_SUB_DELETE이(가) 컴파일되었습니다.

--○ 과목 UPDATE 프로시저

CREATE OR REPLACE PROCEDURE PRC_SUB_UPDATE
(
    V_SUB_ID    IN  SUBJECTS.SUB_ID%TYPE
,   V_SUB_NAME    IN  SUBJECTS.SUB_NAME%TYPE 
)
IS
    V_COUNT             NUMBER;
    NOT_FOUND_ERROR    EXCEPTION;
BEGIN
    --동일한 과목코드이 있는지 체크
    SELECT COUNT(*) INTO V_COUNT
    FROM SUBJECTS
    WHERE SUB_ID = V_SUB_ID;
    
    --동일한 과목코드가 있는 경우
    IF V_COUNT = 1
    THEN
        UPDATE SUBJECTS
        SET    SUB_NAME = V_SUB_NAME
        WHERE  SUB_ID = V_SUB_ID;
        
        COMMIT;
    ELSE
        RAISE NOT_FOUND_ERROR;
    END IF;
    
    EXCEPTION
    WHEN NOT_FOUND_ERROR
        THEN RAISE_APPLICATION_ERROR(-20010, '일치하는 데이터가 없습니다.');
             ROLLBACK;
    WHEN OTHERS
        THEN ROLLBACK;
END;
--==>>Procedure PRC_SUB_UPDATE이(가) 컴파일되었습니다.


--개설과목코드 시퀀스 생성
CREATE SEQUENCE SEQ_E_SUB_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==>> Sequence SEQ_E_SUB_ID이(가) 생성되었습니다.


--○ 개설과목 INSERT 프로시저
CREATE OR REPLACE PROCEDURE PRC_ESTABLISHED_SUB
( V_PRO_ID          IN ESTABLISHED_SUB.PRO_ID%TYPE
, V_COURSE_ID       IN ESTABLISHED_SUB.COURSE_ID%TYPE
, V_SUB_ID          IN ESTABLISHED_SUB.SUB_ID%TYPE
)
IS
    V_C_START           COURSE.C_START%TYPE;
    V_C_END             COURSE.C_END%TYPE;
    V_S_START           SUBJECTS.S_START%TYPE;
    V_S_END             SUBJECTS.S_END%TYPE;
    
    USER_DEFINE_ERROR   EXCEPTION;

BEGIN
    -- 변수에 값 담기
    SELECT C_START, C_END INTO V_C_START, V_C_END
    FROM COURSE
    WHERE COURSE_ID = V_COURSE_ID;
    
    SELECT S_START, S_END INTO V_S_START, V_S_END
    FROM SUBJECTS
    WHERE SUB_ID = V_SUB_ID;
    
    IF (V_C_START > V_S_START OR V_S_END > V_C_END) --과정 시작일이 과목 시작일보다 뒤거나 과목 종료일이 과정 종료일보다 뒤면 에러발생
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    -- INSERT
    INSERT INTO ESTABLISHED_SUB(EST_SUB_ID,PRO_ID,COURSE_ID,SUB_ID)
    VALUES ('ESUB' || SEQ_E_SUB_ID.NEXTVAL, V_PRO_ID,V_COURSE_ID,V_SUB_ID);
    
    -- 커밋
    COMMIT;
    
    -- 예외 발생
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '과목 설정 날짜가 잘못 입력되었습니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_ESTABLISHED_SUB이(가) 컴파일되었습니다.


--과목코드 시퀀스 생성
CREATE SEQUENCE SEQ_SUB_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==>> Sequence SEQ_SUB_ID이(가) 생성되었습니다.


--○ 과목 + 개설과목 INSERT 
CREATE OR REPLACE PROCEDURE PRC_SUB_INSERT
( V_COURSE_ID     IN COURSE.COURSE_NAME%TYPE
, V_SUB_NAME        IN SUBJECTS.SUB_NAME%TYPE
, V_S_START         IN SUBJECTS.S_START%TYPE
, V_S_END           IN SUBJECTS.S_END%TYPE
, V_BOOK_NAME       IN SUBJECTS.BOOK_NAME%TYPE
, V_PRO_ID        IN PROFESSORS.PRO_NAME%TYPE
)
IS
    V_EST_SUB_ID      ESTABLISHED_SUB.EST_SUB_ID%TYPE;
   -- V_PRO_ID        ESTABLISHED_SUB.PRO_ID%TYPE;
   -- V_COURSE_ID     ESTABLISHED_SUB.COURSE_ID%TYPE;
    V_SUB_ID        ESTABLISHED_SUB.SUB_ID%TYPE;
BEGIN

/*
    --동명이인 있을 수도 있으니깐 조건절에 다른 조건 추가해야함
    SELECT PRO_ID INTO V_PRO_ID
    FROM PROFESSORS
    WHERE PRO_NAME = V_PRO_NAME AND 

    -- 근데 이것도 뭔가... 과정이름 같고 교수자이름도 같을 수 있잖아...ㅠㅠㅠ
    SELECT COURSE_ID INTO V_COURSE_ID
    FROM PROFESSORS
    WHERE COURSE_NAME = V_COURSE_NAME AND --교수자 이름도 같은지 검사
*/
    
    V_SUB_ID := 'SUB' || SEQ_SUB_ID.NEXTVAL;

    -- SUBJECTS(과목) 테이블에 INSERT
    INSERT INTO SUBJECTS(SUB_ID, SUB_NAME, S_START, S_END, BOOK_NAME)
    VALUES (V_SUB_ID, V_SUB_NAME, V_S_START, V_S_END, V_BOOK_NAME);

    -- ESTABLISHED_SUB(과목) 테이블에 INSERT
    PRC_ESTABLISHED_SUB(V_PRO_ID, V_COURSE_ID, V_SUB_ID);
    --EXEC PRC_ESTABLISHED_SUB(V_PRO_ID, V_COURSE_ID, V_SUB_ID); -- 이렇게 작성해야 하는지 아닌지

    -- 예외
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK;


END;
--==>> Procedure PRC_SUB_INSERT이(가) 컴파일되었습니다.



--○ 교수 삭제 프로시저
CREATE OR REPLACE PROCEDURE PRC_PRO_DELETE
( V_PRO_ID  IN PROFESSORS.PRO_ID%TYPE
)
IS
BEGIN
    -- PROFESSORS(교수정보테이블) 에서 삭제
    DELETE
    FROM PROFESSORS
    WHERE PRO_ID = V_PRO_ID;
    
    --COMMIT;
END;
--==>> Procedure PRC_PRO_DELETE이(가) 컴파일되었습니다.


--○ 관리자 삭제 프로시저
CREATE OR REPLACE PROCEDURE PRC_AD_DELETE
( V_AD_ID   IN ADMINISTRATOR.ADMIN_ID%TYPE
)
IS
BEGIN
    -- ADMINISTRATOR(관리자 테이블) 에서 삭제
    DELETE
    FROM ADMINISTRATOR
    WHERE ADMIN_ID = V_AD_ID;
    
    --COMMIT;
END;
--==>> Procedure PRC_AD_DELETE이(가) 컴파일되었습니다.

/*

[제출 항목]
1. ERD
2. 물리설계 ERD
3. 테이블 구조 SQL파일 (프로시저 FUNCTION, TRIGGER)
4. 요구분석서대로 쿼리문 구성. SQL
5. 팀원들 후기(세미프로젝트 하면서 얻게 된 내용)


TIP. 추출해서 쓸 수 있는 내용 컬럼화 시키지 않는다.
그 문장의 동사가 테이블 명사가 컬럼
제4정규화 일대다로 깨뜨리는 관계에서 파생테이블 생긴다.

*/
