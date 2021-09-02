SELECT USER
FROM DUAL;
--==>> SCOTT

--○ TBL_EMP 테이블에서 입사일이 1981년 4월 2일 부터
--   1981년 9월 28일 사이에 입사한 직원들의
--   사원명, 직종명, 입사일 항목을 조회한다. 해당일 포함)
SELECT ENAME "사원명",JOB "직종명",HIREDATE  "입사일"
FROM TBL_EMP
WHERE HIREDATE >= TO_DATE('1981-04-02', 'YYYY-MM-DD')
    AND HIREDATE <= TO_DATE('1981-09-28', 'YYYY-MM-DD');
--==>>
/*
JONES	MANAGER	    1981-04-02
MARTIN	SALESMAN	1981-09-28
BLAKE	MANAGER	    1981-05-01
CLARK	MANAGER	    1981-06-09
TURNER	SALESMAN	1981-09-08
*/

--※ 날짜 세션 설정 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

--○ BETWEEN A AND B 사용해도 된다!
SELECT ENAME "사원명",JOB "직종명",HIREDATE  "입사일"
FROM TBL_EMP
WHERE HIREDATE BETWEEN TO_DATE('1981-04-02', 'YYYY-MM-DD') AND TO_DATE('1981-09-28', 'YYYY-MM-DD');
--==>>
/*
JONES	MANAGER	    1981-04-02
MARTIN	SALESMAN	1981-09-28
BLAKE	MANAGER	    1981-05-01
CLARK	MANAGER	    1981-06-09
TURNER	SALESMAN	1981-09-08
*/


SELECT *
FROM TBL_EMP
WHERE SAL BETWEEN 1600 AND 3000;
--==>>
/*
7499	ALLEN	SALESMAN	7698	1981-02-20	1600	300	30
7566	JONES	MANAGER	    7839	1981-04-02	2975		20
7698	BLAKE	MANAGER	    7839	1981-05-01	2850		30
7782	CLARK	MANAGER	    7839	1981-06-09	2450		10
7788	SCOTT	ANALYST	    7566	1987-07-13	3000		20
7902	FORD	ANALYST	    7566	1981-12-03	3000		20
*/

SELECT *
FROM TBL_EMP
WHERE ENAME BETWEEN 'C' AND 'S';
--==>>
/*
7566	JONES	MANAGER	        7839	1981-04-02	2975		    20
7654	MARTIN	SALESMAN	    7698	1981-09-28	1250	1400	30
7782	CLARK	MANAGER	        7839    1981-06-09	2450		    10
7839	KING	PRESIDENT		        1981-11-17	5000		    10
7900	JAMES	CLERK	        7698	1981-12-03	950		        30
7902	FORD	ANALYST	        7566	1981-12-03	3000		    20
7934	MILLER	CLERK	        7782	1982-01-23	1300		    10
*/

--> SMITH 와 SCOTT 이 출력이 안돼!?! 
--  BETWEEN 구문에서 날짜와 숫자 모두 값이 포함해서 조회되지만 '문자'는 앞에 문자는 포함인데 뒤에 문자는 미포함이다!?
--  사원 이름 중에 'S'인 사람있으면 나옴!!
--  ●--------------● ---
--  'C'            'S'

SELECT *
FROM TBL_EMP
WHERE ENAME BETWEEN 'C' AND 's';
--==>> 소문자 s하면 SMITH 랑 SCOTT로 나옴! 사전식 배열이라 가능!
/*
7369	SMITH	CLERK	    7902	1980-12-17	800		        20
7521	WARD	SALESMAN	7698	1981-02-22	1250	500	    30
7566	JONES	MANAGER	    7839	1981-04-02	2975		    20
7654	MARTIN	SALESMAN	7698	1981-09-28	1250	1400	30
7782	CLARK	MANAGER	    7839	1981-06-09	2450		    10
7788	SCOTT	ANALYST	    7566	1987-07-13	3000		    20
7839	KING	PRESIDENT		    1981-11-17	5000		    10
7844	TURNER	SALESMAN	7698	1981-09-08	1500	    0	30
7900	JAMES	CLERK	    7698	1981-12-03	950		        30
7902	FORD	ANALYST	    7566	1981-12-03	3000		    20
7934	MILLER	CLERK	    7782	1982-01-23	1300		    10
*/

--○ ASCII()
SELECT ASCII('A'), ASCII('B'), ASCII('a'), ASCII('b')
FROM DUAL;
--==>> 65	66	97	98

--※ BETWEEN A AND B 는 날짜형, 숫자형, 문자형 데이터 모두에 적용된다.
--   단, 문자열일 경우 아스키코드 순서에 따르기 때문에
--   대문자가 앞쪽에 위치하고 소문자가 뒤쪽에 위치한다.
--   또한,  BETWEEN A AND B 는 쿼리문이 수행되는 시점에서
--   오라클 내부적으로 부등호 연산자의 형태로 바뀌어 연산이 처리된다.
--   (부등호에서  BETWEEN A AND B 으로 굳이 변경할 필요 없다!)


--○ TBL_EMP 테이블에서 직종이 SALESMAN 과 CLERK 인 사원의
--   사원명, 직종명, 급여 항목을 조회한다.
SELECT ENAME "사원명", JOB "직종명", SAL "급여"
FROM TBL_EMP
WHERE JOB = 'SALESMAN'
    OR JOB = 'CLERK';

SELECT ENAME "사원명",JOB "직종명",SAL "급여"
FROM TBL_EMP
WHERE JOB IN ( 'SALESMAN', 'CLERK' );
--> IN() ()안에 들어있는 어떤거든 조회한다.

SELECT ENAME"사원명",JOB"직종명",SAL"급여"
FROM TBL_EMP
WHERE JOB = ANY('SALESMAN','CLERK');                    --- cf. 『=ALL』 이거는 ()안에 모두 맞아야 조회
-- 이퀄애니  둘중 아무거나 일치하면 조회한다. IN과 같은 의미
--==>>
/*
SMITH	CLERK	    800
ALLEN	SALESMAN	1600
WARD	SALESMAN	1250
MARTIN	SALESMAN	1250
TURNER	SALESMAN	1500
ADAMS	CLERK	    1100
JAMES	CLERK	    950
MILLER	CLERK	    1300
*/

--※ 위의 3가지 유형의 쿼리문은 모두 같은 결과를 반환한다.
--   하지만, 맨 위의 쿼리문이 가장 빠르게 처리된다.
--   물론, 메모리에 대한 내용이 아니라 CPU 에 대한 내용이기 때문에
--   이 부분까지 감안하여 쿼리문의 내용을 구성하는 일은 많지 않다.
--   → 『IN』 과 『=ANY』 는 같은 연산자 효과를 가진다.
--   모두 내부적으로는 『OR』구조로 변경되어 연산 처리된다.

--------------------------------------------------------------------------------
DROP TABLE TBL_
PURGE RECYCLEBIN; 

--○ 추가 실습 테이블 구성(TBL_SAWON)
CREATE TABLE TBL_SAWON (
    SANO      NUMBER(4),
    SANAME    VARCHAR2(30),
    JUBUN     CHAR(13),
    HIREDATE  DATE DEFAULT SYSDATE,
    SAL       NUMBER(10)
);
--==>> Table TBL_SAWON이(가) 생성되었습니다.

SELECT *
FROM TBL_SAWON;
--==>> 조회 결과 없음

DESC TBL_SAWON;
--==>>
/*
이름       널? 유형           
-------- -- ------------ 
SANO        NUMBER(4)    
SANAME      VARCHAR2(30) 
JUBUN       CHAR(13)     
HIREDATE    DATE         
SAL         NUMBER(10)
*/

--○ 데이터 입력(TBL_SAWON)
INSERT INTO TBL_SAWON (SANO,SANAME,JUBUN,HIREDATE,SAL) 
VALUES (1001,'김소연','9307302234567',TO_DATE('2001-01-03', 'YYYY-MM-DD'), 3000);

INSERT INTO TBL_SAWON (SANO,SANAME,JUBUN,HIREDATE,SAL) 
VALUES (1002,'이다영','9510272234567',TO_DATE('2010-11-05', 'YYYY-MM-DD'),2000);

INSERT INTO TBL_SAWON (
    SANO,
    SANAME,
    JUBUN,
    HIREDATE,
    SAL
) VALUES (
    1003,
    '이지영',
    '0909014234567',
    TO_DATE('2012-08-16', 'YYYY-MM-DD'),
    1000
);

INSERT INTO TBL_SAWON (
    SANO,
    SANAME,
    JUBUN,
    HIREDATE,
    SAL
) VALUES (
    1004,
    '손다정',
    '9406032234567',
    TO_DATE('1999-02-02', 'YYYY-MM-DD'),
    4000
);

INSERT INTO TBL_SAWON (
    SANO,
    SANAME,
    JUBUN,
    HIREDATE,
    SAL
) VALUES (
    1005,
    '이하이',
    '0406034234567',
    TO_DATE('2013-07-15', 'YYYY-MM-DD'),
    1000
);

INSERT INTO TBL_SAWON (
    SANO,
    SANAME,
    JUBUN,
    HIREDATE,
    SAL
) VALUES (
    1006,
    '이이경',
    '0202023234567',
    TO_DATE('2011-08-17', 'YYYY-MM-DD'),
    2000
);

INSERT INTO TBL_SAWON (
    SANO,
    SANAME,
    JUBUN,
    HIREDATE,
    SAL
) VALUES (
    1007,
    '김이나',
    '8012122234567',
    TO_DATE('1999-11-11', 'YYYY-MM-DD'),
    3000
);

INSERT INTO TBL_SAWON (
    SANO,
    SANAME,
    JUBUN,
    HIREDATE,
    SAL
) VALUES (
    1008,
    '아이유',
    '8105042234567',
    TO_DATE('1999-11-11', 'YYYY-MM-DD'),
    3000
);

INSERT INTO TBL_SAWON (
    SANO,
    SANAME,
    JUBUN,
    HIREDATE,
    SAL
) VALUES (
    1009,
    '선동열',
    '7209301234567',
    TO_DATE('1995-11-11', 'YYYY-MM-DD'),
    3000
);

INSERT INTO TBL_SAWON (
    SANO,
    SANAME,
    JUBUN,
    HIREDATE,
    SAL
) VALUES (
    1010,
    '선우용녀',
    '7001022234567',
    TO_DATE('1995-10-10', 'YYYY-MM-DD'),
    3000
);

INSERT INTO TBL_SAWON (
    SANO,
    SANAME,
    JUBUN,
    HIREDATE,
    SAL
) VALUES (
    1011,
    '선우선',
    '9001022234567',
    TO_DATE('2001-10-10', 'YYYY-MM-DD'),
    2000
);

INSERT INTO TBL_SAWON (
    SANO,
    SANAME,
    JUBUN,
    HIREDATE,
    SAL
) VALUES (
    1012,
    '남진',
    '8009011234567',
    TO_DATE('1998-02-13', 'YYYY-MM-DD'),
    4000
);

INSERT INTO TBL_SAWON (
    SANO,
    SANAME,
    JUBUN,
    HIREDATE,
    SAL
) VALUES (
    1013,
    '남궁현',
    '8203051234567',
    TO_DATE('2002-02-13', 'YYYY-MM-DD'),
    3000
);

INSERT INTO TBL_SAWON (
    SANO,
    SANAME,
    JUBUN,
    HIREDATE,
    SAL
) VALUES (
    1014,
    '남도일',
    '9208091234567',
    TO_DATE('2002-02-13', 'YYYY-MM-DD'),
    3000
);

INSERT INTO TBL_SAWON (
    SANO,
    SANAME,
    JUBUN,
    HIREDATE,
    SAL
) VALUES (
    1015,
    '김남길',
    '0202023234567',
    TO_DATE('2015-01-10', 'YYYY-MM-DD'),
    2000
);
--==>> 1 행 이(가) 삽입되었습니다. * 15

--○ 확인
SELECT *
FROM TBL_SAWON;
--==>>
/*
1001	김소연	    9307302234567	2001-01-03	3000
1002	이다영	    9510272234567	2010-11-05	2000
1003	이지영	    0909014234567	2012-08-16	1000
1004	손다정	    9406032234567	1999-02-02	4000
1005	이하이	    0406034234567	2013-07-15	1000
1006	이이경	    0202023234567	2011-08-17	2000
1007	김이나	    8012122234567	1999-11-11	3000
1008	아이유	    8105042234567	1999-11-11	3000
1009	선동열	    7209301234567	1995-11-11	3000
1010	선우용녀	7001022234567	1995-10-10	3000
1011	선우선	    9001022234567	2001-10-10	2000
1012	남진	    8009011234567	1998-02-13	4000
1013	남궁현	    8203051234567	2002-02-13	3000
1014	남도일	    9208091234567	2002-02-13	3000
1015	김남길	    0202023234567	2015-01-10	2000
*/

--○ 커밋
COMMIT;
--==>> 커밋 완료.

--○ TBL_SAWON 테이블에서 김소연 사원의 정보를 모두 조회힌다.
SELECT *
FROM TBL_SAWON
WHERE SANAME = '김소연';
--==>> 1001	김소연	9307302234567	2001-01-03	3000

SELECT *
FROM TBL_SAWON
WHERE SANAME LIKE '김소연';
--==>> 1001	김소연	9307302234567	2001-01-03	3000

--※ LIKE : 동사 → 좋아하다.
--          부사 → ~와 같이, ~처럼

--※ WILD CHARACTER → 『%』
--   『LIKE』 와 함께 사용되는 『%』는 모든 글자를 의미하고
--   『LIKE』 와 함께 사용되는 『_』는 아무 글자 1개를 의미한다.

--○ TBL_SAWON 테이블에서 성씨가 『이』씨인 사원의
--   사원명, 주민번호, 급여 항목을 조회한다.
SELECT SANAME,JUBUN,SAL
FROM TBL_SAWON
WHERE SANAME LIKE '이';

--==>> 조회 결과 없음(에러 발생하지 않음, '이'를 조회한 것)

SELECT SANAME,JUBUN,SAL
FROM TBL_SAWON
WHERE SANAME LIKE '이__';

SELECT SANAME,JUBUN,SAL
FROM TBL_SAWON
WHERE SANAME LIKE '이_';
--==>> 조회 결과 없음 (이름이 2글자인 사람중에 첫글자가 '이'인 사람)

SELECT SANAME,JUBUN,SAL
FROM TBL_SAWON
WHERE SANAME '이_';
--==>> 조회 결과 없음(이름이 '이_'인 사람)

SELECT SANAME, JUBUN, SAL
FROM TBL_SAWON
WHERE SANAME LIKE '이%';
--==>> 첫 글자가 '이' 이기만 하면됨
/*
이다영	9510272234567	2000
이지영	0909014234567	1000
이하이	0406034234567	1000
이이경	0202023234567	2000
*/


--○ TBL_SAWON 테이블에서 성씨가 『남』씨인 사원의
--   사원명, 주민번호, 급여 항목을 조회한다.
SELECT SANAME, JUBUN, SAL
FROM TBL_SAWON
WHERE SANAME LIKE '남__';
--==>>
/*
남궁현	8203051234567	3000
남도일	9208091234567	3000
*/
--> 남진 누락

SELECT SANAME, JUBUN, SAL
FROM TBL_SAWON
WHERE SANAME LIKE '남_';
--==>> 남진	8009011234567	4000
--> 남궁현, 남도일 누락

SELECT SANAME, JUBUN, SAL
FROM TBL_SAWON
WHERE SANAME LIKE '남__'
   OR SANAME LIKE '남_';
--==>>
/*
남진	8009011234567	4000
남궁현	8203051234567	3000
남도일	9208091234567	3000
*/

SELECT SANAME, JUBUN, SAL
FROM TBL_SAWON
WHERE SANAME LIKE '남%';
--==>>
/*
남진	8009011234567	4000
남궁현	8203051234567	3000
남도일	9208091234567	3000
*/


--○ TBL_SAWON 테이블에서 이름의 마지막 글자가 『영』으로
--   끝나는 사원의 사원명, 주민번호, 입사일, 급여 항목을 조회한다.
SELECT SANAME, JUBUN, HIREDATE, SAL
FROM TBL_SAWON
WHERE SANAME LIKE '%영';
--==>>
/*
이다영	9510272234567	2010-11-05	2000
이지영	0909014234567	2012-08-16	1000
*/

SELECT SANAME, JUBUN, HIREDATE, SAL
FROM TBL_SAWON
WHERE SANAME LIKE '__영';
--   OR SANAME LIKE '_영';
--==>>
/*
이다영	9510272234567	2010-11-05	2000
이지영	0909014234567	2012-08-16	1000
*/


--○ TBL_SAWON 테이블에서 사원 이름 안에 『이』라는 글자가
--   하나라도 포함되어 있으면 그 사원의
--   사원번호, 사원명, 입사일, 급여 항목을 조회한다.
SELECT SANO, SANAME, HIREDATE, SAL
FROM TBL_SAWON
WHERE SANAME LIKE '%이%';
--==>>
/*
1002	이다영	2010-11-05	2000
1003	이지영	2012-08-16	1000
1005	이하이	2013-07-15	1000
1006	이이경	2011-08-17	2000
1007	김이나	1999-11-11	3000
1008	아이유	1999-11-11	3000
*/

--○ TBL_SAWON 테이블에서  사원 이름 안에 『이』라는 글자가
--   두 번 포함되어 있으면 그 사원의
--   사원번호, 사원명, 입사일, 급여 항목을 조회한다.
SELECT SANO, SANAME, HIREDATE, SAL
FROM TBL_SAWON
WHERE SANAME LIKE '%이이%';
--==>> 1006	이이경	2011-08-17	2000 (이름 중간에 이이가 붙어있는 이름)

SELECT SANO, SANAME, HIREDATE, SAL
FROM TBL_SAWON
WHERE SANAME LIKE '%이%이%';
--==>>
/*
1005	이하이	2013-07-15	1000
1006	이이경	2011-08-17	2000
*/

SELECT *
FROM TBL_SAWON;

--○ TBL_SAWON 테이블에서 성씨가 『선』씨인 사원의
--   사원명, 주민번호, 급여 항목을 조회한다.
SELECT SANAME, JUBUN, SAL
FROM TBL_SAWON
WHERE SANAME LIKE '선%';
--> 불가!! (성이 선우, 남궁 처럼 성이 어디까지인지 몰라서!)

--○ TBL_SAWON 테이블에서 성씨가 『남』씨인 사원의
--   사원명, 주민번호, 급여 항목을 조회한다.
--> 불가!!

--※ 데이터베이스 설계 시 성과 이름을 분리해서 처리해야 할 업무 계획이 있다면
--   (지금 당장은 아니더라도...) 테이블에서 성 컬럼과 이름 컬럼을 분리하여 구성해야 한다.
--   성[ ] 이름[    ]  이런식으로 


--○ TBL_SAWON 테이블에서 여직원들의 사원명, 주민번호, 급여 항목을 조회한다.
SELECT SANAME, JUBUN, SAL
FROM TBL_SAWON
WHERE JUBUN LIKE '______2%'
   OR JUBUN LIKE '______4%';
   
SELECT SANAME, JUBUN, SAL
FROM TBL_SAWON
WHERE JUBUN LIKE '______2______'
   OR JUBUN LIKE '______4______';
--==>>
/*
김소연	    9307302234567	3000
이다영	    9510272234567	2000
이지영	    0909014234567	1000
손다정	    9406032234567	4000
이하이	    0406034234567	1000
김이나	    8012122234567	3000
아이유	    8105042234567	3000
선우용녀	7001022234567	3000
선우선	    9001022234567	2000
*/

--○ 테이블 생성(TBL_WATCH)
CREATE TABLE TBL_WATCH
(WATCH_NAME     VARCHAR2(20)
,BIGO           VARCHAR2(100)
);
--==>> Table TBL_WATCH이(가) 생성되었습니다.

--○ 데이터 입력(TBL_WATCH)
INSERT INTO TBL_WATCH(WATCH_NAME, BIGO)
VALUES('금시계','순금 99.99% 함유된 최고급 시계');
INSERT INTO TBL_WATCH(WATCH_NAME, BIGO)
VALUES('은시계','고객 만족도 99.99점을 획득한 시계');
--==>> 1 행 이(가) 삽입되었습니다. * 2

--○ 확인
SELECT *
FROM TBL_WATCH;
--==>>
/*
금시계	순금 99.99% 함유된 최고급 시계
은시계	고객 만족도 99.99점을 획득한 시계
*/

--○ 커밋
COMMIT;
--==>> 커밋 완료.


--○ TBL_WATCH 테이블의 BIGO 컬럼에
--   『99.99%』라는 글자가 들어있는 행(레코드)의 정보를 조회한다.
SELECT *
FROM TBL_WATCH
WHERE BIGO LIKE '99.99%';
--==>> 조회 결과 없음 (99.99로 시작하는 데이터)

SELECT *
FROM TBL_WATCH
WHERE BIGO LIKE '%99.99';
--==>> 조회 결과 없음 (99.99로 끝나는 데이터)

SELECT *
FROM TBL_WATCH
WHERE BIGO LIKE '%99.99%';
--==>> %는 하나든 두개든 세개든 몇개든 의미는 같음
/*
금시계	순금 99.99% 함유된 최고급 시계
은시계	고객 만족도 99.99점을 획득한 시계
*/

-- ESCAPE
SELECT *
FROM TBL_WATCH
WHERE BIGO LIKE '%99.99$%%' ESCAPE '$';
--==>> 금시계	순금 99.99% 함유된 최고급 시계
--> %를 $로 문자로 처리! $다음 %는 와일드카드아님!!       -- 아하~!

SELECT *
FROM TBL_WATCH
WHERE BIGO LIKE '%99.99\%%' ESCAPE '\';
--==>> 금시계	순금 99.99% 함유된 최고급 시계

--※ ESCAPE로 지정한 문자의 다음 한 글자는 와일드카드에서 탈출시켜라...
--   『ESCAPE '\'』
--   일반적으로 사용빈도가 낮은 특수문자(특수기호)를 사용하게 된다.


--------------------------------------------------------------------------------

-- ■■■ COMMIT / ROLLBACK ■■■--

DELETE
FROM TBL_DEPT
WHERE DEPTNO = 50;

SELECT *
FROM TBL_DEPT;
--==>>
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
*/

--○ 데이터 입력(TBL_DEPT)
INSERT INTO TBL_DEPT(DEPTNO, DNAME, LOC)
VALUES(50,'개발부','서울');
--==>> 1 행 이(가) 삽입되었습니다.
-- 이 데이터는 TBL_DEPT 테이블이 저장되어 있는
-- 하드디스크 상에 물리적으로 적용되어 저장된 것이 아니라
-- 메모리(RAM) 상에 입력된 것이다.

-- ROLLBACK 은 UNDO 와는 다른 개념

--○ 확인
SELECT *
FROM TBL_DEPT;

--○ 롤백
ROLLBACK;
--==>> 롤백 완료.

--○ 다시 확인
SELECT *
FROM TBL_DEPT;
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
*/
--> 50번...개발부...서울... 에 대한 데이터가
--  소실되었음을 확인(존재하지 않음)
--  메모리에 썼던 내용을 휘발시킨 것임!


--○ 다시 입력
INSERT INTO TBL_DEPT(DEPTNO, DNAME, LOC)
VALUES(50,'개발부','서울');
--==>> 1 행 이(가) 삽입되었습니다.
--> 메모리 상에 입력된 이 데이터를 실제 하드디스크상에 물리적으로 저장하기 위해서는
--  COMMIT 을 수행해야 한다.

--○ 확인
SELECT *
FROM TBL_DEPT;
--==>>
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
50	개발부	    서울
*/

--○ 커밋
COMMIT;
--==>> 커밋 완료.

--○ 커밋 이후 다시 확인
SELECT *
FROM TBL_DEPT;
--==>>
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
50	개발부	    서울
*/

--○ 롤백
ROLLBACK;
--==>> 롤백 완료.

--○ 롤백 이후 다시 확인
SELECT *
FROM TBL_DEPT;
--==>>
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
50	개발부	    서울
*/
--> 롤백(ROLLBACK)을 수행했음에도 불구하고
--  50번... 개발부... 서울 의 데이터는 소실되지 않았음을 확인

--※ COMMIT 을 실행한 이후 DML 구분(INSERT, UPDATE, DELETE) 을 통해
--   변경된 데이터만 취소할 수 있는 것일 뿐...
--   DML 명령을 사용한 후 COMMIT 을 수행하고 나서 ROLLBACK 을 실행해봐야
--   이전 상태로 되돌릴 수 없다.(아무런 소용이 없다.)

--○ 데이터 수정(TBL_DEPT)
--   UPDATE / ALTER
--   UPDATE문은 SET부터 쓰지말고 WHERE부터 쓴다!
UPDATE TBL_DEPT
SET DNAME='연구부', LOC='인천'
WHERE DEPTNO=50;
--==>> 1 행 이(가) 업데이트되었습니다.

--○ 확인
SELECT *
FROM TBL_DEPT;
--==>>
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
50	연구부	인천
*/

--○ 롤백
ROLLBACK;
--==>> 롤백 완료.

--○ 롤백 이후 다시 확인
SELECT *
FROM TBL_DEPT;
--==>>
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
50	개발부	서울
*/
--> 수정(UPDATE)을 수행하기 이전 상태로 복원되었음을 확인

--○ 데이터 삭제(DELETE)
DELETE
FROM TBL_DEPT
WHERE DEPTNO=50;
--==>> 1 행 이(가) 삭제되었습니다.

--○ 확인
SELECT *
FROM TBL_DEPT;
--==>>
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
*/

--○ 롤백
ROLLBACK;
--==>>롤백 완료.

--○ 롤백 이후 다시 확인
SELECT *
FROM TBL_DEPT;
--==>>
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
50	개발부	서울
*/
--> 삭제(DELETE) 구문을 수행하기 이전 상태로 복원되었음을 확인

-- ★실무에서 쿼리문에 COMMIT과 붙여 쓰지 말 것!★

--------------------------------------------------------------------------------

 --■■■ 정렬(ORDER BY) ■■■--
 
 
SELECT ENAME "사원명",DEPTNO "부서번호", JOB "직종" , SAL "급여"
        , SAL*12+NVL(COMM,0) "연봉"
FROM TBL_EMP;
--==>>
/*
SMITH	20	CLERK	    800	    9600
ALLEN	30	SALESMAN	1600	19500
WARD	30	SALESMAN	1250	15500
JONES	20	MANAGER	    2975	35700
MARTIN	30	SALESMAN	1250	16400
BLAKE	30	MANAGER	    2850	34200
CLARK	10	MANAGER	    2450	29400
SCOTT	20	ANALYST	    3000	36000
KING	10	PRESIDENT	5000	60000
TURNER	30	SALESMAN	1500	18000
ADAMS	20	CLERK	    1100	13200
JAMES	30	CLERK	    950	    11400
FORD	20	ANALYST	    3000	36000
MILLER	10	CLERK	    1300	15600
*/


SELECT ENAME "사원명",DEPTNO "부서번호", JOB "직종" , SAL "급여"
        , SAL*12+NVL(COMM,0) "연봉"
FROM TBL_EMP
ORDER BY DEPTNO ASC;        -- → DEPTNO → 부서번호 기준 정렬
                            -- → ASC    → 오름차순 정렬
--==>>
/*
CLARK	10	MANAGER	    2450	29400
KING	10	PRESIDENT	5000	60000
MILLER	10	CLERK	    1300	15600
JONES	20	MANAGER	    2975	35700
FORD	20	ANALYST	    3000	36000
ADAMS	20	CLERK	    1100	13200
SMITH	20	CLERK	    800	    9600
SCOTT	20	ANALYST	    3000	36000
WARD	30	SALESMAN	1250	15500
TURNER	30	SALESMAN	1500	18000
ALLEN	30	SALESMAN	1600	19500
JAMES	30	CLERK	    950	    11400
BLAKE	30	MANAGER	    2850	34200
MARTIN	30	SALESMAN	1250	16400
*/


SELECT ENAME "사원명",DEPTNO "부서번호", JOB "직종" , SAL "급여"
        , SAL*12+NVL(COMM,0) "연봉"
FROM TBL_EMP
ORDER BY DEPTNO;        -- → ASC → 오름차순 생략 가능~!!!
--==>>
/*
CLARK	10	MANAGER	    2450	29400
KING	10	PRESIDENT	5000	60000
MILLER	10	CLERK	    1300	15600
JONES	20	MANAGER	    2975	35700
FORD	20	ANALYST	    3000	36000
ADAMS	20	CLERK	    1100	13200
SMITH	20	CLERK	    800	    9600
SCOTT	20	ANALYST	    3000	36000
WARD	30	SALESMAN	1250	15500
TURNER	30	SALESMAN	1500	18000
ALLEN	30	SALESMAN	1600	19500
JAMES	30	CLERK	    950	    11400
BLAKE	30	MANAGER	    2850	34200
MARTIN	30	SALESMAN	1250	16400
*/

SELECT ENAME "사원명",DEPTNO "부서번호", JOB "직종" , SAL "급여"
        , SAL*12+NVL(COMM,0) "연봉"
FROM TBL_EMP
ORDER BY DEPTNO DESC;        -- → DESC → 내림차순 정렬 → 생략 불가~!!!
--==>>
/*
BLAKE	30	MANAGER	    2850	34200
TURNER	30	SALESMAN	1500	18000
ALLEN	30	SALESMAN	1600	19500
MARTIN	30	SALESMAN	1250	16400
WARD	30	SALESMAN	1250	15500
JAMES	30	CLERK	    950	    11400
SCOTT	20	ANALYST	    3000	36000
JONES	20	MANAGER	    2975	35700
SMITH	20	CLERK	    800	    9600
ADAMS	20	CLERK	    1100	13200
FORD	20	ANALYST	    3000	36000
KING	10	PRESIDENT	5000	60000
MILLER	10	CLERK	    1300	15600
CLARK	10	MANAGER	    2450	29400
*/

-- DESC 자료형 확인 과 내림차순 키워드 같음
-- 하나의 키워드로 두가지 기능 할 수 있음!

SELECT ENAME "사원명",DEPTNO "부서번호", JOB "직종" , SAL "급여"
        , SAL*12+NVL(COMM,0) "연봉"
FROM TBL_EMP
ORDER BY 연봉 DESC;
--> 이렇게 쓰는 거 가능하다! 왜냐면 파싱순서가 SELECT가 먼저되기 때문에!
--==>>
/*
KING	10	PRESIDENT	5000	60000
FORD	20	ANALYST	    3000	36000
SCOTT	20	ANALYST	    3000	36000
JONES	20	MANAGER	    2975	35700
BLAKE	30	MANAGER	    2850	34200
CLARK	10	MANAGER	    2450	29400
ALLEN	30	SALESMAN	1600	19500
TURNER	30	SALESMAN	1500	18000
MARTIN	30	SALESMAN	1250	16400
MILLER	10	CLERK	    1300	15600
WARD	30	SALESMAN	1250	15500
ADAMS	20	CLERK	    1100	13200
JAMES	30	CLERK	    950	    11400
SMITH	20	CLERK	    800	    9600
*/
--> ORDER BY 절보다 SELECT 절이 먼저 처리되기 대문에
--  컬럼명 대신 SELECT 절에서 사용한 ALIAS(별칭)을
--  ORDER BY 절에서 사용해도 문제가 발생하지 않는다.(가능하다.)

SELECT ENAME "사원명",DEPTNO "부서 번호", JOB "직종" , SAL "급여"
        , SAL*12+NVL(COMM,0) "연봉"
FROM TBL_EMP
ORDER BY 부서 번호 DESC;
--==>> 에러 발생
/*
ORA-00933: SQL command not properly ended
00933. 00000 -  "SQL command not properly ended"
*Cause:    
*Action:
804행, 121열에서 오류 발생
*/

SELECT ENAME "사원명",DEPTNO "부서 번호", JOB "직종" , SAL "급여"
        , SAL*12+NVL(COMM,0) "연봉"
FROM TBL_EMP
ORDER BY "부서 번호" DESC;
--==>>
/*
BLAKE	30	MANAGER	    2850	34200
TURNER	30	SALESMAN	1500	18000
ALLEN	30	SALESMAN	1600	19500
MARTIN	30	SALESMAN	1250	16400
WARD	30	SALESMAN	1250	15500
JAMES	30	CLERK	    950	    11400
SCOTT	20	ANALYST	    3000	36000
JONES	20	MANAGER	    2975	35700
SMITH	20	CLERK	    800	    9600
ADAMS	20	CLERK	    1100	13200
FORD	20	ANALYST	    3000	36000
KING	10	PRESIDENT	5000	60000
MILLER	10	CLERK	    1300	15600
CLARK	10	MANAGER	    2450	29400
*/

SELECT ENAME "사원명",DEPTNO "부서 번호", JOB "직종" , SAL "급여"
        , SAL*12+NVL(COMM,0) "연봉"
FROM TBL_EMP
ORDER BY 2;
-- 숫자 2 는 두 번째 컬럼(원본 컬럼이 아닌 SELECT한 두 번째 컬럼)
-- 부서번호를 기준으로 정렬
--==>>
/*
CLARK	10	MANAGER	    2450	29400
KING	10	PRESIDENT	5000	60000
MILLER	10	CLERK	    1300	15600
JONES	20	MANAGER	    2975	35700
FORD	20	ANALYST	    3000	36000
ADAMS	20	CLERK	    1100	13200
SMITH	20	CLERK	    800	    9600
SCOTT	20	ANALYST	    3000	36000
WARD	30	SALESMAN	1250	15500
TURNER	30	SALESMAN	1500	18000
ALLEN	30	SALESMAN	1600	19500
JAMES	30	CLERK	    950	    11400
BLAKE	30	MANAGER	    2850	34200
MARTIN	30	SALESMAN	1250	16400
*/
--> TBL_EMP 테이블이 갖고 있는 테이블의 고유한 컬럼 순서가 아니라
--  SELECT 처리되는 두 번째 컬럼(즉, DEPTNO)을 기준으로 정렬되는 것을 확인
--  ASC 생략된 상태 → 오름차순 정렬되는 것을 확인
--  또한, 인덱스는 1부터...

SELECT *
FROM TBL_EMP;

SELECT ENAME, DEPTNO, JOB, SAL
FROM TBL_EMP
ORDER BY 2,4;       -- 2 → DEPTNO 기준 1차 정렬, 4 → SAL 기준 2차 정렬 ... ASC
--==>>
/*
MILLER	10	CLERK	    1300
CLARK	10	MANAGER	    2450
KING	10	PRESIDENT	5000
SMITH	20	CLERK	    800
ADAMS	20	CLERK	    1100
JONES	20	MANAGER	    2975
SCOTT	20	ANALYST	    3000
FORD	20	ANALYST	    3000
JAMES	30	CLERK	    950
MARTIN	30	SALESMAN	1250
WARD	30	SALESMAN	1250
TURNER	30	SALESMAN	1500
ALLEN	30	SALESMAN	1600
BLAKE	30	MANAGER	    2850
*/

SELECT ENAME, DEPTNO, JOB, SAL
FROM TBL_EMP
ORDER BY 2, 3, 4 DESC;      -- 2 ASC, 3 ASC, 4 DESC
--> ① 2 → DEPTNO(부서번호) 기준 오름차순 정렬
--  ② 3 → JOB(직종명) 기준 오름차순 정렬
--  ③ 3 → SAL(급여) 기준 내림차순 정렬
--  (3차 정렬 수행)
--==>>
/*
MILLER	10	CLERK	    1300
CLARK	10	MANAGER	    2450
KING	10	PRESIDENT	5000
SCOTT	20	ANALYST	    3000
FORD	20	ANALYST	    3000
ADAMS	20	CLERK	    1100
SMITH	20	CLERK	    800
JONES	20	MANAGER	    2975
JAMES	30	CLERK	    950
BLAKE	30	MANAGER	    2850
ALLEN	30	SALESMAN	1600
TURNER	30	SALESMAN	1500
MARTIN	30	SALESMAN	1250
WARD	30	SALESMAN	1250
*/
--> 어? 근데 왜 급여 내림차순 아닌가? →JOB 에서 정렬이 끝났기 때문!
--  JOB 이 같은거 보면 내림차순 정렬됨!

--------------------------------------------------------------------------------

--○ CONCAT() → 문자열 결합 함수
SELECT '손범석' || '이찬호' "1"
      ,CONCAT('손범석','이찬호') "2"
FROM DUAL;
--==>> 손범석이찬호	손범석이찬호

SELECT ENAME || JOB "1"
      ,CONCAT(ENAME,JOB) "2"
FROM TBL_EMP;
--==>>
/*
SMITHCLERK	    SMITHCLERK
ALLENSALESMAN	ALLENSALESMAN
WARDSALESMAN	WARDSALESMAN
JONESMANAGER	JONESMANAGER
MARTINSALESMAN	MARTINSALESMAN
BLAKEMANAGER	BLAKEMANAGER
CLARKMANAGER	CLARKMANAGER
SCOTTANALYST	SCOTTANALYST
KINGPRESIDENT	KINGPRESIDENT
TURNERSALESMAN	TURNERSALESMAN
ADAMSCLERK	    ADAMSCLERK
JAMESCLERK	    JAMESCLERK
FORDANALYST	    FORDANALYST
MILLERCLERK	    MILLERCLERK
*/

SELECT ENAME || JOB ||DEPTNO "1"
    , CONCAT(ENAME,JOB,DEPTNO) "2"
FROM TBL_EMP;
--==>>
/*
ORA-00909: invalid number of arguments
00909. 00000 -  "invalid number of arguments"
*Cause:    
*Action:
948행, 7열에서 오류 발생
*/
--> CONCAT() 함수는 2개의 문자열을 결합시켜주는    기능을 가진 함수.
--  오로지 2개만 결합시킬 수 있다.

-- 중첩시도1
SELECT ENAME || JOB || DEPTNO "1"
    , CONCAT(ENAME,CONCAT(JOB,DEPTNO)) "2"
FROM TBL_EMP;
-- 중첩시도2    
SELECT ENAME || JOB || DEPTNO "1"
    , CONCAT(CONCAT(ENAME,JOB),DEPTNO) "2"
FROM TBL_EMP;

--==>>
/*
SMITHCLERK20	    SMITHCLERK20
ALLENSALESMAN30 	ALLENSALESMAN30
WARDSALESMAN30	    WARDSALESMAN30
JONESMANAGER20	    JONESMANAGER20
MARTINSALESMAN30	MARTINSALESMAN30
BLAKEMANAGER30	    BLAKEMANAGER30
CLARKMANAGER10	    CLARKMANAGER10
SCOTTANALYST20	    SCOTTANALYST20
KINGPRESIDENT10 	KINGPRESIDENT10
TURNERSALESMAN30	TURNERSALESMAN30
ADAMSCLERK20	    ADAMSCLERK20
JAMESCLERK30	    JAMESCLERK30
FORDANALYST20	    FORDANALYST20
MILLERCLERK10	    MILLERCLERK10
*/
--> 내부적인 형 변환이 일어나며 결합을 수행하게 된다.
--  CONCAT() 은 문자열과 문자열을 결합시켜주는 역할을 수행하는 함수이지만
--  내부적으로는 숫자나 날짜를 문자 타입으로 바꾸어주는 과정이 포함되어 있다.

-- JAVA의 String.substring()
/*
    obj.substring()
    ---
     ↓
    문자열.substring(n,m);
                     ----
                     n부터 m-1까지... 문자열 추출(0부터 시작하는 인덱스 기준)
*/

--○ 썹스트링 SUBSTR() 갯수 기반 / SUBSTRB() 바이트 기반 → 문자열 추출 함수
--   자바랑 오라클 개념이 다름!!!
--   많이 사용하니까 기억해두자!★
SELECT ENAME "1"
    , SUBSTR(ENAME, 1, 2) "2"
    , SUBSTR(ENAME, 2, 2) "3"
    , SUBSTR(ENAME, 2) "5"
--                  -- --
--                  ↓  ↓
--              인덱스  갯수
FROM TBL_EMP;
--> 문자열을 추출하는 기능을 가진 함수
--  첫 번째 파라미터 값은 대상 문자열(문자열 추출의 대상)
--  두 번째 파라미터 값은 추출을 시작하는 위치(단, 인덱스는 1부터 시작)
--  세 번째 파라미터 값은 추출할 문자열의 갯수(생략 시... 시작위치부터 끝까지)
--==>>
/*
SMITH	SM	MI	MITH
ALLEN	AL	LL	LLEN
WARD	WA	AR	ARD
JONES	JO	ON	ONES
MARTIN	MA	AR	ARTIN
BLAKE	BL	LA	LAKE
CLARK	CL	LA	LARK
SCOTT	SC	CO	COTT
KING	KI	IN	ING
TURNER	TU	UR	URNER
ADAMS	AD	DA	DAMS
JAMES	JA	AM	AMES
FORD	FO	OR	ORD
MILLER	MI	IL	ILLER
*/

--○ TBL_SAWON 테이블에서 성별이 남성인 사원만
-- 사원번호, 사원명, 주민번호, 급여 항목을 조회한다.
-- 단, SUBSTR() 함수를 사용할 수 있도록 하며
-- 급여 기준으로 내림차순 정렬을 수행할 수 있도록 한다.
SELECT SANO , SANAME , JUBUN, SAL
FROM TBL_SAWON
WHERE SUBSTR(JUBUN,7,1) = '1'   -- 문자열 처리하는 함수이기 때문에 ''
   OR SUBSTR(JUBUN,7,1) = '3'
ORDER BY SAL DESC;
--==>>
/*
1012	남진	8009011234567	4000
1009	선동열	7209301234567	3000
1013	남궁현	8203051234567	3000
1014	남도일	9208091234567	3000
1015	김남길	0202023234567	2000
1006	이이경	0202023234567	2000
*/

SELECT SANO "사원번호", SANAME "사원명", JUBUN"주민번호", SAL"급여"
FROM TBL_SAWON
WHERE SUBSTR(JUBUN,7,1) IN ('1','3')
ORDER BY 급여 DESC;
-- ORDER BY 다음에는 SAL, 급여, 4 다 괜찮!
--==>>
/*
1012	남진	8009011234567	4000
1009	선동열	7209301234567	3000
1013	남궁현	8203051234567	3000
1014	남도일	9208091234567	3000
1015	김남길	0202023234567	2000
1006	이이경	0202023234567	2000
*/

SELECT *
FROM TBL_SAWON;

--○ LENGTH() 글자 수 / LENGTHB() 바이트 수
--   바이트 수를 반환받을 경우에는 인코딩 방식에 유의할 것~!!!
SELECT ENAME "1"
    , LENGTH(ENAME) "2"
    , LENGTHB(ENAME) "3"
FROM TBL_EMP;
--==>>
/*
SMITH	5	5
ALLEN	5	5
WARD	4	4
JONES	5	5
MARTIN	6	6
BLAKE	5	5
CLARK	5	5
SCOTT	5	5
KING	4	4
TURNER	6	6
ADAMS	5	5
JAMES	5	5
FORD	4	4
MILLER	6	6
*/

SELECT SANAME "1"
    , LENGTH(SANAME) "2"
    , LENGTHB(SANAME) "3"
FROM TBL_SAWON;
--==>>
/*
김소연	    3	9
이다영	    3	9
이지영	    3	9
손다정	    3	9
이하이	    3	9
이이경	    3	9
김이나	    3	9
아이유	    3	9
선동열	    3	9
선우용녀	4	12
선우선	    3	9
남진	    2	6
남궁현	    3	9
남도일	    3	9
김남길	    3	9
*/

--※ 데이터 베이스 파라미터 설정 정보 조회 쿼리문 조회
SELECT *
FROM NLS_DATABASE_PARAMETERS;

--○ INSTR()
SELECT 'ORACLE ORAHOME BIORA' "1"
     , INSTR('ORACLE ORAHOME BIORA','ORA',1,1) "2"
     , INSTR('ORACLE ORAHOME BIORA','ORA',1,2) "3"
     , INSTR('ORACLE ORAHOME BIORA','ORA',2,1) "4"
     , INSTR('ORACLE ORAHOME BIORA','ORA',2) "5"
     , INSTR('ORACLE ORAHOME BIORA','ORA',2,3) "6"
     , INSTR('ORACLE ORAHOME BIORA','PPP',1,1) "7"
FROM DUAL;
--==>> ORACLE ORAHOME BIORA	1	8	8	8	0	0
--> 첫 번째 파라미터 값에 해당하는 문자열에서...(대상 문자열)
--  두 번째 파라미터 값을 통해 넘겨준 문자열이 등장하는 위치를 찾아라~!!!
--  세 번째 파라미터 값은 찾기 시작하는...(즉, 스캔을 시작하는) 위치
--  네 번째 파라미터 값은 몇 번째 등장하는 값을 찾을 것인지에 대한 설정(1은 생략 가능)

SELECT '나의오라클 집으로오라 합니다' "1"
     , INSTR('나의오라클 집으로오라 합니다','오라',1) "2"
     , INSTR('나의오라클 집으로오라 합니다','오라',2) "3"
     , INSTR('나의오라클 집으로오라 합니다','오라',10) "4"
     , INSTR('나의오라클 집으로오라 합니다','오라',11) "5"
FROM DUAL;
--==>> 나의오라클 집으로오라 합니다	3	3	10	0
--> 마지막 파라미터(네 번째 파라미터) 값을 생략한 형태로 사용~!!! → 1

--○ REVERSE()
SELECT 'ORACLE' "1"
    , REVERSE('ORACLE') "2"
    , REVERSE('오라클') "3"
FROM DUAL;
--==>> ORACLE	ELCARO	???
--> 대상 문자열을 거꾸로 반환한다.(단, 한글은 제외)

--○ 실습 테이블 생성(TBL_FILES)
CREATE TABLE TBL_FILES
( FILENO    NUMBER(3)
, FILENAME  VARCHAR2(100)
);
--==>> Table TBL_FILES이(가) 생성되었습니다.


--○ 데이터 입력(TBL_FILES)
INSERT INTO TBL_FILES VALUES(1, 'C:\AAA\BBB\CCC\SALES.DOC');
INSERT INTO TBL_FILES VALUES(2, 'C:\AAA\PANMAE.XXLS');
INSERT INTO TBL_FILES VALUES(3, 'D:\RESEARCH.PPT');
INSERT INTO TBL_FILES VALUES(4, 'C:\DOCUMENTS\STUDY.HWP');
INSERT INTO TBL_FILES VALUES(5, 'C:\DOCUMENTS\TEMP\SQL.TXT');
INSERT INTO TBL_FILES VALUES(6, 'D:\SHARE\F\TEST.PNG');
INSERT INTO TBL_FILES VALUES(7, 'C:\USER\GUILDONG\PICTURE\PHOTO\SPRING.JPG');
INSERT INTO TBL_FILES VALUES(8, 'C:\ORACLESTUDY\20210901_01_SCOTT.SQL');
--==>> 1 행 이(가) 삽입되었습니다. * 8


--○ 확인
SELECT *
FROM TBL_FILES;
--==>>
/*

1	C:\AAA\BBB\CCC\SALES.DOC
2	C:\AAA\PANMAE.XXLS
3	D:\RESEARCH.PPT
4	C:\DOCUMENTS\STUDY.HWP
5	C:\DOCUMENTS\TEMP\SQL.TXT
6	D:\SHARE\F\TEST.PNG
7	C:\USER\GUILDONG\PICTURE\PHOTO\SPRING.JPG
8	C:\ORACLESTUDY\20210901_01_SCOTT.SQL
*/

--○ 커밋
COMMIT;
--==>> 커밋 완료.


SELECT FILENO "파일번호", FILENAME "파일명"
FROM TBL_FILES;
/*
1	C:\AAA\BBB\CCC\SALES.DOC
2	C:\AAA\PANMAE.XXLS
3	D:\RESEARCH.PPT
4	C:\DOCUMENTS\STUDY.HWP
5	C:\DOCUMENTS\TEMP\SQL.TXT
6	D:\SHARE\F\TEST.PNG
7	C:\USER\GUILDONG\PICTURE\PHOTO\SPRING.JPG
8	C:\ORACLESTUDY\20210901_01_SCOTT.SQL
*/



/*

  파일번호 파일명                                                                                                 
---------- ------------------------------------------
         1 C:\AAA\BBB\CCC\SALES.DOC                                                                            
         2 C:\AAA\PANMAE.XXLS                                                                                  
         3 D:\RESEARCH.PPT                                                                                     
         4 C:\DOCUMENTS\STUDY.HWP                                                                              
         5 C:\DOCUMENTS\TEMP\SQL.TXT                                                                           
         6 D:\SHARE\F\TEST.PNG                                                                                 
         7 C:\USER\GUILDONG\PICTURE\PHOTO\SPRING.JPG                                                           
         8 C:\ORACLESTUDY\20210901_01_SCOTT.SQL    
*/
--○ TBL_FILES 테이블을 대상으로 위와 같이 조회될 수 있도록
--   쿼리문을 구성한다.
SELECT FILENO "파일번호", FILENAME "경로포함 파일명", SUBSTR(FILENAME,16,9) "파일명"
FROM TBL_FILES
WHERE FILENO=1;
--==>> 1	C:\AAA\BBB\CCC\SALES.DOC	SALES.DOC

SELECT FILENO "파일번호", FILENAME "경로포함 파일명", SUBSTR(FILENAME,16,9) "파일명"
FROM TBL_FILES;
--==>>
/*
1	C:\AAA\BBB\CCC\SALES.DOC	SALES.DOC
2	C:\AAA\PANMAE.XXLS	XLS
3	D:\RESEARCH.PPT	
4	C:\DOCUMENTS\STUDY.HWP	UDY.HWP
5	C:\DOCUMENTS\TEMP\SQL.TXT	MP\SQL.TX
6	D:\SHARE\F\TEST.PNG	.PNG
7	C:\USER\GUILDONG\PICTURE\PHOTO\SPRING.JPG	G\PICTURE
8	C:\ORACLESTUDY\20210901_01_SCOTT.SQL	20210901_
*/

SELECT FILENO "파일번호", FILENAME "경로포함파일명", REVERSE(FILENAME) "거꾸로"
FROM TBL_FILES;
/*
COD.SELAS               \CCC\BBB\AAA\:C
SLXX.EAMNAP             \AAA\:C
TPP.HCRAESER            \:D
PWH.YDUTS               \STNEMUCOD\:C
TXT.LQS                 \PMET\STNEMUCOD\:C
GNP.TSET                \F\ERAHS\:D
GPJ.GNIRPS              \OTOHP\ERUTCIP\GNODLIUG\RESU\:C
LQS.TTOCS_10_10901202   \YDUTSELCARO\:C
*/

-- 뒤집에서 동일한 조건으로 자르고 다시 뒤집으면 됨!
SELECT REVERSE(FILENAME) ,INSTR(REVERSE(FILENAME),'\',1,1), SUBSTR(REVERSE(FILENAME),1,INSTR(REVERSE(FILENAME),'\',1,1)-1)
    , REVERSE(SUBSTR(REVERSE(FILENAME),1,INSTR(REVERSE(FILENAME),'\',1,1)-1))
FROM TBL_FILES;
--==>> 풀이중..1
/*
COD.SELAS\CCC\BBB\AAA\:C	                10	COD.SELAS	                SALES.DOC
SLXX.EAMNAP\AAA\:C	                        12	SLXX.EAMNAP	                PANMAE.XXLS
TPP.HCRAESER\:D	                            13	TPP.HCRAESER	            RESEARCH.PPT
PWH.YDUTS\STNEMUCOD\:C	                    10	PWH.YDUTS	                STUDY.HWP
TXT.LQS\PMET\STNEMUCOD\:C	                8	TXT.LQS	                    SQL.TXT
GNP.TSET\F\ERAHS\:D	                        9	GNP.TSET	                TEST.PNG
GPJ.GNIRPS\OTOHP\ERUTCIP\GNODLIUG\RESU\:C	11	GPJ.GNIRPS	                SPRING.JPG
LQS.TTOCS_10_10901202\YDUTSELCARO\:C	    22	LQS.TTOCS_10_10901202	    20210901_01_SCOTT.SQL
*/

SELECT FILENO "파일번호", REVERSE(SUBSTR(REVERSE(FILENAME),1,INSTR(REVERSE(FILENAME),'\',1,1)-1))
FROM TBL_FILES;
--==>> 풀이중..2
/*
1	SALES.DOC
2	PANMAE.XXLS
3	RESEARCH.PPT
4	STUDY.HWP
5	SQL.TXT
6	TEST.PNG
7	SPRING.JPG
8	20210901_01_SCOTT.SQL
*/


SELECT FILENO "파일번호", SUBSTR( FILENAME, INSTR(FILENAME,'\',-1)+1)
FROM TBL_FILES;
--==>> 풀이중..3
/*
1	SALES.DOC
2	PANMAE.XXLS
3	RESEARCH.PPT
4	STUDY.HWP
5	SQL.TXT
6	TEST.PNG
7	SPRING.JPG
8	20210901_01_SCOTT.SQL
*/

SELECT *
FROM TBL_FILES;



















