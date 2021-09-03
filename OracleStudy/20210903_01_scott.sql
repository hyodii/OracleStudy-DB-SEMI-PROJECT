SELECT USER
FROM DUAL;
--==>> SCOTT

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

--○ 문제
--   TBL_SAWON 테이블을 활용하여 다음과 같은 항목들을 조회한다.
--   사원번호, 사원명, 주민번호, 성별, 현재나이, 입사일
--  , 정년퇴직일, 근무일수, 남은일수, 급여, 보너스

--  단, 현재나이는 한국나이 계산법에 따라 연산을 수행한다.
--  또한, 정년퇴직일은 해당 직원의 나이가 한국나이로 60세가 되는 해(연도)의
--  그 직원의 입사 월, 일로 연산을 수행한다.
--  그리고, 보너스는 1000일 이상 2000일 미만 근무한 사원은
--  그 사원의 원래 급여 기준 30% 지급,
--  2000일 이상 근무한 사원은
--  그 사원의 원래 급여 기준 50% 지급을 할 수 있도록 처리한다.
SELECT *
FROM TBL_SAWON;

--내가 푼 풀이
SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
     , CASE SUBSTR(JUBUN,7,1) WHEN '2' THEN '여'
                              WHEN '4' THEN '여'
            ELSE '남' 
            END "성별"
     , EXTRACT(YEAR FROM SYSDATE) - (DECODE(SUBSTR(JUBUN,7,1),'1','19','2','19','20') || SUBSTR(JUBUN,1,2)) + 1 "현재나이"
     , HIREDATE "입사일"
     , TO_CHAR(ADD_MONTHS(SYSDATE,(60 - (EXTRACT(YEAR FROM SYSDATE) - (DECODE(SUBSTR(JUBUN,7,1),'1','19','2','19','20') || SUBSTR(JUBUN,1,2)) + 1))*12),'YYYY')
     ||'-' || TO_CHAR(HIREDATE,'MM-DD') "정년퇴직일"
     , TRUNC(SYSDATE - HIREDATE) "근무일수"
     , TRUNC(TO_DATE(TO_CHAR(ADD_MONTHS(SYSDATE,(60 - (EXTRACT(YEAR FROM SYSDATE) - (DECODE(SUBSTR(JUBUN,7,1),'1','19','2','19','20') 
     || SUBSTR(JUBUN,1,2)) + 1))*12),'YYYY')||'-'||TO_CHAR(HIREDATE,'MM-DD'),'YYYY-MM-DD') - SYSDATE) "남은일수"
     ,SAL "급여"
     , CASE WHEN TRUNC(SYSDATE - HIREDATE) >=2000 THEN SAL * 0.5 
            WHEN TRUNC(SYSDATE - HIREDATE) >=1000 THEN SAL * 0.3
            ELSE 0
            END "보너스"
FROM TBL_SAWON;
--==>>
/*
1001	김소연	    9307302234567	여자	29	2001-01-03	2052-01-03	7548	11078	3000	900
1002	이다영	    9510272234567	여자	27	2010-11-05	2054-11-05	3955	12115	2000	0
1003	이지영	    0909014234567	여자	13	2012-08-16	2068-08-16	3305	17148	1000	0
1004	손다정	    9406032234567	여자	28	1999-02-02	2053-02-02	8249	11474	4000	2000
1005	이하이	    0406034234567	여자	18	2013-07-15	2063-07-15	2972	15289	1000	0
1006	이이경	    0202023234567	남자	20	2011-08-17	2061-08-17	3670	14592	2000	0
1007	김이나	    8012122234567	여자	42	1999-11-11	2039-11-11	7967	6642	3000	900
1008	아이유	    8105042234567	여자	41	1999-11-11	2040-11-11	7967	7008	3000	900
1009	선동열	    7209301234567	남자	50	1995-11-11	2031-11-11	9428	3720	3000	1500
1010	선우용녀	7001022234567	여자	52	1995-10-10	2029-10-10	9460	2958	3000	1500
1011	선우선	    9001022234567	여자	32	2001-10-10	2049-10-10	7268	10263	2000	600
1012	남진	    8009011234567	남자	42	1998-02-13	2039-02-13	8603	6371	4000	2000
1013	남궁현	    8203051234567	남자	40	2002-02-13	2041-02-13	7142	7102	3000	900
1014	남도일	    9208091234567	남자	30	2002-02-13	2051-02-13	7142	10754	3000	900
1015	김남길	    0202023234567	남자	20	2015-01-10	2061-01-10	2428	14373	2000	0
*/

--성별
SELECT CASE SUBSTR(JUBUN,7,1) WHEN '2' THEN '여'
                              WHEN '4' THEN '여'
            ELSE '남' 
            END "성별"
FROM TBL_SAWON;

--나이
SELECT TO_CHAR(SUBSTR(JUBUN,1,6),'YY-MM-DD')
FROM TBL_SAWON;
--==>> 오류

-- 흠....아닌거같고..
SELECT (TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE('1994-12-31','YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24))/365 + 1 "일"
FROM DUAL;

--==>> 27.69315068493150684931506849315068493151

--흠.....모르겟..
SELECT TO_DATE(SUBSTR(JUBUN,1,6),'YYMMDD')
FROM TBL_SAWON;
--==>> 2093-07-30


SELECT EXTRACT(YEAR FROM SYSDATE)
FROM TBL_SAWON;
--==>> 2021

SELECT DECODE(SUBSTR(JUBUN,7,1),'1','19','2','19','20') || SUBSTR(JUBUN,1,2)
FROM TBL_SAWON;
--==>>
/*
1993
1995
2009
1994
  :
  :
*/

-- 나이 구하기 완성
SELECT EXTRACT(YEAR FROM SYSDATE) - (DECODE(SUBSTR(JUBUN,7,1),'1','19','2','19','20') || SUBSTR(JUBUN,1,2)) + 1
FROM TBL_SAWON;
/*
29
27
13
28
 :
 :
*/
--○ DECODE()
-- DECODE(컬럼, 조건1, 결과1, 조건2, 결과2, 조건3, 결과3..........) 
SELECT DECODE(5-2,1,'5-2=1',2, '5-2=2',3,'5-2=3','5-2는 몰라요')"결과 확인"
FROM DUAL;
--==>> 5-2=3

--○ EXTRACT()
-- SYSDATE자리에는 날짜타입이기만 하면됨!
SELECT TO_CHAR(SYSDATE,'YYYY') "1"      --2021      → 연도를 추출하여 문자 타입으로...
     , TO_CHAR(SYSDATE, 'MM') "2"       --09        → 월을 추출하여 문자 타입으로... 
     , TO_CHAR(SYSDATE, 'D') "3"        --5         → 일을 추출하여 문자 타입으로...
     , EXTRACT(YEAR FROM SYSDATE) "4"   --2021      → 연도를 추출하여 숫자 타입으로...
     , EXTRACT(MONTH FROM SYSDATE) "5"  --9	        → 월을 추출하여 숫자 타입으로...
     , EXTRACT(DAY FROM SYSDATE) "6"    --2         → 일을 추출하여 숫자 타입으로...
FROM DUAL;
--> 연, 월, 일 이하 다른 것은 불가(시, 분, 초)

-- 근무일수 완성
SELECT TRUNC(SYSDATE - HIREDATE) "근무일수 완성1"
     , TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) "근무일수 완성2"
FROM TBL_SAWON;

--정년퇴직일 구하자
--  또한, 정년퇴직일은 해당 직원의 나이가 한국나이로 60세가 되는 해(연도)의
--  그 직원의 입사 월, 일로 연산을 수행한다.
SELECT 60 - 직원의 나이
FROM TBL_SAWON;

SELECT 60-(EXTRACT(YEAR FROM SYSDATE) - (DECODE(SUBSTR(JUBUN,7,1),'1','19','2','19','20') || SUBSTR(JUBUN,1,2)) + 1)
FROM TBL_SAWON;

--정년퇴직일 완성
--??정년퇴직일에서 월 일을 처리 못함 -> OK
SELECT HIREDATE 
     , TO_CHAR(ADD_MONTHS(SYSDATE,(60 - (EXTRACT(YEAR FROM SYSDATE) - (DECODE(SUBSTR(JUBUN,7,1),'1','19','2','19','20') || SUBSTR(JUBUN,1,2)) + 1))*12),'YYYY')
     ||'-' || TO_CHAR(HIREDATE,'MM-DD')
FROM TBL_SAWON;

--퇴직까지 남은 일수 완성--틀림
SELECT ADD_MONTHS(SYSDATE,(60 - (EXTRACT(YEAR FROM SYSDATE) - (DECODE(SUBSTR(JUBUN,7,1),'1','19','2','19','20') || SUBSTR(JUBUN,1,2)) + 1))*12) - SYSDATE
FROM TBL_SAWON;

--퇴직까지 남은 일수 ((받은 것)))
SELECT HIREDATE
     , JUBUN
     , CASE WHEN SUBSTR(JUBUN,7,1)=1 OR SUBSTR(JUBUN,7,1)=2 
        THEN TRUNC(TO_DATE((TO_CHAR(TO_CHAR(SYSDATE,'YYYY')+ 60 -(TO_CHAR(SYSDATE, 'YYYY')-(1900+SUBSTR(JUBUN,1,2)) + 1))||'-'||SUBSTR(HIREDATE,6,2)||'-'||SUBSTR(HIREDATE,9,2)),'YYYY-MM-DD')- SYSDATE)
        ELSE TRUNC(TO_DATE((TO_CHAR(TO_CHAR(SYSDATE,'YYYY') + 60-(TO_CHAR(SYSDATE, 'YYYY')- (2000+SUBSTR(JUBUN,1,2)) + 1))||'-'||SUBSTR(HIREDATE,6,2)||'-'||SUBSTR(HIREDATE,9,2)),'YYYY-MM-DD')- SYSDATE)
       END "남은일수" --
FROM TBL_SAWON;
--==>>
/*
2021-09-03	9307302234567	11322
2010-11-05	9510272234567	12115
2012-08-16	0909014234567	17148
1999-02-02	9406032234567	11474
2013-07-15	0406034234567	15289
2011-08-17	0202023234567	14592
1999-11-11	8012122234567	6642
1999-11-11	8105042234567	7008
1995-11-11	7209301234567	3720
1995-10-10	7001022234567	2958
2001-10-10	9001022234567	10263
1998-02-13	8009011234567	6371
2002-02-13	8203051234567	7102
2002-02-13	9208091234567	10754
2015-01-10	0202023234567	14373
*/


--  그리고, 보너스는 1000일 이상 2000일 미만 근무한 사원은
--  그 사원의 원래 급여 기준 30% 지급,
--  2000일 이상 근무한 사원은
--  그 사원의 원래 급여 기준 50% 지급을 할 수 있도록 처리한다.

-- 보너스 완성1
SELECT TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) "근무일수"
       , SAL
       , CASE WHEN TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) >=2000 THEN SAL * 0.5 
              WHEN TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) >=1000 THEN SAL * 0.3 
              WHEN TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) <2000 THEN SAL * 0.3 
              ELSE SAL * 0
              END "보너스"
FROM TBL_SAWON;

--보너스 완성2
SELECT TRUNC(SYSDATE - HIREDATE) "근무일수"
     , SAL "급여"
     , CASE WHEN TRUNC(SYSDATE - HIREDATE) >=2000 THEN SAL * 0.5 
            WHEN TRUNC(SYSDATE - HIREDATE) >=1000 THEN SAL * 0.3
            ELSE 0
            END "보너스"
FROM TBL_SAWON;

--왜안대징..?
SELECT DECODE(TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24)
            ,(TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24 )>= 1000 AND TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) < 2000)
            ,SAL*0.3,SAL*0.5)
FROM TBL_SAWON;


------함께 푼 풀이----------------------------------------------------------

-- TBL_SAWON 테이블에 존재하는 사원들의 
-- 입사일(HIREDATE) 컬럼에서 월, 일만 조회하기
SELECT SANAME, HIREDATE, TO_CHAR(HIREDATE,'MM-DD') "월일"
FROM TBL_SAWON;
--==>>
/*
김소연	    2001-01-03	01-03
이다영	    2010-11-05	11-05
이지영	    2012-08-16	08-16
손다정	    1999-02-02	02-02
이하이	    2013-07-15	07-15
이이경	    2011-08-17	08-17
김이나	    1999-11-11	11-11
아이유	    1999-11-11	11-11
선동열	    1995-11-11	11-11
선우용녀	1995-10-10	10-10
선우선	    2001-10-10	10-10
남진	    1998-02-13	02-13
남궁현	    2002-02-13	02-13
남도일	    2002-02-13	02-13
김남길	    2015-01-10	01-10
*/

SELECT SANAME, HIREDATE, TO_CHAR(HIREDATE,'MM') "월", TO_CHAR(HIREDATE,'DD') "일"
FROM TBL_SAWON;
--==>>
/*
김소연	    2001-01-03	01	03
이다영	    2010-11-05	11	05
이지영	    2012-08-16	08	16
손다정	    1999-02-02	02	02
이하이	    2013-07-15	07	15
이이경	    2011-08-17	08	17
김이나	    1999-11-11	11	11
아이유	    1999-11-11	11	11
선동열	    1995-11-11	11	11
선우용녀	1995-10-10	10	10
선우선	    2001-10-10	10	10
남진	    1998-02-13	02	13
남궁현	    2002-02-13	02	13
남도일	    2002-02-13	02	13
김남길	    2015-01-10	01	10
*/

SELECT SANAME, HIREDATE, TO_CHAR(HIREDATE,'MM') ||'-'|| TO_CHAR(HIREDATE,'DD') "월일"
FROM TBL_SAWON;
--==>>
/*
김소연	    2001-01-03	01-03
이다영	    2010-11-05	11-05
이지영	    2012-08-16	08-16
손다정	    1999-02-02	02-02
이하이	    2013-07-15	07-15
이이경	    2011-08-17	08-17
김이나	    1999-11-11	11-11
아이유	    1999-11-11	11-11
선동열	    1995-11-11	11-11
선우용녀	1995-10-10	10-10
선우선	    2001-10-10	10-10
남진	    1998-02-13	02-13
남궁현	    2002-02-13	02-13
남도일	    2002-02-13	02-13
김남길	    2015-01-10	01-10
*/

--○ 문제 변경
--   TBL_SAWON 테이블을 활용하여 다음과 같은 항목들을 조회한다.
--   사원번호, 사원명, 주민번호, 성별, 현재나이, 입사일
--  , 정년퇴직일, 근무일수, 남은일수, 급여, 보너스

--  단, 현재나이는 한국나이 계산법에 따라 연산을 수행한다.
--  또한, 정년퇴직일은 해당 직원의 나이가 한국나이로 60세가 되는 해(연도)의
--  그 직원의 입사 월, 일로 연산을 수행한다.
--  그리고, 보너스는 4000일 이상 8000일 미만 근무한 사원은
--  그 사원의 원래 급여 기준 30% 지급,
--  8000일 이상 근무한 사원은
--  그 사원의 원래 급여 기준 50% 지급을 할 수 있도록 처리한다.

-- 사원번호, 사원명, 주민번호, 성별, 현재나이, 입사일, 급여
SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
     , CASE WHEN 주민번호 7번째자리 1개가 '1' 또는 '3' THEN '남자'
            WHEN 주민번호 7번째자리 1기가 '2' 또는 '4' THEN '여자'
            ELSE '성별확인불가' 
       END"성별"
FROM TBL_SAWON;
------------------------------------------------------------------------
SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
     , CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','3') THEN '남자'
            WHEN SUBSTR(JUBUN,7,1) IN ('2','4') THEN '여자'
            ELSE '성별확인불가' 
       END"성별"
FROM TBL_SAWON;
--==>>
/*
1001	김소연	    9307302234567	여자
1002	이다영	    9510272234567	여자
1003	이지영	    0909014234567	여자
1004	손다정	    9406032234567	여자
1005	이하이	    0406034234567	여자
1006	이이경	    0202023234567	남자
1007	김이나	    8012122234567	여자
1008	아이유	    8105042234567	여자
1009	선동열	    7209301234567	남자
1010	선우용녀	7001022234567	여자
1011	선우선	    9001022234567	여자
1012	남진	    8009011234567	남자
1013	남궁현	    8203051234567	남자
1014	남도일	    9208091234567	남자
1015	김남길	    0202023234567	남자
*/


SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
     , CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','3') THEN '남자'
            WHEN SUBSTR(JUBUN,7,1) IN ('2','4') THEN '여자'
            ELSE '성별확인불가' 
       END"성별"
    -- 현재나이 = 현재년도 - 태어난년도 + 1 (1900년대 생 / 2000년대 생)
    , CASE WHEN 1900년대 생이라면.. 
           THEN 현재년도 - (주민번호 앞 두자리 + 1899) 
           WHEN 2000년대 생이라면...
           THEN 현재년도 - (주민번호 앞 두자리 + 1999)
           ELSE -1
      END "현재나이" 
FROM TBL_SAWON;
-----------------------------------------------------------------------------
SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
     , CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','3') THEN '남자'
            WHEN SUBSTR(JUBUN,7,1) IN ('2','4') THEN '여자'
            ELSE '성별확인불가' 
       END"성별"
    -- 현재나이 = 현재년도 - 태어난년도 + 1 (1900년대 생 / 2000년대 생)
    , CASE WHEN 주민번호 7번째자리 1개가 '1' 또는 '2'
           THEN 현재년도 - (주민번호 앞 두자리 + 1899) 
           WHEN 주민번호 7번째자리 1개가 '3' 또는 '4'
           THEN 현재년도 - (주민번호 앞 두자리 + 1999)
           ELSE -1
      END "현재나이" 
FROM TBL_SAWON;
-----------------------------------------------------------------------------
SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
     , CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','3') THEN '남자'
            WHEN SUBSTR(JUBUN,7,1) IN ('2','4') THEN '여자'
            ELSE '성별확인불가' 
       END"성별"
    -- 현재나이 = 현재년도 - 태어난년도 + 1 (1900년대 생 / 2000년대 생)
    , CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','2')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899) 
           --                                           -----------------
           --                                   문자열이기 때문에 +못함
           WHEN SUBSTR(JUBUN,7,1) IN ('3','4')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999)
           ELSE -1
      END "현재나이"
    , HIREDATE "입사일"
    , SAL "급여"
FROM TBL_SAWON;
--==>>
/*
1001	김소연	    9307302234567	여자	29	2001-01-03	3000
1002	이다영	    9510272234567	여자	27	2010-11-05	2000
1003	이지영	    0909014234567	여자	13	2012-08-16	1000
1004	손다정	    9406032234567	여자	28	1999-02-02	4000
1005	이하이	    0406034234567	여자	18	2013-07-15	1000
1006	이이경	    0202023234567	남자	20	2011-08-17	2000
1007	김이나	    8012122234567	여자	42	1999-11-11	3000
1008	아이유	    8105042234567	여자	41	1999-11-11	3000
1009	선동열	    7209301234567	남자	50	1995-11-11	3000
1010	선우용녀	7001022234567	여자	52	1995-10-10	3000
1011	선우선	    9001022234567	여자	32	2001-10-10	2000
1012	남진	    8009011234567	남자	42	1998-02-13	4000
1013	남궁현	    8203051234567	남자	40	2002-02-13	3000
1014	남도일	    9208091234567	남자	30	2002-02-13	3000
1015	김남길	    0202023234567	남자	20	2015-01-10	2000
*/
-----------------------------------------------------------------
--서브쿼리
--; 위치 주의
SELECT T.사원번호, T.연봉
FROM
(
SELECT SANO "사원번호", SANAME "사원명", SAL "급여", SAL*12 "연봉"
FROM TBL_SAWON
)T;


--원래 이렇게 조회된는것
SELECT TBL_SAWON.SANO
FROM TBL_SAWON;

SELECT T.SANO
FROM TBL_SAWON T;


SELECT A.SANO
FROM
(
SELECT SANO "사원번호", SANAME "사원명", SAL "급여"
FROM TBL_SAWON
) A;
--==>> 에러 발생
-- 사원번호라는 컬럼은 존재하지만 SANO라는 컬럼은 없음!

SELECT A.사원번호, A.사원명
FROM
(
SELECT SANO "사원번호", SANAME "사원명", SAL "급여"
FROM TBL_SAWON
) A;


SELECT A.사원번호, A.사원명,A.연봉, A.연봉*2 "두배연봉"
FROM
(                                                                       --            
SELECT SANO "사원번호", SANAME "사원명", SAL "급여", SAL*12 "연봉"  --    |    → 이만큼 인라인뷰라고 함!
FROM TBL_SAWON                                                      --     |
) A;                                                                     --    


-- 인라인뷰안에서는 연봉*2 "두배연봉" 이걸 할수없는데 (파싱순서때문에)
-- 서브쿼리에서는 가넝한~!!

--숫자는 우측정렬 문자는 좌측정렬
DESC TBL_SAWON;
-------------------------------------------------------------------------------
-- 다시 이걸이용해서 하자
-- 아까만든거 서브쿼리로


--   사원번호, 사원명, 주민번호, 성별, 현재나이, 입사일
--  , 정년퇴직일, 근무일수, 남은일수, 급여, 보너스

SELECT T.사원번호,T.사원명, T.주민번호, T.성별, T.현재나이, T.입사일
    -- 정년퇴직일
    -- 정년퇴직년도 → 해당 직원의 나이가 한국나이로 60세가 되는 해
    -- 현재 나이가... 58세...2년 후     2021 → 2023
    -- 현재 나이가... 35세...25년 후     2021 → 2046
    -- ADD_MONTHS(SYSDATE, 남은년수 * 12)
    --                      -------
    --                      (60 - 현재나이)
    -- ADD_MONTHS(SYSDATE, (60 - 현재나이) *12) → 이 결과에서 정년퇴직 년도만 필요
    -- TO_CHAR(ADD_MONTHS(SYSDATE, (60 - 현재나이) *12),'YYYY') → 정년퇴직 년도만 추출
    -- TO_CHAR(ADD_MONTHS(SYSDATE, (60 - 현재나이) *12),'YYYY') || '-' || TO_CHAR(HIREDATE,''MM-DD')
    
     , TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이) *12),'YYYY') || '-' || TO_CHAR(T.입사일,'MM-DD') "정년퇴직일"
     
    -- 근무일수 = 현재날짜 - 입사일  → 하루를 다 채우지 못한건 버려야함!   --> 서브쿼리에 넣는게 더 편함!
     , TRUNC(SYSDATE - T.입사일) "근무일수"
     
    -- 남은일수 = 현재일 - 입사일
     , TRUNC(TO_DATE(TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이) *12),'YYYY') 
       || '-' || TO_CHAR(T.입사일,'MM-DD'),'YYYY-MM-DD') - SYSDATE) "남은일수"
       
    -- 급여
     , T.급여
     
    -- 보너스
    -- 근무일수가 4000일 이상 8000일 미만 → 원래 급여의 30%
    -- 근무일수가 8000일 이상 → 원래 급여의 50%
    -- 나머지는 0
     , CASE WHEN TRUNC(SYSDATE - T.입사일) >= 8000 THEN T.급여 * 0.5
            WHEN TRUNC(SYSDATE - T.입사일) >= 4000 THEN T.급여 * 0.3
            ELSE 0
       END "보너스"
FROM
(
-- 사원번호, 사원명, 주민번호, 성별, 현재나이, 입사일, 급여
    SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
         , CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','3') THEN '남자'
                WHEN SUBSTR(JUBUN,7,1) IN ('2','4') THEN '여자'
                ELSE '성별확인불가' 
           END"성별"
        -- 현재나이 = 현재년도 - 태어난년도 + 1 (1900년대 생 / 2000년대 생)
        , CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','2')
               THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899) 
               --                                           -----------------
               --                                   문자열이기 때문에 +못함
               WHEN SUBSTR(JUBUN,7,1) IN ('3','4')
               THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999)
               ELSE -1
          END "현재나이"
        , HIREDATE "입사일"
        , SAL "급여"
    FROM TBL_SAWON
) T;

--------------------------------------------------------------------------------
-- 주석처리뺀 쿼리문

--   사원번호, 사원명, 주민번호, 성별, 현재나이, 입사일
--  , 정년퇴직일, 근무일수, 남은일수, 급여, 보너스
SELECT T.사원번호,T.사원명, T.주민번호, T.성별, T.현재나이, T.입사일
     , TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이) *12),'YYYY') || '-' || TO_CHAR(T.입사일,'MM-DD') "정년퇴직일"
     , TRUNC(SYSDATE - T.입사일) "근무일수"
     , TRUNC(TO_DATE(TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이) *12),'YYYY') 
       || '-' || TO_CHAR(T.입사일,'MM-DD'),'YYYY-MM-DD') - SYSDATE) "남은일수"
     , T.급여
     , CASE WHEN TRUNC(SYSDATE - T.입사일) >= 8000 THEN T.급여 * 0.5
            WHEN TRUNC(SYSDATE - T.입사일) >= 4000 THEN T.급여 * 0.3
            ELSE 0
       END "보너스"
FROM
(
    SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
         , CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','3') THEN '남자'
                WHEN SUBSTR(JUBUN,7,1) IN ('2','4') THEN '여자'
                ELSE '성별확인불가' 
           END"성별"
        , CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','2')
               THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899) 
               WHEN SUBSTR(JUBUN,7,1) IN ('3','4')
               THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999)
               ELSE -1
          END "현재나이"
        , HIREDATE "입사일"
        , SAL "급여"
    FROM TBL_SAWON
) T;
--------------------------------------------------------------------------------
-- 1. 번거로움 줄이기위해
-- 2. 보안성을 위해

--※ 상기 내용에서... 특정 근무일수의 사원을 확인해야 한다거나...
--   특정 보너스 금액을 받는 사원을 확인해야 할 경우가 생길 수 있다.
--   이와 같은 경우... 해당 쿼리문을 다시 구성하는 번거로움을 줄일 수 있도록
--   뷰(VIEW)를 만들어 저장해 둘 수 있다.

CREATE OR REPLACE VIEW VIEW_SAWON
AS
SELECT T.사원번호,T.사원명, T.주민번호, T.성별, T.현재나이, T.입사일
     , TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이) *12),'YYYY') || '-' || TO_CHAR(T.입사일,'MM-DD') "정년퇴직일"
     , TRUNC(SYSDATE - T.입사일) "근무일수"
     , TRUNC(TO_DATE(TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이) *12),'YYYY') 
       || '-' || TO_CHAR(T.입사일,'MM-DD'),'YYYY-MM-DD') - SYSDATE) "남은일수"
     , T.급여
     , CASE WHEN TRUNC(SYSDATE - T.입사일) >= 8000 THEN T.급여 * 0.5
            WHEN TRUNC(SYSDATE - T.입사일) >= 4000 THEN T.급여 * 0.3
            ELSE 0
       END "보너스"
FROM
(
    SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
         , CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','3') THEN '남자'
                WHEN SUBSTR(JUBUN,7,1) IN ('2','4') THEN '여자'
                ELSE '성별확인불가' 
           END"성별"
        , CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','2')
               THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899) 
               WHEN SUBSTR(JUBUN,7,1) IN ('3','4')
               THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999)
               ELSE -1
          END "현재나이"
        , HIREDATE "입사일"
        , SAL "급여"
    FROM TBL_SAWON
) T;
--==>> 에러 발생
/*
ORA-01031: insufficient privileges
01031. 00000 -  "insufficient privileges"
*Cause:    An attempt was made to perform a database operation without
           the necessary privileges.
*Action:   Ask your database administrator or designated security
           administrator to grant you the necessary privileges
*/
--> 권한이 불충분하여 발생하는 에러
-- SYS한테서 권한받아오자(20210903_02_sys.sql)

--※ SYS 로부터 VIEW를 생성할 수 있는 권한을 부여받은 후
--   다시 뷰(VIEW) 생성
CREATE OR REPLACE VIEW VIEW_SAWON
AS
SELECT T.사원번호,T.사원명, T.주민번호, T.성별, T.현재나이, T.입사일
     , TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이) *12),'YYYY') || '-' || TO_CHAR(T.입사일,'MM-DD') "정년퇴직일"
     , TRUNC(SYSDATE - T.입사일) "근무일수"
     , TRUNC(TO_DATE(TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이) *12),'YYYY') 
       || '-' || TO_CHAR(T.입사일,'MM-DD'),'YYYY-MM-DD') - SYSDATE) "남은일수"
     , T.급여
     , CASE WHEN TRUNC(SYSDATE - T.입사일) >= 8000 THEN T.급여 * 0.5
            WHEN TRUNC(SYSDATE - T.입사일) >= 4000 THEN T.급여 * 0.3
            ELSE 0
       END "보너스"
FROM
(
    SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
         , CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','3') THEN '남자'
                WHEN SUBSTR(JUBUN,7,1) IN ('2','4') THEN '여자'
                ELSE '성별확인불가' 
           END"성별"
        , CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','2')
               THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899) 
               WHEN SUBSTR(JUBUN,7,1) IN ('3','4')
               THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999)
               ELSE -1
          END "현재나이"
        , HIREDATE "입사일"
        , SAL "급여"
    FROM TBL_SAWON
) T;
--==>> View VIEW_SAWON이(가) 생성되었습니다.

SELECT *
FROM VIEW_SAWON;

COMMIT;


ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

SELECT *
FROM VIEW_SAWON;
--==>>
/*
1001	김소연	    9307302234567	여자	29	2001-01-03	2052-01-03	7548	11078	3000	900
1002	이다영	    9510272234567	여자	27	2010-11-05	2054-11-05	3955	12115	2000	0
1003	이지영	    0909014234567	여자	13	2012-08-16	2068-08-16	3305	17148	1000	0
1004	손다정	    9406032234567	여자	28	1999-02-02	2053-02-02	8249	11474	4000	2000
1005	이하이	    0406034234567	여자	18	2013-07-15	2063-07-15	2972	15289	1000	0
1006	이이경	    0202023234567	남자	20	2011-08-17	2061-08-17	3670	14592	2000	0
1007	김이나	    8012122234567	여자	42	1999-11-11	2039-11-11	7967	6642	3000	900
1008	아이유	    8105042234567	여자	41	1999-11-11	2040-11-11	7967	7008	3000	900
1009	선동열	    7209301234567	남자	50	1995-11-11	2031-11-11	9428	3720	3000	1500
1010	선우용녀	7001022234567	여자	52	1995-10-10	2029-10-10	9460	2958	3000	1500
1011	선우선	    9001022234567	여자	32	2001-10-10	2049-10-10	7268	10263	2000	600
1012	남진	    8009011234567	남자	42	1998-02-13	2039-02-13	8603	6371	4000	2000
1013	남궁현	    8203051234567	남자	40	2002-02-13	2041-02-13	7142	7102	3000	900
1014	남도일	    9208091234567	남자	30	2002-02-13	2051-02-13	7142	10754	3000	900
1015	김남길	    0202023234567	남자	20	2015-01-10	2061-01-10	2428	14373	2000	0
*/

--> 뷰를 쓰는 이유는 보안성과 편의성

--○ TBL_SAWON 테이블의 김소연 사원의 입사일 및 급여 데이터 변경(뷰 생성 후에 변경)
--   현재 TABLE 상태 : 1001	김소연	9307302234567	2001-01-03	3000
--   현재 VIEW 상태  : 1001	김소연	9307302234567	여자	29	2001-01-03	2052-01-03	7548	11078	3000	900

SELECT *
FROM TBL_SAWON;

UPDATE TBL_SAWON
SET HIREDATE = SYSDATE, SAL = 5000
WHERE SANO = 1001;
--==>> 1 행 이(가) 업데이트되었습니다.

SELECT *
FROM TBL_SAWON
WHERE SANO = 1001;
--==>> 1001	김소연	9307302234567	2021-09-03	5000

COMMIT;
--==>> 커밋 완료.

SELECT *
FROM VIEW_SAWON;
--> 뷰만들고 난 후 에 변경했는데 조회해도 변경된 값으로 조회됨!!
SELECT *
FROM TBL_SAWON;

--○ TBL_SAWON 테이블의 김소연 사원의 입사일 및 급여 데이터 변경 이후 다시 확인
--   현재 TABLE 상태 : 1001	김소연	9307302234567	2001-01-03	3000
--   변경 후 상태    : 1001	김소연	9307302234567	2021-09-03	5000
--   현재 VIEW 상태  : 1001	김소연	9307302234567	여자	29	2001-01-03	2052-01-03	7548	11078	3000	900
--   변경 후 상태    : 1001	김소연	9307302234567	여자	29	2021-09-03	2052-09-03	   0	11322	5000	  0

--○ 문제
--   서브쿼리를 활용하여 TBL_SAWON 테이블을 다음과 같이 조회할 수 있도록 한다.
/*
-----------------------------------------------------------
    사원명  성별  현재나이  급여  나이보너스
-----------------------------------------------------------

단, 나이보너스는 현재 나이가 40세 이상이면 급여의 70%
    30세 이상 40세 미만이면 급여의 50%
    20세 이상 30세 미만이면 급여의 30%로 한다.
    
또한, 완성된 조회 구문을 기반으로
VIEW_SAWON2 라는 이름의 뷰(VIEW)를 생성한다.
*/

--내가 푼것
/*
CREATE OR REPLACE VIEW VIEW_SAWON2
AS
SELECT T.사원명, T.성별, T.현재나이, T.급여
     , CASE WHEN T.현재나이>=40 THEN T.급여*0.7 
            WHEN T.현재나이>=30 THEN T.급여*0.5
            WHEN T.현재나이>=20 THEN T.급여*0.3
            ELSE 0
            END "나이보너스"
FROM
(
    SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호",HIREDATE "입사일", SAL "급여"
         , CASE WHEN SUBSTR(JUBUN,7,1) IN('1','3') THEN '남자'
                WHEN SUBSTR(JUBUN,7,1) IN('2','4') THEN '여자' 
                ELSE '성별확인불가'
           END "성별"
        , CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','2')
                   THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899) 
                   WHEN SUBSTR(JUBUN,7,1) IN ('3','4')
                   THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999)
                   ELSE -1  -- 그냥 음수1로 시각적으로 처리
              END "현재나이"
    FROM TBL_SAWON
) T;

-- 현재 나이구하기 연습
SELECT CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','2') THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899) 
            WHEN SUBSTR(JUBUN,7,1) IN ('3','4') THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999)
            ELSE -1
       END "현재나이"
FROM TBL_SAWON;
*/

-- 풀이


SELECT T.*
     , CASE WHEN T.현재나이 >= 40 THEN T.급여 * 0.7 
            WHEN T.현재나이 >= 30 THEN T.급여 * 0.5
            WHEN T.현재나이 >= 20 THEN T.급여 * 0.3
            ELSE 0
        END "나이보너스"
FROM
(
    SELECT SANAME "사원명"
         , CASE WHEN SUBSTR(JUBUN,7,1) IN('1','3') THEN '남자'
                WHEN SUBSTR(JUBUN,7,1) IN('2','4') THEN '여성'
                ELSE '확인불가'
            END "성별"
         , CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','2') 
                THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899) 
                WHEN SUBSTR(JUBUN,7,1) IN ('3','4') 
                THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999)
            --  ELSE '확인불가' 이렇게하면 자료형이 안맞음 위에는 전부 숫자형인데 얘만 문자형이라 에러남!
                ELSE -1
            END "현재나이"
           , SAL "급여"
    FROM TBL_SAWON
) T;

-- 인라인뷰(FROM 절 안에 있는 서브쿼리)만 드래그해서 실행시켰을때 실행이 되어야 함!!

CREATE USER 유저명;
CREATE TABLE 테이블명;
CREATE INDEX 인덱스명;
CREATE VIEW 뷰명;              -- 으로 들어가야 하는데 보면
CREATE OR REPLACE VIEW 뷰명;   -- OR REPLACE 이거붙이는 이유는?! 실행했던거 또실행하면 에러나니까!
                               -- OR REPLACE 이거 있으면 다시 실행해도 괜찮음!!


CREATE OR REPLACE VIEW VIEW_SAWON2
AS
SELECT T.*
     , CASE WHEN T.현재나이 >= 40 THEN T.급여 * 0.7 
            WHEN T.현재나이 >= 30 THEN T.급여 * 0.5
            WHEN T.현재나이 >= 20 THEN T.급여 * 0.3
            ELSE 0
        END "나이보너스"
FROM
(
    SELECT SANAME "사원명"
         , CASE WHEN SUBSTR(JUBUN,7,1) IN('1','3') THEN '남자'
                WHEN SUBSTR(JUBUN,7,1) IN('2','4') THEN '여성'
                ELSE '확인불가'
            END "성별"
         , CASE WHEN SUBSTR(JUBUN,7,1) IN ('1','2') 
                THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899) 
                WHEN SUBSTR(JUBUN,7,1) IN ('3','4') 
                THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999)
            --  ELSE '확인불가' 이렇게하면 자료형이 안맞음 위에는 전부 숫자형인데 얘만 문자형이라 에러남!
                ELSE -1
            END "현재나이"
           , SAL "급여"
    FROM TBL_SAWON
) T;
--==>> View VIEW_SAWON2이(가) 생성되었습니다.

--○ 생성된 뷰 조회(확인)
SELECT *
FROM VIEW_SAWON2;
--==>>
/*
김소연	    여성	29	5000	1500
이다영	    여성	27	2000	600
이지영	    여성	13	1000	0
손다정	    여성	28	4000	1200
이하이	    여성	18	1000	0
이이경	    남자	20	2000	600
김이나	    여성	42	3000	2100
아이유	    여성	41	3000	2100
선동열	    남자	50	3000	2100
선우용녀	여성	52	3000	2100
선우선	    여성	32	2000	1000
남진	    남자	42	4000	2800
남궁현	    남자	40	3000	2100
남도일	    남자	30	3000	1500
김남길	    남자	20	2000	600
*/

-- 여기까지 서브쿼리
--------------------------------------------------------------------------------

--○ RANK()  등수(순위)를 반환하는 함수
-- 사용법이 특이하니 집중!!
-- 순위가 동일할 경우 같은 순번을 부여한 다음 순번이 순서를 건너 뛰는 형식의 숫자를 부여함
SELECT EMPNO "사원번호", ENAME "사원명", DEPTNO "부서번호", SAL "급여"
     , RANK() OVER(ORDER BY SAL DESC) "전체 급여순위"
FROM EMP;
--==>>
/*
7839	KING	10	5000	 1
7902	FORD	20	3000 	 2
7788	SCOTT	20	3000 	 2
7566	JONES	20	2975	 4
7698	BLAKE	30	2850	 5
7782	CLARK	10	2450	 6
7499	ALLEN	30	1600	 7
7844	TURNER	30	1500	 8
7934	MILLER	10	1300	 9
7521	WARD	30	1250	10
7654	MARTIN	30	1250	10
7876	ADAMS	20	1100	12
7900	JAMES	30	 950	13
7369	SMITH	20	 800	14
*/

SELECT EMPNO "사원번호", ENAME "사원명", DEPTNO "부서번호", SAL "급여"
     , RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "부서내 급여순위"        -- PARTITION BY 나눠서 볼껀데 부서를 기준으로 나눠서 보자
     , RANK() OVER(ORDER BY SAL DESC) "전체 급여순위"
FROM EMP;
--==>>
/*
7839	KING	10	5000	1	1
7902	FORD	20	3000	1	2
7788	SCOTT	20	3000	1	2
7566	JONES	20	2975	3	4
7698	BLAKE	30	2850	1	5
7782	CLARK	10	2450	2	6
7499	ALLEN	30	1600	2	7
7844	TURNER	30	1500	3	8
7934	MILLER	10	1300	3	9
7521	WARD	30	1250	4	10
7654	MARTIN	30	1250	4	10
7876	ADAMS	20	1100	4	12
7900	JAMES	30	950	    6	13
7369	SMITH	20	800	    5	14
*/

SELECT EMPNO "사원번호", ENAME "사원명", DEPTNO "부서번호", SAL "급여"
     , RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "부서내 급여순위"        -- PARTITION BY 나눠서 볼껀데 부서를 기준으로 나눠서 보자
     , RANK() OVER(ORDER BY SAL DESC) "전체 급여순위"
FROM EMP
ORDER BY 3,4 DESC;
--==>> 이렇게 보면 보기 쉬움
/*
7839	KING	10	5000	1	1
7782	CLARK	10	2450	2	6
7934	MILLER	10	1300	3	9
7902	FORD	20	3000	1	2
7788	SCOTT	20	3000	1	2
7566	JONES	20	2975	3	4
7876	ADAMS	20	1100	4	12
7369	SMITH	20	 800	5	14
7698	BLAKE	30	2850	1	5
7499	ALLEN	30	1600	2	7
7844	TURNER	30	1500	3	8
7654	MARTIN	30	1250	4	10
7521	WARD	30	1250	4	10
7900	JAMES	30	 950	6	13
*/

--○ DENSE_RANK()    → 서열을 반환하는 함수
-- 위에 조회한거에서 공동순위있으니까 1등 2명 그리고 바로 3등나옴!
-- RANK() 대신에 DENSE_RANK() 넣음!
-- 순번이 동일할 경우 같은 순번을 부여하고 다음 순번을 유지하는 방벙
SELECT EMPNO "사원번호", ENAME "사원명", DEPTNO "부서번호", SAL "급여"
     , DENSE_RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "부서내 급여서열"        -- PARTITION BY 나눠서 볼껀데 부서를 기준으로 나눠서 보자
     , DENSE_RANK() OVER(ORDER BY SAL DESC) "전체 급여서열"
FROM EMP
ORDER BY 3,4 DESC;
--==>>
/*
7839	KING	10	5000	1	 1
7782	CLARK	10	2450	2	 5
7934	MILLER	10	1300	3	 8
7902	FORD	20	3000	1	 2
7788	SCOTT	20	3000	1	 2
7566	JONES	20	2975	2	 3          --> 2등으로 나옴!!
7876	ADAMS	20	1100	3	10
7369	SMITH	20	 800	4	12
7698	BLAKE	30	2850	1	 4
7499	ALLEN	30	1600	2	 6
7844	TURNER	30	1500	3	 7
7654	MARTIN	30	1250	4	 9
7521	WARD	30	1250	4	 9
7900	JAMES	30	 950	5	11
*/

--○ EMP 테이블의 사원 정보를
--   사원명, 부서번호, 연봉, 부서내 연봉순위, 전체 연봉 순위 항목을 조회한다.
SELECT ENAME "사원명", DEPTNO "부서번호"
     , COALESCE(SAL*12+COMM, SAL*12, COMM, 0) "COALESCE 연봉"
     , SAL*12 + NVL(COMM,0) "NVL 연봉"
     , NVL2(COMM, SAL*12+COMM, SAL*12) "NVL2 연봉"
     , RANK() OVER(PARTITION BY DEPTNO ORDER BY COALESCE(SAL*12+COMM, SAL*12, COMM, 0) DESC) "부서내 연봉순위"
     , RANK() OVER(ORDER BY COALESCE(SAL*12+COMM, SAL*12, COMM, 0) DESC) "전체 연봉순위"
     , DENSE_RANK() OVER(ORDER BY COALESCE(SAL*12+COMM, SAL*12, COMM, 0) DESC) "전체 연봉 서열 항목"
FROM EMP
ORDER BY 2,3 DESC;
--==>>
/*
KING	10	60000	60000	60000	1	1	1
CLARK	10	29400	29400	29400	2	6	5
MILLER	10	15600	15600	15600	3	10	9
FORD	20	36000	36000	36000	1	2	2
SCOTT	20	36000	36000	36000	1	2	2
JONES	20	35700	35700	35700	3	4	3
ADAMS	20	13200	13200	13200	4	12	11
SMITH	20	 9600	9600	9600	5	14	13
BLAKE	30	34200	34200	34200	1	5	4
ALLEN	30	19500	19500	19500	2	7	6
TURNER	30	18000	18000	18000	3	8	7
MARTIN	30	16400	16400	16400	4	9	8
WARD	30	15500	15500	15500	5	11	10
JAMES	30	11400	11400	11400	6	13	12
*/

-- + ORDER BY만 했을 경우
SELECT ENAME "사원명", DEPTNO "부서번호"
     , COALESCE(SAL*12+COMM, SAL*12, COMM, 0) "연봉"
FROM EMP
ORDER BY 3 DESC;
--==>>
/*
KING	10	60000
FORD	20	36000
SCOTT	20	36000
JONES	20	35700
BLAKE	30	34200
CLARK	10	29400
ALLEN	30	19500
TURNER	30	18000
MARTIN	30	16400
MILLER	10	15600
WARD	30	15500
ADAMS	20	13200
JAMES	30	11400
SMITH	20	 9600
*/
-- ++ ROW_NUMBER()
-- 같이 동일해도 다른 순번을 부여하는 방법
SELECT ENAME "사원명", DEPTNO "부서번호"
     , COALESCE(SAL*12+COMM, SAL*12, COMM, 0) "COALESCE 연봉"
     , ROW_NUMBER() OVER(ORDER BY COALESCE(SAL*12+COMM, SAL*12, COMM, 0)) "연봉 순위"
FROM EMP;
--==>>
/*
SMITH	20	9600	1
JAMES	30	11400	2
ADAMS	20	13200	3
WARD	30	15500	4
MILLER	10	15600	5
MARTIN	30	16400	6
TURNER	30	18000	7
ALLEN	30	19500	8
CLARK	10	29400	9
BLAKE	30	34200	10
JONES	20	35700	11
SCOTT	20	36000	12
FORD	20	36000	13
KING	10	60000	14
*/

SELECT T.*
     , RANK() OVER(PARTITION BY T.부서번호 ORDER BY T.연봉 DESC) "부서내 연봉순위"
     , RANK() OVER(ORDER BY T.연봉 DESC) "전체 연봉순위"
FROM
(
SELECT ENAME "사원명"
     , DEPTNO "부서번호"
     , COALESCE(SAL*12+COMM, SAL*12, COMM, 0) "연봉"
FROM EMP
) T
ORDER BY 2,3 DESC;
/*
KING	10	60000	1	1
CLARK	10	29400	2	6
MILLER	10	15600	3	10
FORD	20	36000	1	2
SCOTT	20	36000	1	2
JONES	20	35700	3	4
ADAMS	20	13200	4	12
SMITH	20	9600	5	14
BLAKE	30	34200	1	5
ALLEN	30	19500	2	7
TURNER	30	18000	3	8
MARTIN	30	16400	4	9
WARD	30	15500	5	11
JAMES	30	11400	6	13
*/


--○ EMP 테이블에서 전체 연봉 순위가 1등부터 5등까지만...
--   사원명, 부서번호, 연봉, 전체연봉순위 항목으로 조회한다.

------------내가 푼 풀이---------------------------
SELECT T.*
     --, RANK() OVER(ORDER BY T.연봉 DESC) "전체연봉순위"
     --, CASE WHEN (RANK() OVER(ORDER BY T.연봉 DESC))<= 5 THEN RANK() OVER(ORDER BY T.연봉 DESC) ELSE 0 END "5등까지"
FROM 
(
SELECT ENAME "사원명", DEPTNO "부서번호"
     , SAL*12+NVL(COMM,0) "연봉"
     ,RANK() OVER(ORDER BY SAL*12+NVL(COMM,0) DESC) "전체연봉순위"
FROM EMP
) T
WHERE T.전체연봉순위 <= 5;

-- 내가 푼 풀이 첫 시도에서 한거 위로뺀구문 성공시키려면 중첩 서브쿼리 쓰면됨! 아래에 풀이있음!

----------------풀이------------------
SELECT 사원명, 부서번호, 연봉, 전체연봉순위
FROM EMP
WHERE 전체 연봉 순위가 1등부터 5등;


SELECT ENAME "사원명", DEPTNO "부서번호"
     , SAL*12+NVL(COMM,0) "연봉"
     , RANK() OVER(ORDER BY SAL*12+NVL(COMM,0) DESC) "전체연봉순위"
FROM EMP
WHERE RANK() OVER(ORDER BY SAL*12+NVL(COMM,0) DESC) <= 5;
--==>>
/*
ORA-30483: window  functions are not allowed here
30483. 00000 -  "window  functions are not allowed here"
*Cause:    Window functions are allowed only in the SELECT list of a query.
           And, window function cannot be an argument to another window or group
           function.
*Action:
1,026행, 37열에서 오류 발생
*/
--window  functions == RANK()함수
--※ 위의 내용은 RANK() OVER() 를 WHERE 조건절에서 사용한 경우이며...
--   이 함수는 WHERE 조건절에서 사용할 수 없는 함수이며
--   이 규칙을 어겼기 때문에 발생하는 에러이다.
--   이 경우... 우리는 INLINE VIEW 를 활용하여 풀이해야 한다.

SELECT T.*
FROM
(
    SELECT ENAME "사원명", DEPTNO "부서번호"
         , SAL*12+NVL(COMM,0) "연봉"
         , RANK() OVER(ORDER BY SAL*12+NVL(COMM,0) DESC) "전체연봉순위"
    FROM EMP
) T
WHERE T.전체연봉순위 <=5;


--서브쿼리 중첩---------------------------------------
SELECT T2.*
FROM
(
    SELECT T1.*
         , RANK() OVER(ORDER BY T1.연봉 DESC) "전체연봉순위"
    FROM
    (
        SELECT ENAME "사원명", DEPTNO "부서번호"
             , SAL*12+NVL(COMM,0) "연봉"
        FROM EMP
    ) T1
) T2
WHERE T2.전체연봉순위 <=5;
--==>> ; 이거 서브쿼리할때 주의!!!!!!!!
/*
KING	10	60000	1
SCOTT	20	36000	2
FORD	20	36000	2
JONES	20	35700	4
BLAKE	30	34200	5
*/


--○ EMP 테이블에서 각 부서별로 연봉 등수가 1등부터 2등까지만...
--   사원명, 부서번호, 연봉, 부서내연봉등수, 전체연봉등수 항목을 조회할 수 있도록 한다.

-- RANK() 사용------------------------------------------------------------------
SELECT T.*
FROM
(
    SELECT ENAME "사원명", DEPTNO "부서번호"
         , SAL*12+NVL(COMM,0) "연봉"
         , RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL*12+NVL(COMM,0) DESC) "부서내연봉등수"
         , RANK() OVER(ORDER BY SAL*12+NVL(COMM,0) DESC) "전체연봉등수"
    FROM EMP
) T
WHERE T.부서내연봉등수 <= 2;
/*
KING	10	60000	1	1
CLARK	10	29400	2	6
FORD	20	36000	1	2
SCOTT	20	36000	1	2
BLAKE	30	34200	1	5
ALLEN	30	19500	2	7
*/

-- DENSE_RANK() 사용------------------------------------------------------------
SELECT T.*
FROM
(
    SELECT ENAME "사원명", DEPTNO "부서번호"
         , SAL*12+NVL(COMM,0) "연봉"
         , DENSE_RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL*12+NVL(COMM,0) DESC) "부서내연봉등수"
         , DENSE_RANK() OVER(ORDER BY SAL*12+NVL(COMM,0) DESC) "전체연봉등수"
    FROM EMP
) T
WHERE T.부서내연봉등수 <= 2;
/*
KING	10	60000	1	1
CLARK	10	29400	2	5
FORD	20	36000	1	2
SCOTT	20	36000	1	2
JONES	20	35700	2	3
BLAKE	30	34200	1	4
ALLEN	30	19500	2	6
*/

-- 중첩 서브쿼리 사용----------------------------------------------------------
SELECT T1.*
FROM
(
    SELECT T.*
         , RANK() OVER(PARTITION BY T.부서번호 ORDER BY T.연봉 DESC) "부서내연봉순위"
         , RANK() OVER(ORDER BY T.연봉 DESC) "전체연봉순위"
    FROM
    (
        SELECT ENAME "사원명", DEPTNO "부서번호"
             , COALESCE(SAL*12+COMM, SAL*12, COMM,0) "연봉"
        FROM EMP
    )T
) T1
WHERE T1.부서내연봉순위<=2;
/*
KING	10	60000	1	1
CLARK	10	29400	2	6
FORD	20	36000	1	2
SCOTT	20	36000	1	2
BLAKE	30	34200	1	5
ALLEN	30	19500	2	7
*/
--------------------------------------------------------------------------------

--■■■ 그룹 함수 ■■■--

-- SUM() 합, AVG() 평균, COUNT() 카운트, MAX() 최대값, MIN() 최소값,
-- VARIANCE() 분산, STDDEV() 표준편차

--※ 그룹함수의 가장 큰 특징은
--   처리해야 할 데이터들 중 NULL 이 존재하면
--   이 NULL 은 제외하고 연산을 수행한다는 것이다.

-- SUM()
-- EMP 테이블을 대상으로 전체 사원들의 급여 총합을 조회한다.
SELECT SUM(SAL)      -- 800+1600+1250+2975+1250+2850+...+1300
FROM EMP;
--==>> 29025

SELECT SUM(COMM)      -- NULL+300+500+NULL+...+NULL (X)
FROM EMP;             -- 300+500+1400+0             (O)
--==>> 2200
-- NULL은 어떤 연산을 해도 NULL 이었는데 SUM은 연산 수행!

SELECT COMM
FROM EMP;

-- COUNT()
-- 행의 갯수 조회하여 결과값 반환
SELECT COUNT(ENAME)
FROM EMP;
--==>> 14

SELECT COUNT(SAL)
FROM EMP;
--==>> 14

SELECT COUNT(COMM)      -- COMM 컬럼의 행의 갯수 조회 → -- NULL을 제외~!!!
FROM EMP;
--==>> 4

-- 그래서 이렇게 숫자를 세는게 일반적임
SELECT COUNT(*)
FROM EMP;
--==>> 14

--○ AVG()
-- 평균 반환
SELECT SUM(SAL) / COUNT(SAL) "1", AVG(SAL) "2"
FROM EMP;
--==>>
/*
2073.214285714285714285714285714285714286	
2073.214285714285714285714285714285714286
*/

-- 주의할 것
SELECT AVG(COMM)
FROM EMP;
--==>> 550

SELECT SUM(COMM) / COUNT(COMM)
FROM EMP;
--==>> 550

-- 원래는 이게 맞음!!인원수만큼 나눠야하는데 SUM, COUNT, AVG는 NULL을 반영하니까! 
SELECT SUM(COMM) / 14
FROM EMP;
--==>> 157.142857142857142857142857142857142857

--그래서 올바른 평균값 조회시 이렇게!!!
SELECT SUM(COMM) / COUNT(*)
FROM EMP;
--==>> 157.142857142857142857142857142857142857

--※ 표준편차의 제곱이 분산
--   분산의 제곱근이 표준편차
SELECT AVG(SAL), VARIANCE(SAL), STDDEV(SAL)
FROM EMP;
--==>>
/*
2073.214285714285714285714285714285714286	
1398313.87362637362637362637362637362637	
1182.503223516271699458653359613061928508
*/

SELECT POWER(STDDEV(SAL),2) "급여표준편차제곱"
     , VARIANCE(SAL) "급여분산"
FROM EMP;
--==>>
/*
1398313.87362637362637362637362637362637	
1398313.87362637362637362637362637362637
*/

SELECT SQRT(VARIANCE(SAL)) "급여분산제곱근"
     , STDDEV(SAL) "급여표준편차"
FROM EMP;
--==>>
/*
1182.503223516271699458653359613061928508	
1182.503223516271699458653359613061928508
*/

-- 분산과 표준편차 개념 기억!!



--○ MAX() / MIN()
--  최대값 / 최소값 반환
SELECT MAX(SAL), MIN(SAL)
FROM EMP;
--==>> 5000	800


--※ 주의
SELECT ENAME, SUM(SAL)
FROM EMP;
--==>> 에러 발생
/*
ORA-00937: not a single-group group function
00937. 00000 -  "not a single-group group function"
*Cause:    
*Action:
1,264행, 8열에서 오류 발생
*/
--  레코드 구조 자체가 안맞음!!(다중행) (단일행) 아래 확인!

SELECT ENAME, SAL
FROM EMP;
/* (다중행)
SMITH	800
ALLEN	1600
WARD	1250
JONES	2975
MARTIN	1250
BLAKE	2850
CLARK	2450
SCOTT	3000
KING	5000
TURNER	1500
ADAMS	1100
JAMES	950
FORD	3000
MILLER	1300
*/
SELECT SUM(SAL)
FROM EMP;
--==>> (단일행) 29025


SELECT DEPTNO, SUM(SAL)
FROM EMP;
--==>> 에러 발생
/*
ORA-00937: not a single-group group function
00937. 00000 -  "not a single-group group function"
*Cause:    
*Action:
1,298행, 8열에서 오류 발생
*/

----그래서 나온것이 GROUP BY절! 그래서 그룹함수!

--○ 부서별 급여합 조회
SELECT DEPTNO "부서번호", SUM(SAL) "급여합"
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;
--==>>
/*
10	 8750
20	10875
30	 9400
*/

--○ 직종별 급여합 조회
SELECT JOB "직종명", SUM(SAL) "급여합"
FROM EMP
GROUP BY JOB;
--==>>
/*
CLERK	    4150
SALESMAN	5600
PRESIDENT	5000
MANAGER	    8275
ANALYST	    6000
*/

--○ ROLLUP
-- ROLLUP을 구성해서 사용하는 경우가 더 많음!!!
-- DEPTNO로 묶어서 합을 구했는데 이걸 전체 합 행 하나를 추가!
SELECT DEPTNO "부서번호", SUM(SAL) "급여합"
FROM EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
10	    8750
20	    10875
30	    9400
(NULL)	29025
*/

-------------------------------------------------------------------------------
-- 여기서부터는 TBL_EMP로 조회!

--○ 데이터 입력
INSERT INTO TBL_EMP VALUES
(8001, '차은우', 'CLERK',7566, SYSDATE,1500,10,NULL);
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_EMP VALUES
(8002, '서강준', 'CLERK',7566, SYSDATE,1000,0,NULL);
--==>> 1 행 이(가) 삽입되었습니다.

--○ 커밋
COMMIT;
--==>> 커밋 완료.

SELECT *
FROM TBL_EMP;

SELECT *
FROM EMP;
