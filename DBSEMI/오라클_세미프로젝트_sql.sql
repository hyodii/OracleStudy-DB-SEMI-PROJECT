SELECT USER
FROM DUAL;
--==>> HR

--○ 교수자 요구 분석
-- 3. 성적 출력 기능
-- 자신이 강의한 과목, "과목명, 과목 기간(시작), 과목기간(끝), 교재명, 학생명, 출결, 실기, 필기, 총점, 등수
-- 과정 중도탈락 시: 수강한 과목 성적 출력, 중도탈락 여부 출력
SELECT SUB.SUB_NAME "과목명", SUB.S_START "과목 시작일", SUB.S_END "과목 종료일", SUB.BOOK_NAME "교재명"
     , STU.ST_NAME "학생명", SC.ATTEND_SCORE "출결점수", SC.PRACTICAL_SCORE "실기점수", SC.WRITING_SCORE "필기점수"
     , (NVL(SC.ATTEND_SCORE, 0) + NVL(SC.PRACTICAL_SCORE, 0) + NVL(SC.WRITING_SCORE, 0)) "총점"
     , RANK() OVER(ORDER BY (NVL(SC.ATTEND_SCORE, 0) + NVL(SC.PRACTICAL_SCORE, 0) + NVL(SC.WRITING_SCORE, 0)) DESC) "등수"
     , CASE WHEN MID.E_ID IS NOT NULL THEN 'Y'
            ELSE 'N'
       END "중도포기"
FROM STUDENTS STU LEFT JOIN ENROLL E
    ON STU.ST_ID = E.ST_ID
        LEFT JOIN SCORE SC
        ON E.E_ID = SC.E_ID
            LEFT JOIN ESTABLISHED_SUB EST
            ON SC.EST_SUB_ID = EST.EST_SUB_ID
                LEFT JOIN SUBJECTS SUB
                ON EST.SUB_ID = SUB.SUB_ID
                    LEFT JOIN MID_DROP MID
                    ON E.E_ID = MID.E_ID                    
WHERE PRO_ID IN ('PRO1', 'PRO2'); -- WHERE절에 해당되는 교수 코드 입력

SELECT *
FROM SUBJECTS;

--○과목 DELETE 트리거 테스트
DELETE
FROM SUBJECTS
WHERE SUB_ID = 'SUB1';
--==>> 1 행 이(가) 삭제되었습니다.


SELECT *
FROM STUDENTS;

SELECT *
FROM ENROLL;

SELECT *
FROM MID_DROP;

SELECT *
FROM SCORE;

--○ 관리자 측 요구분석

--교수자 계정 관리 기능 구현
-- 모든 교수자의 정보를 출력하여 볼 수 있어야 한다.(교수자명, 배정된 과목명, 과목 기간, 교재 명, 강의실, 강의진행여부)
-- 배정된 과목 없어서 NULL값일 때 처리
SELECT P.PRO_NAME "교수자명", S.SUB_NAME "배정된 과목명", S.S_START || ' ~ ' || S.S_END "과목 기간", S.BOOK_NAME"교재명", CLASSROOM "강의실", FN_STATUS(S.S_START, S.S_END) "강의진행여부"
FROM PROFESSORS P LEFT JOIN ESTABLISHED_SUB ES
ON P.PRO_ID = ES.PRO_ID
    LEFT JOIN SUBJECTS S
    ON ES.SUB_ID = S.SUB_ID;
    
    
--과정 관리 기능 구현
-- 관리자는 등록된 모든 과정의 정보를 출력하여 볼 수 있어야 한다. (과정명, 강의실, 과목명, 과목 기간, 교재명, 교수자명)       
SELECT C.COURSE_NAME "과정명", C.CLASSROOM "강의실", S.SUB_NAME "과목명", S.S_START || ' ~ ' || S.S_END "과목 기간", S.BOOK_NAME "교재명", P.PRO_NAME"교수자명"
FROM COURSE C JOIN ESTABLISHED_SUB ES
ON C.COURSE_ID = ES.COURSE_ID
    JOIN SUBJECTS S
    ON S.SUB_ID = ES.SUB_ID 
        JOIN PROFESSORS P
        ON ES.PRO_ID = P.PRO_ID
ORDER BY C.COURSE_ID;



--학생 관리 기능 구현
-- 관리자는 등록된 모든 학생의 정보를 출력할 수 있어야 한다. (학생 이름, 과정명, 수강과목, 수강과목 총점, 중도 탈락 사실)
SELECT STD.ST_NAME "학생 이름", C.COURSE_ID "과정명", S.SUB_NAME "수강과목", FN_TOTAL_SCORE(SCORE.SCORE_ID, SCORE.EST_SUB_ID) "수강과목 총점", NVL2(MD.E_ID, '중도탈락', '중도탈락아님') "중도 탈락 사실"
FROM STUDENTS STD LEFT JOIN ENROLL E
ON STD.ST_ID = E.ST_ID
    LEFT JOIN COURSE C
    ON E.COURSE_ID = C.COURSE_ID
        LEFT JOIN ESTABLISHED_SUB ES
        ON C.COURSE_ID = ES.COURSE_ID
            LEFT JOIN SUBJECTS S
            ON ES.SUB_ID = S.SUB_ID
                LEFT JOIN MID_DROP MD
                ON E.E_ID = MD.E_ID
                    LEFT JOIN SCORE
                    ON E.E_ID = SCORE.E_ID AND SCORE.EST_SUB_ID = ES.EST_SUB_ID
ORDER BY STD.ST_ID;

--수정중
SELECT STU.ST_ID"학생이름", E.COURSE_ID "과정명", SUB.SUB_NAME "과목명", SUB.S_START || ' - ' || SUB.S_END "교육 기간", SUB.BOOK_NAME "교재명"
     , SC.ATTEND_SCORE "출결점수", SC.PRACTICAL_SCORE "실기점수", SC.WRITING_SCORE "필기점수"
     , (NVL(SC.ATTEND_SCORE, 0) + NVL(SC.PRACTICAL_SCORE, 0) + NVL(SC.WRITING_SCORE, 0)) "총점"
     , RANK() OVER(ORDER BY (NVL(SC.ATTEND_SCORE, 0) + NVL(SC.PRACTICAL_SCORE, 0) + NVL(SC.WRITING_SCORE, 0)) DESC) "등수"
     , CASE WHEN MID.E_ID IS NOT NULL THEN 'Y'
            ELSE 'N'
       END "중도포기"
FROM STUDENTS STU LEFT JOIN ENROLL E
    ON STU.ST_ID = E.ST_ID
        LEFT JOIN SCORE SC
        ON E.E_ID = SC.E_ID
            LEFT JOIN ESTABLISHED_SUB EST
            ON SC.EST_SUB_ID = EST.EST_SUB_ID
                LEFT JOIN SUBJECTS SUB
                ON EST.SUB_ID = SUB.SUB_ID
                    LEFT JOIN MID_DROP MID
                    ON E.E_ID = MID.E_ID                    
WHERE STU.ST_ID IN ('STU1', 'STU2');

SELECT E_ID
FROM SCORE;















--------------------------------------------------------------------------------
--○ 테스트

--○ 관리자 INSERT
INSERT INTO ADMINISTRATOR(ADMIN_ID, ADMIN_PW) VALUES('AD1', 'QWER1234');
INSERT INTO ADMINISTRATOR(ADMIN_ID, ADMIN_PW) VALUES('AD2', 'ASDF1234');

SELECT *
FROM ADMINISTRATOR;
--==>>
/*
AD1	QWER1234
AD2	ASDF1234
*/

--○ 교수 INSERT 프로시저 - PRC_PRO_PW_INSERT
EXEC PRC_PRO_PW_INSERT('PRO1', '남궁 성', '840218-2813239');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM PROFESSORS;
--==>> PRO1	남궁 성	2813239	840218-2813239

EXEC PRC_PRO_PW_INSERT('PRO2', '서진수', '111111-1111111');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM PROFESSORS;
--==>> 
/*
PRO1	남궁 성	2813239	840218-2813239
PRO2	서진수	1111111	111111-1111111
*/

--○ 학생 INSERT 프로시저 - PRC_STUDENT_INSERT
EXEC PRC_STUDENT_INSERT('STU1', '정회일', '111111-3111111');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

EXEC PRC_STUDENT_INSERT('STU2', '김초엽', '111111-4111111');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM STUDENTS;
--==>> 
/*
STU1	3111111	정회일	111111-3111111	2021-09-25
STU2	4111111	김초엽	111111-4111111	2021-09-25
*/

EXEC PRC_STUDENT_INSERT('정효진','222222-2222222');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM STUDENTS;
--==>> 
/*
STU1	3111111	정회일	111111-3111111	2021-09-26
STU2	4111111	김초엽	111111-4111111	2021-09-26
STU3	2222222	정효진	222222-2222222	2021-09-26
*/

--○ STUDENT_DELETE 프로시저 - PRC_STUDENT_DELETE
EXEC PRC_STUDENT_DELETE('STU3','2222222','정효진','222222-2222222');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM STUDENTS;
/*
STU1	3111111	정회일	111111-3111111	2021-09-26
STU2	4111111	김초엽	111111-4111111	2021-09-26
*/

--○ STUDENT_UPDATE 프로시저 - PRC_STUDENT_UPDATE
EXEC PRC_STUDENT_UPDATE('STU1','정회일','1234567');

SELECT *
FROM STUDENTS;
--==>>
/*
STU1	1234567	정회일	111111-3111111	2021-09-26
STU2	4111111	김초엽	111111-4111111	2021-09-26
*/

--○ 과정 입력 프로시저 - PRC_COR_INSERT
EXEC PRC_COR_INSERT('개발자양성과정', TO_DATE('2020-11-24', 'YYYY-MM-DD'), TO_DATE('2021-4-18', 'YYYY-MM-DD'), '오라클강의실A1');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

EXEC PRC_COR_INSERT('빅데이터전문가과정', TO_DATE('2020-6-14', 'YYYY-MM-DD'), TO_DATE('2020-12-30', 'YYYY-MM-DD'), '자바강의실B1');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM COURSE;
--==>> 
/*
COURSE1	개발자양성과정		2020-11-24	2021-04-18	오라클강의실A1
COURSE2	빅데이터전문가과정		2020-06-14	2020-12-30	자바강의실B1
*/


--○ 과목 + 개설과목 INSERT - PRC_SUB_INSERT
EXEC PRC_SUB_INSERT('COURSE1', '오라클중급', TO_DATE('2020-12-24', 'YYYY-MM-DD'),  TO_DATE('2021-1-19', 'YYYY-MM-DD'), '오라클의 정석', 'PRO1');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

-- 예외처리 확인!!
EXEC PRC_SUB_INSERT('COURSE1', '오라클중급', TO_DATE('2020-10-24', 'YYYY-MM-DD'),  TO_DATE('2021-1-19', 'YYYY-MM-DD'), '오라클의 정석', 'PRO1');
--==>> (예외처리는 됐다!! 다만 안내문 출력이 안될 뿐)PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM SUBJECTS;
--==>> SUB1	오라클중급	2020-12-24	2021-01-19		오라클의 정석

SELECT *
FROM ESTABLISHED_SUB;
--==>> ESUB1	PRO1	COURSE1	SUB1			

EXEC PRC_SUB_INSERT('COURSE2', '자바고급', TO_DATE('2020-6-14', 'YYYY-MM-DD'), TO_DATE('2020-12-30', 'YYYY-MM-DD'), '고급자바마스터', 'PRO2');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM SUBJECTS;
--==>> 
/*
SUB1	오라클중급	2020-12-24	2021-01-19		오라클의 정석
SUB3	자바고급	2020-06-14	2020-12-30		고급자바마스터
*/

SELECT *
FROM ESTABLISHED_SUB;
--==>> 
/*
ESUB1	PRO1	COURSE1	SUB1			
ESUB2	PRO2	COURSE2	SUB3			
*/

--○ 교수정보 삭제 프로시저 확인
EXEC PRC_SUB_DELETE('PRO1');

--○ 교수정보 삭제 트리거 확인
SELECT *
FROM PROFESSORS
WHERE PRO_ID = 'PRO1';
--==>> PRO1	남궁 성	2813239	840218-2813239

DELETE
FROM PROFESSORS
WHERE PRO_ID = 'PRO2';
--==>> 1 행 이(가) 삭제되었습니다.

SELECT *
FROM PROFESSORS;
--==>> 조회결과 없음!

SELECT *
FROM ESTABLISHED_SUB;

SELECT *
FROM COURSE;

-- 교수 다시 추가!
--○ 교수 INSERT 프로시저 - PRC_PRO_PW_INSERT
EXEC PRC_PRO_PW_INSERT('PRO1', '남궁 성', '840218-2813239');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM PROFESSORS;
--==>> PRO1	남궁 성	2813239	840218-2813239

EXEC PRC_PRO_PW_INSERT('PRO2', '서진수', '111111-1111111');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM PROFESSORS;
--==>> 
/*
PRO1	남궁 성	2813239	840218-2813239
PRO2	서진수	1111111	111111-1111111
*/

--○ 과정 추가(수강신청 테스트를 위함)
EXEC PRC_COR_INSERT('백엔드개발자양성과정', TO_DATE('2021-10-14', 'YYYY-MM-DD'), TO_DATE('2022-3-30', 'YYYY-MM-DD'), '자바강의실C');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

EXEC PRC_COR_INSERT('풀스택개발자양성과정', TO_DATE('2021-12-23', 'YYYY-MM-DD'), TO_DATE('2022-6-15', 'YYYY-MM-DD'), '자바강의실D');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM COURSE;
--==>>
/*
COURSE1	개발자양성과정		2020-11-24	2021-04-18	오라클강의실A1
COURSE2	빅데이터전문가과정		2020-06-14	2020-12-30	자바강의실B1
COURSE3	백엔드개발자양성과정		2021-10-14	2022-03-30	자바강의실C
COURSE5	풀스택개발자양성과정		2021-12-23	2022-06-15	자바강의실D
*/

--○ 과목 + 개설과목 INSERT - PRC_SUB_INSERT
EXEC PRC_SUB_INSERT('COURSE3', '스프링5', TO_DATE('2021-12-24', 'YYYY-MM-DD'),  TO_DATE('2022-1-05', 'YYYY-MM-DD'), '스프링마스터', 'PRO2');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

EXEC PRC_SUB_INSERT('COURSE5', 'HTML', TO_DATE('2022-1-15', 'YYYY-MM-DD'),  TO_DATE('2022-3-20', 'YYYY-MM-DD'), '재밌는 HTML', 'PRO1');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.


SELECT *
FROM SUBJECTS;
--==>> 
/*
SUB1	오라클중급	2020-12-24	2021-01-19		오라클의 정석
SUB3	자바고급	2020-06-14	2020-12-30		고급자바마스터
SUB4	스프링5	2021-12-24	2022-01-05		스프링마스터
SUB5	HTML	2022-01-15	2022-03-20		재밌는 HTML
*/

--○ 수강신청 INSERT 
--예외처리 테스트 1 - 계정등록일과 개강일 - 수강신청일은 계정등록일보다 빠르거나, 개강일보다 느리거나 같을 수 없다.
EXEC PRC_ENROLL_INSERT('ENROLL1', 'STU1', 'COURSE1', TO_DATE('2020-6-14', 'YYYY-MM-DD'));
--==>> 수강 신청이 불가능합니다.
EXEC PRC_ENROLL_INSERT('ENROLL1', 'STU1', 'COURSE1', TO_DATE('2020-11-25', 'YYYY-MM-DD'));
--==>> 수강 신청이 불가능합니다.

--정상 입력
EXEC PRC_ENROLL_INSERT('ENROLL1', 'STU1', 'COURSE3', TO_DATE('2021-9-27', 'YYYY-MM-DD'));
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

EXEC PRC_ENROLL_INSERT('ENROLL2', 'STU2', 'COURSE3', TO_DATE('2021-9-27', 'YYYY-MM-DD'));
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM ENROLL;
--==>> 
/*
ENROLL1	STU1	COURSE3	2021-09-27
ENROLL2	STU2	COURSE3	2021-09-27
*/

--예외처리 테스트 2 - 동일한 과정 신청 여부- 한 학생이 같은 과정을 신청할 수 없다.
EXEC PRC_ENROLL_INSERT('ENROLL3', 'STU1', 'COURSE3', TO_DATE('2021-9-26', 'YYYY-MM-DD'));
--==>> 이미 신청한 과목입니다. ??

--예외처리 테스트 3 - 수강 날짜 중복 - 한 학생이 기존에 수강한 과정의 날짜가, 새로 수강하려는 과정의 날짜와 겹칠 수 없다.
EXEC PRC_ENROLL_INSERT('ENROLL3', 'STU1', 'COURSE5', TO_DATE('2021-9-27', 'YYYY-MM-DD'));
--==>> 날짜가 중복되는 과목입니다. ??


--○ 중도포기 INSERT 
--예외처리 테스트 - 수강기간 이전
EXEC PRC_MID_DROP_INSERT('DROP1', 'ENROLL1', TO_DATE('2021-04-01', 'YYYY-MM-DD'));
--==>> 중도포기 날짜가 잘못 입력되었습니다.

--예외처리 테스트 - 수강기간 이후
EXEC PRC_MID_DROP_INSERT('DROP1', 'ENROLL1', TO_DATE('2022-04-01', 'YYYY-MM-DD'));
--==>> 중도포기 날짜가 잘못 입력되었습니다.

--정상 처리
EXEC PRC_MID_DROP_INSERT('DROP1', 'ENROLL1', TO_DATE('2022-01-01', 'YYYY-MM-DD'));
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

--이미 DROP한 사람 처리
EXEC PRC_MID_DROP_INSERT('DROP1', 'ENROLL1', TO_DATE('2022-01-01', 'YYYY-MM-DD'));
--==>> ORA-20055: 이미 DROP한 사람입니다.


SELECT *
FROM COURSE;

SELECT *
FROM MID_DROP;
--==>> DROP1	ENROLL1	2022-01-01

SELECT *
FROM SUBJECTS;
/*
SUB3	자바고급	2020-06-14	2020-12-30		고급자바마스터
SUB4	스프링5	2021-12-24	2022-01-05		스프링마스터
SUB6	오라클초급	2022-01-15	2022-02-15		오라클의 시작
*/

EXEC PRC_SUB_UPDATE('SUB1','자바고급');
--==>> ORA-20010: 일치하는 데이터가 없습니다.


UPDATE SUBJECTS
SET 
SUB_ID = 'SUB10'
WHERE SUB_NAME = '오라클초급';

SELECT *
FROM SUBJECTS;
/*
SUB3	자바고급	2020-06-14	2020-12-30		고급자바마스터
SUB4	스프링5	2021-12-24	2022-01-05		스프링마스터
SUB10	오라클초급	2022-01-15	2022-02-15		오라클의 시작
*/

--! 쿼리문 테스트
--○ 관리자 측 요구분석

--교수자 계정 관리 기능 구현
-- 모든 교수자의 정보를 출력하여 볼 수 있어야 한다.(교수자명, 배정된 과목명, 과목 기간, 교재 명, 강의실, 강의진행여부)
-- 배정된 과목 없어서 NULL값일 때 처리
SELECT P.PRO_NAME "교수자명", S.SUB_NAME "배정된 과목명", S.S_START || ' ~ ' || S.S_END "과목 기간", S.BOOK_NAME"교재명", CLASSROOM "강의실", FN_STATUS(S.S_START, S.S_END) "강의진행여부"
FROM PROFESSORS P LEFT JOIN ESTABLISHED_SUB ES
ON P.PRO_ID = ES.PRO_ID
    LEFT JOIN SUBJECTS S
    ON ES.SUB_ID = S.SUB_ID;
--==>> 
/*
남궁 성	오라클중급	2020-12-24 ~ 2021-01-19	오라클의 정석		강의 중
남궁 성	HTML	2022-01-15 ~ 2022-03-20	재밌는 HTML		강의 예정
서진수	스프링5	2021-12-24 ~ 2022-01-05	스프링마스터		강의 예정
서진수	자바고급	2020-06-14 ~ 2020-12-30	고급자바마스터		강의 중
*/
    
--학생 관리 기능 구현
-- 관리자는 등록된 모든 학생의 정보를 출력할 수 있어야 한다. (학생 이름, 과정명, 수강과목, 수강과목 총점, 중도 탈락 사실)
SELECT STD.ST_NAME "학생 이름", C.COURSE_ID "과정명", S.SUB_NAME "수강과목", FN_TOTAL_SCORE(SCORE.SCORE_ID, SCORE.EST_SUB_ID) "수강과목 총점", NVL2(MD.E_ID, '중도탈락', '중도탈락아님') "중도 탈락 사실"
FROM STUDENTS STD LEFT JOIN ENROLL E
ON STD.ST_ID = E.ST_ID
    LEFT JOIN COURSE C
    ON E.COURSE_ID = C.COURSE_ID
        LEFT JOIN ESTABLISHED_SUB ES
        ON C.COURSE_ID = ES.COURSE_ID
            LEFT JOIN SUBJECTS S
            ON ES.SUB_ID = S.SUB_ID
                LEFT JOIN MID_DROP MD
                ON E.E_ID = MD.E_ID
                    LEFT JOIN SCORE
                    ON E.E_ID = SCORE.E_ID AND SCORE.EST_SUB_ID = ES.EST_SUB_ID
ORDER BY STD.ST_ID;
--==>> 
/*
정회일	COURSE3	스프링5		중도탈락
김초엽	COURSE3	스프링5		중도탈락아님
*/


--자신이 수강한 과목에 대한 정보
--학생이름, 과정명, 과목명, 교육기간, 교재명, 출결,실기,필기, 총점, 
SELECT STU.ST_NAME "학생이름", E.COURSE_ID "과정명", SUB.SUB_NAME "과목명", SUB.S_START || ' - ' || SUB.S_END "교육 기간", SUB.BOOK_NAME "교재명"
     , SC.ATTEND_SCORE "출결점수", SC.PRACTICAL_SCORE "실기점수", SC.WRITING_SCORE "필기점수"
     , (NVL(SC.ATTEND_SCORE, 0) + NVL(SC.PRACTICAL_SCORE, 0) + NVL(SC.WRITING_SCORE, 0)) "총점"
     , RANK() OVER(ORDER BY (NVL(SC.ATTEND_SCORE, 0) + NVL(SC.PRACTICAL_SCORE, 0) + NVL(SC.WRITING_SCORE, 0)) DESC) "등수"
     , CASE WHEN MID.E_ID IS NOT NULL THEN 'Y'
            ELSE 'N'
       END "중도포기"
FROM STUDENTS STU LEFT JOIN ENROLL E
    ON STU.ST_ID = E.ST_ID
        LEFT JOIN SCORE SC
        ON E.E_ID = SC.E_ID
            LEFT JOIN ESTABLISHED_SUB EST
            ON SC.EST_SUB_ID = EST.EST_SUB_ID
                LEFT JOIN SUBJECTS SUB
                ON EST.SUB_ID = SUB.SUB_ID
                    LEFT JOIN MID_DROP MID
                    ON E.E_ID = MID.E_ID  ;
/*
학생이름                           과정명                            과목명                            교육 기간                   교재명                                  출결점수       실기점수       필기점수         총점         등수 중
------------------------------ ------------------------------ ------------------------------ ----------------------- ------------------------------ ---------- ---------- ---------- ---------- ---------- -
STU2                           COURSE3                                                        -                                                                                               0          1 N
STU1                           COURSE3                                                        -                                                                                               0          1 Y

*/

--* 조회되는 쿼리문만 넣었습니다! 그리고 다른 분들이 작성한 쿼리문 다 있는 게 아녀서 우선 이것들만 테스트했어요.
--------------------------------------------------------------------------------
--! 수정하다가 순서가 엉켜서 그대로 테스트했을 때 제가 달아놓은 주석과 실제 결과가 다르게 나올 수 있어요! 

--○ 과목 + 개설과목 INSERT 
EXEC PRC_SUB_INSERT('COURSE3', '오라클초급', TO_DATE('2022-1-15', 'YYYY-MM-DD'),  TO_DATE('2022-2-15', 'YYYY-MM-DD'), '오라클의 시작', 'PRO2');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.


--성적 먼저 넣어보고 성적비중 안 넣었을 때 총점 어떻게 출력되는지 테스트

--○ 성적 INSERT 
EXEC PRC_SCORE_INSERT('ENROLL2', 'ESUB3', 100, 90, 80 );
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

EXEC PRC_SCORE_INSERT('ENROLL1', 'ESUB1', 94, 82, 64 );
--==>> ORA-20002: 중도포기한 수강신청 내역입니다.

SELECT *
FROM COURSE;
/*
COURSE1	개발자양성과정		2020-11-24	2021-04-18	오라클강의실A1
COURSE2	빅데이터전문가과정		2020-06-14	2020-12-30	자바강의실B1
COURSE3	백엔드개발자양성과정		2021-10-14	2022-03-30	자바강의실C
COURSE4	풀스택개발자양성과정		2021-12-23	2022-06-15	자바강의실D
*/

SELECT *
FROM SUBJECTS;
/*
SUB1	오라클중급	2020-12-24	2021-01-19		오라클의 정석
SUB3	자바고급	2020-06-14	2020-12-30		고급자바마스터
SUB4	스프링5	2021-12-24	2022-01-05		스프링마스터
SUB6	오라클초급	2022-01-15	2022-02-15		오라클의 시작
*/

SELECT *
FROM ENROLL;
/*
ENROLL1	STU1	COURSE3	2021-09-27
ENROLL2	STU2	COURSE3	2021-09-27
*/

SELECT *
FROM ESTABLISHED_SUB;
/*
ESUB1		COURSE1	SUB1			
ESUB2	PRO2	COURSE2	SUB3	20	30	50
ESUB3	PRO2	COURSE3	SUB4	20	30	50
ESUB4	PRO2	COURSE3	SUB6	20	30	50
*/

SELECT *
FROM MID_DROP;
/*
DROP1	ENROLL1	2022-01-01
*/

SELECT *
FROM TEST;

SELECT *
FROM SCORE;
--==>> SCORE5	ENROLL2	ESUB3	100	90	80


    
--학생 관리 기능 구현
-- 관리자는 등록된 모든 학생의 정보를 출력할 수 있어야 한다. (학생 이름, 과정명, 수강과목, 수강과목 총점, 중도 탈락 사실)
SELECT STD.ST_NAME "학생 이름", C.COURSE_ID "과정명", S.SUB_NAME "수강과목", FN_TOTAL_SCORE(SCORE.SCORE_ID, SCORE.EST_SUB_ID) "수강과목 총점", NVL2(MD.E_ID, '중도탈락', '중도탈락아님') "중도 탈락 사실"
FROM STUDENTS STD LEFT JOIN ENROLL E
ON STD.ST_ID = E.ST_ID
    LEFT JOIN COURSE C
    ON E.COURSE_ID = C.COURSE_ID
        LEFT JOIN ESTABLISHED_SUB ES
        ON C.COURSE_ID = ES.COURSE_ID
            LEFT JOIN SUBJECTS S
            ON ES.SUB_ID = S.SUB_ID
                LEFT JOIN MID_DROP MD
                ON E.E_ID = MD.E_ID
                    LEFT JOIN SCORE
                    ON E.E_ID = SCORE.E_ID AND SCORE.EST_SUB_ID = ES.EST_SUB_ID
ORDER BY STD.ST_ID;
--==>> 입력된 비중의 정보가 없거나 입력된 점수 정보가 없으면 0으로 출력. 
/*
정회일	COURSE3	스프링5		중도탈락
김초엽	COURSE3	스프링5	0	중도탈락아님
*/

--○ 성적 비중 INSERT
EXEC PRC_SUB_SCORE_RATIO('ESUB4', 20, 30, 50);
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM ESTABLISHED_SUB;
--==>> 
/*
ESUB1	PRO1	COURSE1	SUB1			
ESUB2	PRO2	COURSE2	SUB3			
ESUB3	PRO2	COURSE3	SUB4			
ESUB4	PRO1	COURSE5	SUB5	20	30	50
*/

EXEC PRC_SUB_SCORE_RATIO('ESUB3', 20, 30, 50);
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM ESTABLISHED_SUB;
--==>>
/*
ESUB1	PRO1	COURSE1	SUB1			
ESUB2	PRO2	COURSE2	SUB3			
ESUB3	PRO2	COURSE3	SUB4			
ESUB4	PRO1	COURSE5	SUB5	20	30	50
ESUB5	PRO2	COURSE3	SUB6	20	30	50
*/

EXEC PRC_SUB_SCORE_RATIO('ESUB2', 20, 30, 50);
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM ESTABLISHED_SUB;
--==>> 
/*
ESUB1	PRO1	COURSE1	SUB1			
ESUB2	PRO2	COURSE2	SUB3			
ESUB3	PRO2	COURSE3	SUB4	20	30	50
ESUB4	PRO1	COURSE5	SUB5	20	30	50
ESUB5	PRO2	COURSE3	SUB6	20	30	50
*/


--○ SQL문 확인
--교수자 계정 관리 기능 구현
-- 모든 교수자의 정보를 출력하여 볼 수 있어야 한다.(교수자명, 배정된 과목명, 과목 기간, 교재 명, 강의실, 강의진행여부)
-- 배정된 과목 없어서 NULL값일 때 처리
SELECT P.PRO_NAME "교수자명", S.SUB_NAME "배정된 과목명", S.S_START || ' ~ ' || S.S_END "과목 기간", S.BOOK_NAME"교재명", CLASSROOM "강의실", FN_STATUS(S.S_START, S.S_END) "강의진행여부"
FROM PROFESSORS P LEFT JOIN ESTABLISHED_SUB ES
ON P.PRO_ID = ES.PRO_ID
    LEFT JOIN SUBJECTS S
    ON ES.SUB_ID = S.SUB_ID;
--==>> 
/*
남궁 성	오라클중급	2020-12-24 ~ 2021-01-19	오라클의 정석		강의 종료
서진수	자바고급	2020-06-14 ~ 2020-12-30	고급자바마스터		강의 종료
서진수	스프링5	    2021-12-24 ~ 2022-01-05	스프링마스터		강의 예정
남궁 성	HTML	    2022-01-15 ~ 2022-03-20	재밌는 HTML		    강의 예정
서진수	오라클초급	2022-01-15 ~ 2022-02-15	오라클의 시작		강의 예정
*/

--학생 관리 기능 구현
-- 관리자는 등록된 모든 학생의 정보를 출력할 수 있어야 한다. (학생 이름, 과정명, 수강과목, 수강과목 총점, 중도 탈락 사실)
SELECT STD.ST_NAME "학생 이름", C.COURSE_ID "과정명", S.SUB_NAME "수강과목", FN_TOTAL_SCORE(SCORE.SCORE_ID, SCORE.EST_SUB_ID) "수강과목 총점", NVL2(MD.E_ID, '중도탈락', '중도탈락아님') "중도 탈락 사실"
FROM STUDENTS STD LEFT JOIN ENROLL E
ON STD.ST_ID = E.ST_ID
    LEFT JOIN COURSE C
    ON E.COURSE_ID = C.COURSE_ID
        LEFT JOIN ESTABLISHED_SUB ES
        ON C.COURSE_ID = ES.COURSE_ID
            LEFT JOIN SUBJECTS S
            ON ES.SUB_ID = S.SUB_ID
                LEFT JOIN MID_DROP MD
                ON E.E_ID = MD.E_ID
                    LEFT JOIN SCORE
                    ON E.E_ID = SCORE.E_ID AND SCORE.EST_SUB_ID = ES.EST_SUB_ID
ORDER BY STD.ST_ID;
--==>> 
/*
정회일	COURSE3	스프링5		    중도탈락
정회일	COURSE3	오라클초급		중도탈락
김초엽	COURSE3	오라클초급		중도탈락아님
김초엽	COURSE3	스프링5	    87	중도탈락아님
*/

--과정 관리 기능 구현
-- 관리자는 등록된 모든 과정의 정보를 출력하여 볼 수 있어야 한다. (과정명, 강의실, 과목명, 과목 기간, 교재명, 교수자명)       
SELECT C.COURSE_NAME "과정명", C.CLASSROOM "강의실", S.SUB_NAME "과목명", S.S_START || ' ~ ' || S.S_END "과목 기간", S.BOOK_NAME "교재명", P.PRO_NAME"교수자명"
FROM COURSE C JOIN ESTABLISHED_SUB ES
ON C.COURSE_ID = ES.COURSE_ID
    JOIN SUBJECTS S
    ON S.SUB_ID = ES.SUB_ID 
        JOIN PROFESSORS P
        ON ES.PRO_ID = P.PRO_ID
ORDER BY C.COURSE_ID;
--==>> 
/*
개발자양성과정	        오라클강의실A1	오라클중급	2020-12-24 ~ 2021-01-19	오라클의 정석	남궁 성
빅데이터전문가과정	    자바강의실B1	자바고급	2020-06-14 ~ 2020-12-30	고급자바마스터	서진수
백엔드개발자양성과정	자바강의실C	    오라클초급	2022-01-15 ~ 2022-02-15	오라클의 시작	서진수
백엔드개발자양성과정	자바강의실C	    스프링5	    2021-12-24 ~ 2022-01-05	스프링마스터	서진수
풀스택개발자양성과정	자바강의실D	    HTML	    2022-01-15 ~ 2022-03-20	재밌는 HTML	    남궁 성
*/



/*
SELECT *
FROM COURSE C, ESTABLISHED_SUB ES, SUBJECTS S
WHERE C.COURSE_ID = ES.COURSE_ID AND S.SUB_ID = ES.SUB_ID;


SELECT *
FROM SCORE;
*/

-- 성적 입력 전용 화면 출력
-- 자신이 강의한 과목을, 중도탈락자를 제외하고 성적 입력
-- 학생 이름은 자동으로 입력되어 있고, 성적(출결, 실기, 필기)만 입력하면 된다.
-- 각 성적의 합(총점)이 자동으로 출력된다.
SELECT C.COURSE_NAME "과목명", S.ST_NAME "학생명"
     , NVL(SCO.ATTEND_SCORE, 0) "출결점수", NVL(SCO.PRACTICAL_SCORE, 0) "실기점수", NVL(SCO.WRITING_SCORE, 0) "필기점수"
     , (NVL(SCO.ATTEND_SCORE, 0) + NVL(SCO.PRACTICAL_SCORE, 0) + NVL(SCO.WRITING_SCORE, 0)) "총점"
FROM PROFESSORS P JOIN COURSE C
    ON P.PRO_ID = C.PRO_ID
                JOIN ENROLL E
                ON C.COURSE_ID = E.COURSE_ID
                    JOIN STUDENTS S
                    ON E.ST_ID = S.ST_ID
                        LEFT JOIN SCORE SCO
                        ON E.E_ID = SCO.E_ID                            
                            LEFT JOIN MID_DROP M
                            ON E.E_ID = M.E_ID
WHERE P.PRO_ID = 'PRO1'     -- 접속 중인 교수의 ID 입력
  AND M.DROP_ID IS NULL;    -- 중도탈락자가 아닐 경우


