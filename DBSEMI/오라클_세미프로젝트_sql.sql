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
        ON C.PRO_ID = P.PRO_ID;


--학생 관리 기능 구현
-- 관리자는 등록된 모든 학생의 정보를 출력할 수 있어야 한다. (학생 이름, 과정명, 수강과목, 수강과목 총점, 중도 탈락 사실)
SELECT STD.ST_NAME "학생 이름", C.COURSE_ID "과정명", S.SUB_NAME "수강과목", FN_TOTAL_SCORE(STD.ST_ID, ES.SUB_ID) "수강과목 총점", NVL2(MD.E_ID, '중도탈락', '중도탈락아님') "중도 탈락 사실"
FROM STUDENTS STD LEFT JOIN ENROLL E
ON STD.ST_ID = E.ST_ID
    LEFT JOIN COURSE C
    ON E.COURSE_ID = C.COURSE_ID
        LEFT JOIN ESTABLISHED_SUB ES
        ON C.COURSE_ID = ES.COURSE_ID
            LEFT JOIN SUBJECTS S
            ON ES.SUB_ID = S.SUB_ID
                LEFT JOIN MID_DROP MD
                ON E.E_ID = MD.E_ID;


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

--○ 교수정보 삭제 트리거 확인
SELECT *
FROM PROFESSORS
WHERE PRO_ID = 'PRO2';
--==>> PRO1	남궁 성	2813239	840218-2813239

DELETE
FROM PROFESSORS
WHERE PRO_ID = 'PRO2';
--==>> 에러 발생
/*
오류 보고 -
ORA-04091: table HR.PROFESSORS is mutating, trigger/function may not see it
ORA-06512: at "HR.TRG_PROFESSORS_DELETE", line 10
ORA-04088: error during execution of trigger 'HR.TRG_PROFESSORS_DELETE
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
EXEC PRC_ENROLL_INSERT('ENROLL1', 'STU1', 'COURSE3', TO_DATE('2021-9-26', 'YYYY-MM-DD'));
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

EXEC PRC_ENROLL_INSERT('ENROLL2', 'STU2', 'COURSE3', TO_DATE('2021-9-26', 'YYYY-MM-DD'));
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM ENROLL;
--==>> 
/*
ENROLL1	STU1	COURSE3	2021-09-26
ENROLL2	STU2	COURSE3	2021-09-26
*/

--예외처리 테스트 2 - 동일한 과정 신청 여부- 한 학생이 같은 과정을 신청할 수 없다.
EXEC PRC_ENROLL_INSERT('ENROLL3', 'STU1', 'COURSE3', TO_DATE('2021-9-26', 'YYYY-MM-DD'));
--==>> 이미 신청한 과목입니다.

--예외처리 테스트 3 - 수강 날짜 중복 - 한 학생이 기존에 수강한 과정의 날짜가, 새로 수강하려는 과정의 날짜와 겹칠 수 없다.
EXEC PRC_ENROLL_INSERT('ENROLL3', 'STU1', 'COURSE5', TO_DATE('2021-9-26', 'YYYY-MM-DD'));
--==>> 날짜가 중복되는 과목입니다.


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

SELECT *
FROM MID_DROP;
--==>> DROP1	ENROLL1	2022-01-01


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
SELECT STD.ST_NAME "학생 이름", C.COURSE_ID "과정명", S.SUB_NAME "수강과목", FN_TOTAL_SCORE(STD.ST_ID, ES.SUB_ID) "수강과목 총점", NVL2(MD.E_ID, '중도탈락', '중도탈락아님') "중도 탈락 사실"
FROM STUDENTS STD LEFT JOIN ENROLL E
ON STD.ST_ID = E.ST_ID
    LEFT JOIN COURSE C
    ON E.COURSE_ID = C.COURSE_ID
        LEFT JOIN ESTABLISHED_SUB ES
        ON C.COURSE_ID = ES.COURSE_ID
            LEFT JOIN SUBJECTS S
            ON ES.SUB_ID = S.SUB_ID
                LEFT JOIN MID_DROP MD
                ON E.E_ID = MD.E_ID;
--==>> 
/*
정회일	COURSE3	스프링5		중도탈락
김초엽	COURSE3	스프링5		중도탈락아님
*/

--지윤 + 승균
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
                    ON E.E_ID = MID.E_ID  ;
/*
학생이름                           과정명                            과목명                            교육 기간                   교재명                                  출결점수       실기점수       필기점수         총점         등수 중
------------------------------ ------------------------------ ------------------------------ ----------------------- ------------------------------ ---------- ---------- ---------- ---------- ---------- -
STU2                           COURSE3                                                        -                                                                                               0          1 N
STU1                           COURSE3                                                        -                                                                                               0          1 Y

*/

--* 조회되는 쿼리문만 넣었습니다! 그리고 다른 분들이 작성한 쿼리문 다 있는 게 아녀서 우선 이것들만 테스트했어요.
--------------------------------------------------------------------------------

--성적 먼저 넣어보고 성적비중 안 넣었을 때 총점 어떻게 출력되는지 테스트

--○ 성적 INSERT 
EXEC PRC_SCORE_INSERT('ENROLL2', 'SUB4', 100, 90, 80 );

SELECT *
FROM ESTABLISHED_SUB;

SELECT *
FROM ENROLL JOIN STUDENTS
ON ENROLL.ST_ID = STUDENTS.ST_ID
JOIN COURSE
ON COURSE.COURSE_ID = ENROLL.COURSE_ID
JOIN ESTABLISHED_SUB ES
ON ES.COURSE_ID = COURSE.COURSE_ID;
--==>> 
/*
ENROLL1	STU1	COURSE3	2021-09-26	STU1	3111111	정회일	111111-3111111	2021-09-25
ENROLL2	STU2	COURSE3	2021-09-26	STU2	4111111	김초엽	111111-4111111	2021-09-25
*/

SELECT *
FROM MID_DROP;

SELECT *
FROM SUBJECTS;


--○ 성적 비중 INSERT

--○ 성적 INSERT 

--○ 