--○ 접속된 사용자 조회
SELECT USER
FROM DUAL;
--==>> SCOTT


--○ 테이블 생성(DEPT(라는 이름을 가진))
CREATE TABLE DEPT
( DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY
, DNAME VARCHAR2(14)
, LOC VARCHAR2(13) 
) ;
--==>> Table DEPT이(가) 생성되었습니다.

--○ 테이블 생성(EMP)
CREATE TABLE EMP
( EMPNO NUMBER(4) CONSTRAINT PK_EMP PRIMARY KEY
, ENAME VARCHAR2(10)
, JOB VARCHAR2(9)
, MGR NUMBER(4)
, HIREDATE DATE
, SAL NUMBER(7,2)
, COMM NUMBER(7,2)
, DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT
);
--==>> Table EMP이(가) 생성되었습니다.


--○ 데이터 입력(DEPT)
INSERT INTO DEPT VALUES	(10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES	(30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES	(40,'OPERATIONS','BOSTON');
--==>> 1 행 이(가) 삽입되었습니다. * 4

--○ 데이터 입력(EMP)
INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMP VALUES
(7499,'ALLEN','SALESMAN',7698,to_date('20-2-1981','dd-mm-yyyy'),1600,300,30);
INSERT INTO EMP VALUES
(7521,'WARD','SALESMAN',7698,to_date('22-2-1981','dd-mm-yyyy'),1250,500,30);
INSERT INTO EMP VALUES
(7566,'JONES','MANAGER',7839,to_date('2-4-1981','dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMP VALUES
(7654,'MARTIN','SALESMAN',7698,to_date('28-9-1981','dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMP VALUES
(7698,'BLAKE','MANAGER',7839,to_date('1-5-1981','dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMP VALUES
(7782,'CLARK','MANAGER',7839,to_date('9-6-1981','dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',7566,to_date('13-7-1987','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7839,'KING','PRESIDENT',NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMP VALUES
(7844,'TURNER','SALESMAN',7698,to_date('8-9-1981','dd-mm-yyyy'),1500,0,30);
INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',7788,to_date('13-7-1987','dd-mm-yyyy'),1100,NULL,20);
INSERT INTO EMP VALUES
(7900,'JAMES','CLERK',7698,to_date('3-12-1981','dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMP VALUES
(7902,'FORD','ANALYST',7566,to_date('3-12-1981','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7934,'MILLER','CLERK',7782,to_date('23-1-1982','dd-mm-yyyy'),1300,NULL,10);
--==>> 1 행 이(가) 삽입되었습니다. * 14



--○ 테이블 생성(BONUS)
CREATE TABLE BONUS
( ENAME VARCHAR2(10)
, JOB VARCHAR2(9)
, SAL NUMBER
, COMM NUMBER
) ;
--==>> Table BONUS이(가) 생성되었습니다.

--○ 테이블 생성(SALGRADE)
CREATE TABLE SALGRADE
( GRADE NUMBER
, LOSAL NUMBER
, HISAL NUMBER 
);
--==>> Table SALGRADE이(가) 생성되었습니다.

--○ 데이터 입력(SALGRADE)
INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);
--==>> 1 행 이(가) 삽입되었습니다. * 5


--○ 커밋
COMMIT;
--==>> 커밋 완료.

--------------------------------------------------------------------------------

--○  현재 접속한 SCOTT 오라클 계정 사용자가 소유하고 있는 테이블 조회
SELECT *
FROM TAB;   --테이블을 줄여서 TAB
--==>>
/*
BONUS	    TABLE	
DEPT	    TABLE	
EMP	        TABLE	
SALGRADE	TABLE	
*/

--○  어떤 테이블스페이스에 저장되어 있는지 조회
SELECT TABLE_NAME, tablespace_name
FROM USER_TABLES;
--==>>
/*
DEPT	    USERS
EMP	        USERS
BONUS	    USERS
SALGRADE	USERS
*/

--○ 테이블 생성(TBL_EXAMPLE1)
CREATE TABLE TBL_EXAMPLE1
(NO     NUMBER
,NAME   VARCHAR2(10)
,ADDR   VARCHAR2(20)
);
--==>> Table TBL_EXAMPLE1이(가) 생성되었습니다.

--○ 테이블 생성(TBL_EXAMPLE2)
CREATE TABLE TBL_EXAMPLE2
(NO     NUMBER
,NAME   VARCHAR2(10)
,ADDR   VARCHAR(20)
)TABLESPACE TBS_EDUA;   --어떤 테이블에 만들어줄지 명시하면 명시한 곳에 생성
--==>> Table TBL_EXAMPLE2이(가) 생성되었습니다.

--○ TBL_EXAMPLE1 과 TBL_EXAMPLE2 테이블이
--   어떤 테이블스페이스에 저장되어 있는지 조회
SELECT TABLE_NAME, TABLESPACE_NAME
FROM USER_TABLES;
--==>>
/*
DEPT	        USERS
EMP	            USERS
BONUS	        USERS
SALGRADE	    USERS
TBL_EXAMPLE1	USERS
TBL_EXAMPLE2	TBS_EDUA
*/



-- ■■■ 관계형 데이터베이스 ■■■--

-- 데이터를 테이블의 형태로 저장시켜 놓은 것
-- 그리고 이들 각 테이블들 간의 관계를 설정하는 것

/*===========================================================
    ★★★ SELECT 문의 처리(PARSING)순서 ★★★(암기하세요!)
    
    SELECT 컬럼명          --⑤
    FROM 테이블명          --① 
    WHERE 조건절           --②
    GROUP BY 절            --③
    HAVING 조건절          --④
    ORDER BY 절            --⑥
    
============================================================*/

--○ 현재 접속된 오라클 사용자(SCOTT) 소유의
--   테이블(TABLE), 뷰(VIEW)의 목록을 조회
SELECT * 
FROM TAB;
--==>>
/*
BONUS	        TABLE	    → 보너스 테이블
DEPT	        TABLE	    → DEPARTMENTS(부서)테이블
EMP	            TABLE	    → EMPLOYEES(사원) 테이블
SALGRADE	    TABLE	    → 급여(SAL)의 등급 테이블
TBL_EXAMPLE1	TABLE	   
TBL_EXAMPLE2	TABLE	   
*/

--○ 각 테이블의 데이터 조회
SELECT *
FROM BONUS;
--==>> 조회결과 없음(데이터가 존재하지 않음)

SELECT *
FROM DEPT;
--==>>
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
*/

SELECT *
FROM EMP;
--==>>
/*
7369	SMITH	CLERK	    7902	80/12/17	800		    20
7499	ALLEN	SALESMAN	7698	81/02/20	1600	300	30
7521	WARD	SALESMAN	7698	81/02/22	1250	500	30
7566	JONES	MANAGER	    7839	81/04/02	2975		20
7654	MARTIN	SALESMAN	7698	81/09/28	1250   1400	30
7698	BLAKE	MANAGER	    7839	81/05/01	2850		30
7782	CLARK	MANAGER	    7839	81/06/09	2450		10
7788	SCOTT	ANALYST	    7566	87/07/13	3000		20
7839	KING	PRESIDENT		    81/11/17	5000		10
7844	TURNER	SALESMAN	7698	81/09/08	1500	0	30
7876	ADAMS	CLERK	    7788	87/07/13	1100		20
7900	JAMES	CLERK	    7698	81/12/03	950		    30
7902	FORD	ANALYST	    7566	81/12/03	3000		20
7934	MILLER	CLERK	    7782	82/01/23	1300		10
*/

SELECT *
FROM SALGRADE;
--==>>
/*
1	700	    1200
2	1201	1400
3	1401	2000
4	2001	3000
5	3001	9999
*/


--○ DEPT 테이블에 존재하는 컬럼의 정보(구조) 조회
DESCRIBE DEPT;
--==>>
/*
이름     널?       유형           -- 널? : 널이어도 되나? → 필수입력이니 아니니를 의미   
------ -------- ------------ 
DEPTNO NOT NULL NUMBER(2)         -- 필수입력
DNAME           VARCHAR2(14) 
LOC             VARCHAR2(13) 
*/

--※ 우리가 흔히 웹 사이트에서 회원 가입을 수행할 경우
--   필수 입력 사항과 선택 입력 사항이 있다.
--   필수 입력 항목은 ID, PW, 성명, 주민번호, 전화번호, 주소,...
--   등과 같은 컬럼이며, 이 값들은 회원 가입 절차에 따라
--   반드시 필요한(존재해야 하는, 입력해야 하는) 값이므로 NOT NULL 로 한다.

--   선택 입력 항목은 취미, 결혼여부, 차량소유여부, 특기, ...
--   등과 같은 컬럼이며, 이 값들은 회원가입 과정에서
--   반드시 필요한 값이 아니므로(즉, 입력하지 않아도 무방하므로)
--   NULL 이어도 상관없는 상황이 된다.

--   DEPTNO         DNAME           LOC
--   부서번호       부서명          부서위치
--   NOT NULL       (NULL 허용)     (NULL 허용) 

--EX)               인사부          서울         → 데이터 입력 불가
--      80                          인천         → 데이터 입력 가능
--      90                                       → 데이터 입력 가능    


--■■■ 오라클의 주요 자료형(DATA TYPE) ■■■--
/*
cf) MSSQL 서버의 정수 표현 타입
    tinyint     0 ~ 255             1byte
    smallint    -32,768 ~ 32767     2byte
    int         -21억 ~ 21억        4byte
    bigint      엄청 큼             8byte
    
    MSSQL 서버의 실수 표현 타입
    float, real

    MSSQL 서버의 숫자 표현 타입
    decimal, numeric
    
    MSSQL 서버의 문자 표현 타입
    char, varchar, Nvarchar
*/

--※ ORACLE 서버는 숫자 표현 타입이 한 가지로 통일되어 있다.
/*
1. 숫자형 NUMBER       → -10의 38승-1 ~ 10의 38승(17승이 경, 엄청나게 큰 숫자)
          NUMBER(3)       → -999 ~ 999         (괄호안에 숫자는 바이트, 숫자는 한글자에 1바이트라 글자수라고 해도 무방)
          NUMBER(4)       → -9999 ~ 9999
          NUMBER(4,1)       → -999.9 ~ 999.9   (소수점 표현)
*/

--※ ORACLE 서버의 문자 표현 타입
--   CHAR, NCHAR, VARCHAR2, NVARCHAR2       (N이 붙어있는 아이들은 유니코드라 글자수로 생각 / N이 안붙어있는 아이들은 바이트로 생각)
--                                          (그냥 CHAR는 문자열이고 VARCHAR는 가변형 문자열)
--                                          (자바에서는 문자와 문자열을 엄격히 구분하지만 오라클에서는 전부 문자열 대신 뒤에붙은 숫자 길이를 통해 구분)

/*
2. 문자형 CHAR          - 고정형 크기
          CHAR(10)  ←  '강의실'       6Byte 이지만 10Byte 를 소모
          CHAR(10)  ←  '졸린서효진'  10Byte
          CHAR(10)  ←  'OH집중서효진'12Byte 10Byte 를 초과하므로 입력 불가(영어는 1Byte)
          
          VARCHAR2      - 가변형 크기
          VARCHAR2(10)  ←  '강의실'        6Byte만 차지
          VARCHAR2(10)  ←  '잠깬서효진'   10Byte만 차지
          VARCHAR2(10)  ←  'OH잠갠서효진' 10Byte 를 초과하므로 입력 불가
          
          NCHAR         - 유니코드 기반 고정형 크기(글자수
          NCHAR(10)    ← 10 글자
          
          NVARCHAR2     - 유니코드 기반 가변형 크기(글자수)
          NVARCHAR2(1) ← 10 글자
          
          + 가변형이 더 많이 쓰일꺼같지만 상황에따라 고정되어있는 주민번호 같은것들은 고정형으로 사용하는 것이 좋다!
*/

/*
3. 날짜형 DATE
*/
SELECT SYSDATE
FROM DUAL;
--==>> 21/08/26

SELECT HIREDATE
FROM EMP;
--==>>
/*
80/12/17
81/02/20
81/02/22
81/04/02
81/09/28
81/05/01
81/06/09
87/07/13
81/11/17
81/09/08
87/07/13
81/12/03
81/12/03
82/01/23
*/

--※ 날짜형식에 대한 세션 설정 변경 (오라클 껐다키면 다시 초기화 원래그래)
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
--==>> Session이(가) 변경되었습니다.

SELECT SYSDATE
FROM DUAL;
--==>> 2021-08-26 17:29:46

SELECT HIREDATE
FROM EMP;
--==>>
/*
1980-12-17 00:00:00
1981-02-20 00:00:00
1981-02-22 00:00:00
1981-04-02 00:00:00
1981-09-28 00:00:00
1981-05-01 00:00:00
1981-06-09 00:00:00
1987-07-13 00:00:00
1981-11-17 00:00:00
1981-09-08 00:00:00
1987-07-13 00:00:00
1981-12-03 00:00:00
1981-12-03 00:00:00
1982-01-23 00:00:00
*/


--○ EMP 테이블에서 사원번호, 사원명, 급여, 커미션 항목만 조회
--   일단 컬럼명을 모르니까 전부 조회 후 검색
SELECT *
FROM EMP;

SELECT EMPNO, ENAME, SAL, COMM
FROM EMP;
--==>>
/*
7369	SMITH	800	
7499	ALLEN	1600	300
7521	WARD	1250	500
7566	JONES	2975	
7654	MARTIN	1250	1400
7698	BLAKE	2850	
7782	CLARK	2450	
7788	SCOTT	3000	
7839	KING	5000	
7844	TURNER	1500	0
7876	ADAMS	1100	
7900	JAMES	950	
7902	FORD	3000	
7934	MILLER	1300	
*/

--○ EMP 테이블에서 부서번호가 20번인 직원들의 정보 중
--   사원번호, 사원명, 직종명, 급여, 부서번호 조회
SELECT EMPNO, ENAME, JOB, SAL, DEPTNO WHERE DEPTNO = 20
FROM EMP;
--==>> 에러 발생

SELECT EMPNO, ENAME, JOB, SAL, DEPTNO WHERE DEPTNO = '20'
FROM EMP;
--==>> 에러 발생

SELECT EMPNO, ENAME, JOB, SAL, DEPTNO
FROM EMP
WHERE DEPTNO = 20;  --> JAVA에서는 == 이지만 오라클에서는 =
--==>> 
/*
7369	SMITH	CLERK	 800	20
7566	JONES	MANAGER	2975	20
7788	SCOTT	ANALYST	3000	20
7876	ADAMS	CLERK	1100	20
7902	FORD	ANALYST	3000	20
*/

DESCRIBE EMP;
DESC EMP;   -- 위의 구문 줄여쓴 것!


SELECT EMPNO, ENAME, JOB, SAL, DEPTNO
FROM EMP
WHERE DEPTNO = 20;

-- 우리는 한번 조회해서 컬럼명을 알고있지만..
--※ 테이블을 조회하는 과정에서 각 칼럼에 별칭(ALIAS(앨리어스))을 부여할 수 있다.





































