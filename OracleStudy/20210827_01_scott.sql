--○ 접속된 사용자 조회
SELECT USER
FROM DUAL;
--==>> SCOTT

SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE DEPTNO = 20;

--※ 테이블을 조회하는 과정에서 각 컬럼에 별칭(ALIAS)을 부여할 수 있다.
--   별칭을 부여했을 뿐이지 EMPNO로 이름은 그대로 존재한다! AS, "" 생략 가넝한~! 
--   그러나 ""을 생략했을 경우 띄어쓰기나 붙여쓰기를 인식하지 못함
SELECT EMPNO AS "사원번호", ENAME "사원명",JOB 직종, SAL "급  여", DEPTNO"부서번호"
FROM EMP
WHERE DEPTNO = 20;

--※ 테이블 조회 시 사용하는 별칭의 기본 구문은 『AS "별칭명"』의 형태로 작성되며
--   이 때, 『AS』는 생략이 가능하다.
--   또한 『""』도 생략 가능하다.
--   하지만, 『""』를 생략할 경우 별칭명에 고백은 사용할 수 없다.
--   공백은 해당 컬럼의 종결을 의미하므로 별칭의 이름 내부에 공백을 사용할 경우
--   『""』를 사용하여 별칭을 부여할 수 있도록 처리해야 한다.


--○ EMP 테이블에서 부서번호가 20번과 30번 직원들의 정보 중      -- 과 : ★OR★
--   사원번호, 사원명, 직종명, 급여, 부서번호 항목을 조회한다.
--   단, 별칭(ALIAS)을 사용한다.
/* 틀을 잡고 적자!
SELECT 사원번호, 사원명, 직종명, 급여, 부서번호
FROM EMP
WHERE 부서번호가 20번과 30번;
*/
SELECT EMPNO "사원번호", ENAME 사원명, JOB"직종", SAL 급여, DEPTNO "부서번호"
FROM EMP
WHERE DEPTNO = 20 || DEPTNO =  30;
--==>> 에러 발생


SELECT EMPNO "사원번호", ENAME 사원명, JOB"직종", SAL 급여, DEPTNO "부서번호"
FROM EMP
WHERE DEPTNO = 20 OR DEPTNO =  30;
--==>>
/*
7369	SMITH	CLERK	    800	    20
7499	ALLEN	SALESMAN	1600	30
7521	WARD	SALESMAN	1250	30
7566	JONES	MANAGER	    2975	20
7654	MARTIN	SALESMAN	1250	30
7698	BLAKE	MANAGER	    2850	30
7788	SCOTT	ANALYST	    3000	20
7844	TURNER	SALESMAN	1500	30
7876	ADAMS	CLERK	    1100	20
7900	JAMES	CLERK	    950	    30
7902	FORD	ANALYST	    3000	20
*/

-- IN 연산자
SELECT EMPNO "사원번호", ENAME 사원명, JOB"직종", SAL 급여, DEPTNO "부서번호"
FROM EMP
WHERE DEPTNO IN (20, 30);
--> IN 연산자를 활용하여 이와 같이 처리할 수도 있으며
--  위의 구문과 같은 결과를 반환하게 된다.


--○ EMP 테이블에서 직종이 CLERK 인 사원들의 정보를 모두 조회한다.
SELECT *
FROM EMP
WHERE JOB = CLERK;  --X

SELECT *
FROM EMP
WHERE JOB = 'CLERK';
--==>>
/*
7369	SMITH	CLERK	7902	80/12/17	800		    20
7876	ADAMS	CLERK	7788	87/07/13	1100		20
7900	JAMES	CLERK	7698	81/12/03	950		    30
7934	MILLER	CLERK	7782	82/01/23	1300		10
*/

SeleCT *
froM EMP
WHere jOB = 'CLERK';


SeleCT *
froM EMP
WHere jOB = 'clerk';
--==>> 컬럼명만나오고 아무것도 조회되지 않음!

--※ 오라클에서... 입력된 데이터(값) 만큼은
--   반.드.시. 대소문자 구분을 한다.★★★


--○ EMP 테이블에서 직종이 CLERK 인 사원들 중
--   20번 부서에 근무하는 사원들의
--   사원번호, 사원명, 직종명, 급여, 부서번호 항목을 조회한다.
SELECT EMPNO"사원번호", ENAME"사원명", JOB"직종명", DEPTNO"부서번호"
FROM EMP
WHERE JOB = 'CLERK' AND DEPTNO = 20;
--==>>
/*
7369	SMITH	CLERK	20
7876	ADAMS	CLERK	20
*/

-- WHERE JOB = 'CLERK' AND DEPTNO = '20';   
-- → 이래도 조회가 되는데 이건 오라클이 자동형변환을 해준거지만 믿으면 안됨!!!
DESC EMP;
-- 이거해서 보면 DEPTNO는 숫자형임

--○ EMP 테이블에서 10번 부서에 근무하는 직원들 중
--   급여가 2500 이상인 직원들의
--   사원명, 직종명, 급여, 부서번호 항목을 조회한다.
SELECT 사원명, 직종명, 급여, 부서번호
FROM EMP
WHERE 10번 부서에 근무하고 급여가 2500 이상인 직원;

SELECT ENAME"사원명", JOB"직종명", SAL"급여", DEPTNO"부서번호"
FROM EMP
WHERE DEPTNO = 10 AND SAL >=2500;
--==>>
/*
KING	PRESIDENT	5000	10
*/


--○ 테이블 복사
-->  내부적으로 대상 테이블 안에 있는 데이터 내용만 복사하는 과정

--※ EMP 테이블의 데이터를 확인하여
--   이와 똑같은 데이터가 들어있는 EMPCOPY 테이블을 생성한다. (팀별로...)
SELECT *
FROM EMP;
--==>> 14개의 데이터가 존재

CREATE TABLE 테이블명
( 항목1       데이터타입
, 항목2       데이터타입
);

CREATE TABLE EMPCOPY
(EMPNO NUMBER(4)
, ENAME VARCHAR2(10)
, JOB VARCHAR2(9)
, MGR NUMBER(4)
, HIREDATE DATE
, SAL NUMBER(7,2)
, COMM NUMBER(7,2)
, DEPTNO NUMBER(2)
);

-- 그냥 넣은것
INSERT INTO EMP VALUES(7369,'SMITH','CLERK',7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
--> to_date('17-12-1980','dd-mm-yyyy') 괄호!! 꼭 닫자!!!

-- 이게 정답같음
INSERT INTO EMPCOPY (SELECT * FROM EMP);

SELECT *
FROM EMPCOPY;

CREATE TABLE EMPCOPY2
AS
SELECT *
FROM EMP;

SELECT *
FROM EMPCOPY;
----------의도하신 풀이-----------------
DESC EMP;
--==>>
/*
이름       널?       유형           
-------- -------- ------------ 
EMPNO    NOT NULL NUMBER(4)    
ENAME             VARCHAR2(10) 
JOB               VARCHAR2(9)  
MGR               NUMBER(4)    
HIREDATE          DATE         
SAL               NUMBER(7,2)  
COMM              NUMBER(7,2)  
DEPTNO            NUMBER(2)    
*/
CREATE TABLE EMPCOPY
(EMPNO NUMBER(4)        NUMBER(4)
, ENAME VARCHAR2(10)    VARCHAR2(10) 
, JOB VARCHAR2(9)       VARCHAR2(9)
, MGR NUMBER(4)         NUMBER(4)
, HIREDATE DATE         DATE 
, SAL NUMBER(7,2)       NUMBER(7,2) 
, COMM NUMBER(7,2)      NUMBER(7,2) 
, DEPTNO NUMBER(2)      NUMBER(2)
);

INSERT INTO EMPCOPY(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES(7369,'SMITH','CLERK',7902,'17-12-1980',800,NULL,20);
--이렇게해서 14개 넣어주면 됨!

CREATE TABLE EMPCOPY
AS      --구조에 따라서~
SELECT *
FROM EMP;
--> EMP전체 조회한거에 따라서 EMPCOPY테이블을 만들겠다~ 라는 뜻!
--  가벼운 형태의 복사

-- EMP를 복사한 새로운 EMP2 테이블 생성
CREATE TABLE EMP2
AS
SELECT *
FROM EMP;
--==>> Table EMP2이(가) 생성되었습니다.

DESC EMP2;
-- 데이터 유형 위주의 복사이기 때문에 널? 은 복사 안됨!

--○ 복사한 테이블 확인
SELECT *
FROM EMP2;

--※ 날짜 관련 형식의 세션 정보 설정
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

-- 테이블 없애고 싶을 때
DROP TABLE EMPCOPY;
--==>> Table EMPCOPY이(가) 삭제되었습니다.

DELETE 
FROM EMP2;
--==>> 14개 행 이(가) 삭제되었습니다.
-- 이거는 테이블은 있음

DROP TABLE EMP2;
--==>> Table EMP2이(가) 삭제되었습니다.



--○ 테이블 복사
CREATE TABLE TBL_EMP
AS
SELECT *
FROM EMP;
--==>> Table TBL_EMP이(가) 생성되었습니다.

CREATE TABLE TBL_DEPT
AS
SELECT *
FROM DEPT;
--==>> Table TBL_DEPT이(가) 생성되었습니다.

--○ 복사한 테이블 확인
SELECT *
FROM TBL_EMP;

SELECT *
FROM TBL_DEPT;


--○ 테이블의 커멘트 정보 확인
--   커멘트 == 주석
SELECT *
FROM USER_TAB_COMMENTS;
-- 이 테이블이 어떤 의도로 만들어진 테이블이라는걸 알수 있음!(팀활동할 때)

--○ 테이블의 커멘트 정보 입력
COMMENT ON TABLE TBL_EMP IS '사원정보';
--==>> Comment이(가) 생성되었습니다.

--○ 커멘트 정보 입력 이후 다시 확인
SELECT *
FROM USER_TAB_COMMENTS;
--==>>
/*
TBL_EMP	        TABLE	사원정보
TBL_DEPT	    TABLE	
EMPCOPY2	    TABLE	
TBL_EXAMPLE2	TABLE	
TBL_EXAMPLE1	TABLE	
SALGRADE	    TABLE	
BONUS	        TABLE	
EMP	            TABLE	
DEPT	        TABLE	
*/

--○ 테이블 레벨의 커멘트 정보 입력(TBL_DEPT → 부서정보)
COMMENT ON TABLE TBL_DEPT IS '부서정보';
--==>> Comment이(가) 생성되었습니다.

--○ 커멘트 정보 입력 이후 다시 확인
SELECT *
FROM USER_TAB_COMMENTS;
--==>>
/*
TBL_EMP	        TABLE	사원정보
TBL_DEPT	    TABLE	부서정보
EMPCOPY2	    TABLE	
TBL_EXAMPLE2	TABLE	
TBL_EXAMPLE1	TABLE	
SALGRADE	    TABLE	
BONUS	        TABLE	
EMP	            TABLE	
DEPT	        TABLE	
*/

--○ 컬럼 레벨의 커멘트 정보 확인
SELECT *
FROM USER_COL_COMMENTS;


--※ 휴지통 비우기(DROP 해서 지운건 다 휴지통으로 감) BIN 으로 나오는 애들 다 없어짐!
PURGE RECYCLEBIN;
--==>> RECYCLEBIN이(가) 비워졌습니다.

-- 아까 연습때 만든 EMPCOPY2없애자
DROP TABLE EMPCOPY2;
PURGE RECYCLEBIN;

-- TBL_DEPT 테이블의 커멘트만 조회(조건식 이렇게 활용하자!)
SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'TBL_DEPT';
--==>>
/*
TBL_DEPT	DEPTNO	
TBL_DEPT	DNAME	
TBL_DEPT	LOC	
*/

--○ 테이블에 소속된(포함된) 컬럼 레벨의 커멘트 정보 입력(설정)
/*
아까는 테이블 커멘트이니까 COMMENT ON TABLE 테이블명
지금은 컬럼 커멘트이니까   COMMENT ON COLUMN 컬럼명
테이블이 여러가지이기 때문에 어떤 테이블의 컬럼명인디 명시해주어야 한다.
COMMENT ON COLUMN 서울.정효진
*/
COMMENT ON COLUMN TBL_DEPT.DEPTNO IS '부서번호';
--==>> Comment이(가) 생성되었습니다.
COMMENT ON COLUMN TBL_DEPT.DNAME IS '부서명';
--==>. Comment이(가) 생성되었습니다.
COMMENT ON COLUMN TBL_DEPT.LOC IS '부서위치';
--==>> Comment이(가) 생성되었습니다.

--○ 컬럼 레벨의 커멘트 정보 확인
SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'TBL_DEPT';
--==>>
/*
TBL_DEPT	DEPTNO	부서번호
TBL_DEPT	DNAME	부서명
TBL_DEPT	LOC	    부서위치
*/

DESC TBL_EMP;
/*
이름       널? 유형           
-------- -- ------------ 
EMPNO       NUMBER(4)       -- 사원번호
ENAME       VARCHAR2(10)    -- 사원명
JOB         VARCHAR2(9)     -- 직종명
MGR         NUMBER(4)       -- 관리자 사원번호
HIREDATE    DATE            -- 입사일
SAL         NUMBER(7,2)     -- 급여
COMM        NUMBER(7,2)     -- 수당
DEPTNO      NUMBER(2)       --부서번호
*/

--○ TBL_EMP 테이블에 소속된(포함된)
--   컬럼에 대한 커멘트 정보 입력(설정)
COMMENT ON COLUMN TBL_EMP.EMPNO IS '사원번호';
COMMENT ON COLUMN TBL_EMP.ENAME IS '사원명';
COMMENT ON COLUMN TBL_EMP.JOB IS '직종명';
COMMENT ON COLUMN TBL_EMP.MGR IS '관리자 사원번호';
COMMENT ON COLUMN TBL_EMP.HIREDATE IS '입사일';
COMMENT ON COLUMN TBL_EMP.SAL IS '급여';
COMMENT ON COLUMN TBL_EMP.COMM IS '수당';
COMMENT ON COLUMN TBL_EMP.DEPTNO IS '부서번호';
--==>> Comment이(가) 생성되었습니다. * 8

--○ 커멘트 정보가 입력된 테이블의 컬럼 레벨의 정보 확인
SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'TBL_EMP';
--==>>
/*
TBL_EMP	EMPNO	    사원번호
TBL_EMP	ENAME	    사원명
TBL_EMP	JOB	        직종명
TBL_EMP	MGR	        관리자 사원번호
TBL_EMP	HIREDATE	입사일
TBL_EMP	SAL	        급여
TBL_EMP	COMM	    수당
TBL_EMP	DEPTNO	    부서번호
*/

-- ■■■ 컬럼 구조의 추가 및 제거 ■■■--
SELECT *
FROM TBL_EMP;

--○ TBL_EMP 테이블에 주민등록번호 정보를 담을 수 있는 컬럼 추가
--   구조적인 변경을 하기위해서는 ALTER    
--   INSERT 나 CREATE아님
ALTER TABLE TBL_EMP
ADD SSN CHAR(13);       --주민번호는 항상 13자리 고정이니까 CHAR~
--==>> Table TBL_EMP이(가) 변경되었습니다.
--※ 맨 앞에 0이 들어올 가능성이 있는 숫자가 조합된 데이터라면
--   숫자형이 아닌 문자형으로 데이터타입을 처리해야 한다.      CHECK~!!!

SELECT 9501052234567
FROM DUAL;
--==>> 9501052234567

SELECT 0501052234567
FROM DUAL;
--==>> 501052234567

SELECT '0501052234567'
FROM DUAL;
--==>> 0501052234567

SELECT 01044342587
FROM DUAL;
--==>> 1044342587

SELECT '01044342587'
FROM DUAL;
--==>> 01044342587

------ 이걸 통해서 알수있는 것 : 숫자 앞에 0이 들어가면 안나오니까 전화번호나 주민번호는 '문자열'로!!

DESC TBL_EMP;
/*
이름       널? 유형           
-------- -- ------------ 
EMPNO       NUMBER(4)    
ENAME       VARCHAR2(10) 
JOB         VARCHAR2(9)  
MGR         NUMBER(4)    
HIREDATE    DATE         
SAL         NUMBER(7,2)  
COMM        NUMBER(7,2)  
DEPTNO      NUMBER(2)    
SSN         CHAR(13) 
*/
--> SSN 컬럼이 정상적으로 추가된 상황임을 확인 

SELECT *
FROM TBL_EMP;
--==>> SSN주가된것 확인!
--     테이블 내에서 컬럼의 순서는 구조적으로 의미 없음. 조회할때 내가 원하는 컬럼 먼저 적어서 조회하면 그만
SELECT EMPNO, ENAME, SSN, HIREDATE, SAL, COMM
FROM TBL_EMP;
--     이런식으로!

--○ TBL_EMP 테이블에서 추가한 SSN(주민등록번호) 컬럼 제거
--   주민번호안에 데이터를 지우면 DELETE
--   주민번호안에 구조를 없애려면 DROP
--   여기는 구조를 변경하는거니까 ALTER
--   만들때는 데이터타입을 명시했지만 제거할때는 데이터타입 명시 안해도됨!
--   ADD할때는 COLUMN안붙였었음!! BUT DROP할때는 다른것들이 지워질수 있으므로 COLUMN을 지울꺼야 명시해야함!
ALTER TABLE TBL_EMP
DROP COLUMN SSN;
--==>> Table TBL_EMP이(가) 변경되었습니다.

--○ 확인
SELECT *
FROM TBL_EMP;

DESC TBL_EMP;

--> SSN(주민등록번호) 컬럼이 정상적으로 제거되었음을 확인.


--DELETE 사용할 때! 나중에 계속 할것임 그냥 그렇구나로 알아두기~
/*
SELECT *
FROM TBL_EMP
WHERE ENAME = 'SMITH';
---여기에서 SELECT * 만 블럭잡아서 → DELETE로변경하면 삭제됨
DELETE *
FROM TBL_EMP
WHERE ENAME = 'SMITH';
--- 이런식으로 사용하면 DELETE 실수 안할 수 있음!
*/

DELETE TBL_EMP;  -- 권장하지 않음!!!!

DELETE
FROM TBL_EMP;    -- 권장

--○ 테이블을 구조적으로 삭제(데이터의 내용 뿐 아니라... 테이블 자체를 제거)
DROP TABLE TBL_EMP;
--==>> Table TBL_EMP이(가) 삭제되었습니다.

--○ 확인
SELECT *
FROM TBL_EMP;
--==>> 에러 발생
/*
ORA-00942: table or view does not exist
00942. 00000 -  "table or view does not exist"
*Cause:    
*Action:
497행, 6열에서 오류 발생
*/

--○ 테이블 다시 생성(복사)
CREATE TABLE TBL_EMP
AS
SELECT *
FROM EMP;
--==>> Table TBL_EMP이(가) 생성되었습니다.

--- 테이블을 조회할때도 아래 두줄만 드래그해서 먼저 조회한 다음
/*
SELECT *
FROM EMP;
*/
--- 내가 복사하려는 테이블이 맞나 확인하고! 전체 실행!


-- 여기까지 오전 수업!
--------------------------------------------------------------------------------

--○ NULL 의 처리

SELECT 2, 10+2, 10-2, 10*2, 10/2
FROM DUAL;
--==>> 2	12	    8	20	    5

SELECT NULL, NULL+2, NULL-2, NULL*2, NULL/2, 10+NULL, 10-NULL, 10*NULL, 10/NULL
FROM DUAL;
--==>> 에러 발생하지 않고 결과값이 NULL로 나온다.
--==>> (NULL)(NULL)(NULL)(NULL)(NULL)(NULL)(NULL)(NULL)(NULL)(NULL)

--※ 관찰 결과
--   NULL 은 상태의 값을 의미하며, 실제 존재하지 않는 값이기 때문에
--   이 NULL 이 연산에 포함될 경우... 그 결과는 무조건 NULL이다.

--○ TBL_EMP 테이블에서 커미션(COMM, 수당)이 NULL 인 직원의 
--   사원명, 직종명, 급여, 커미션 항목을 조회한다.
SELECT 사원명, 직종명, 급여, 커미션
FROM TBL_EMP
WHERE 커미션이 NULL;

SELECT ENAME "사원명", JOB "직종명", SAL "급여", COMM "커미션 "
FROM TBL_EMP
WHERE COMM = NULL;
--==>> 에러 발생하기 않고 조회 결과 없음.

SELECT ENAME "사원명", JOB "직종명", SAL "급여", COMM "커미션 "
FROM TBL_EMP
WHERE COMM = (NULL);
--==>> 에러 발생하기 않고 조회 결과 없음.

SELECT ENAME "사원명", JOB "직종명", SAL "급여", COMM "커미션 "
FROM TBL_EMP
WHERE COMM = 'NULL';
--==>> 에러 발생
/*
ORA-01722: invalid number
01722. 00000 -  "invalid number"
*Cause:    The specified number was invalid.
*Action:   Specify a valid number.
*/
DESC TBL_EMP;
-- COMM 컬럼은 숫자형 데이터 타입을 취하고 있음을 확인
-- 이 NUMBER 데이터만 들어가게 해있기 때문에 문자열찾으면 에러남!

--※ NULL 은 실제 존재하지 않는 값이기 때문에 일반적인 연산자를 활용하여 비교할 수 없다.
--   즉, 산술적인 비교 연산을 수행할 수 없다는 의미이다.
--   NULL 을 대상으로 사용할 수 없는 연산자들...
--   >=, <=, >, <, !=, ^=, <> (!=, ^=, <> → 같이 않다)

SELECT ENAME "사원명", JOB "직종명", SAL "급여", COMM "커미션 "
FROM TBL_EMP
WHERE COMM IS NULL;
-- 논리적 연산자 IS 를 사용한다.
--==>>
/*
SMITH	CLERK	    800	
JONES	MANAGER	    2975	
BLAKE	MANAGER	    2850	
CLARK	MANAGER	    2450	
SCOTT	ANALYST	    3000	
KING	PRESIDENT	5000	
ADAMS	CLERK	    1100	
JAMES	CLERK	    950	
FORD	ANALYST	    3000	
MILLER	CLERK	    1300	
*/

--○ TBL_EMP 테이블에서 20번 부서에 근무하지 않는 직원들의 
--   사원명, 직종명, 부서번호 항목을 조회한다.
SELECT ENAME "사원명", JOB "직종명", DEPTNO "부서번호"
FROM TBL_EMP
WHERE DEPTNO <> 20;

SELECT ENAME "사원명", JOB "직종명", DEPTNO "부서번호"
FROM TBL_EMP
WHERE DEPTNO != 20;

SELECT ENAME "사원명", JOB "직종명", DEPTNO "부서번호"
FROM TBL_EMP
WHERE DEPTNO ^= 20;
--==>>
/*
ALLEN	SALESMAN	30
WARD	SALESMAN	30
MARTIN	SALESMAN	30
BLAKE	MANAGER	    30
CLARK	MANAGER	    10
KING	PRESIDENT	10
TURNER	SALESMAN	30
JAMES	CLERK	    30
MILLER	CLERK	    10
*/

--○ TBL_EMP 테이블에서 커미션이 NULL이 아닌 직원들의
--   사원명, 직종명, 급여, 커미션 항목을 조회한다.
SELECT ENAME "사원명", JOB "직종명", SAL "급여", COMM "커미션"
FROM TBL_EMP
WHERE COMM IS NOT NULL;
-- 논리적 연산자 IS NOT 을 사용한다.
--==>>
/*
ALLEN	SALESMAN	1600	300
WARD	SALESMAN	1250	500
MARTIN	SALESMAN	1250	1400
TURNER	SALESMAN	1500	0
*/

SELECT ENAME "사원명", JOB "직종명", SAL "급여", COMM "커미션"
FROM TBL_EMP
WHERE NOT COMM IS NULL;
--- 이렇게 적어도됨!

--○ TBL_EMP 테이블에서 모든 사원들의
--   사원번호, 사원명, 급여, 커미션, 연봉 항목을 조회한다.
--   단, 급여(SAL)는 매월 지급한다. (→ 1회/월)
--   또한, 수당(COMM)은 매년 지급한다. (→ 1회/연)
SELECT ENAME "사원명", JOB "직종명", SAL "급여", COMM "커미션"
FROM TBL_EMP
WHERE  SAL 매월 지급 OR COMM 매년 지급;
--- 모든 사원들에 대한 것이기 때문에 WHERE 은 안사용!!!!!!

SELECT ENAME "사원명", JOB "직종명", SAL "급여", COMM "커미션",  SAL*12+COMM "연봉"      -- 수식 주목!
FROM TBL_EMP;
--==>>
/*
SMITH	CLERK	    800		
ALLEN	SALESMAN	1600	300	    19500
WARD	SALESMAN	1250	500	    15500
JONES	MANAGER	2975		
MARTIN	SALESMAN	1250	1400	16400
BLAKE	MANAGER	    2850		
CLARK	MANAGER	    2450		
SCOTT	ANALYST	    3000		
KING	PRESIDENT	5000		
TURNER	SALESMAN	1500	   0	 18000
ADAMS	CLERK	    1100		
JAMES	CLERK	    950		
FORD	ANALYST	    3000		
MILLER	CLERK	    1300		
*/
-- 근데 급여가 있는 사람들 연봉이 NULL이 되버린 사람들이 있음!
--  왜? 커미션이 NULL 인 사람이 있기 때문에!  그래서 함수를 써야해!

SELECT *
FROM TBL_EMP;

SELECT 1600*12+300
FROM DUAL;

-- 그 함수가 바로~~!! NVL()
SELECT NULL "1", NVL(NULL, 10) "2", NVL(10, 20) "3"
FROM DUAL;
--==>> (NULL)   10  10
--> 첫 번째 파라미터 값이 NULL 이면, 두 번째 파라미터 값을 반환한다.
--  첫 번째 파라미터 값이 NULL 이 아니면, 그 값(첫 번째 파라미터)을 그대로 반환한다.
-- NVL(10, 20) 같은 경우 첫 번째 값이 NULL이 아니니까 그대로 반환해준 것!


-- 관찰
SELECT *
FROM EMP
WHERE EMPNO = 7369;
--==>> 7369	SMITH	CLERK	7902	1980-12-17	800	    (NULL)	20

SELECT ENAME, COMM
FROM EMP
WHERE EMPNO = 7369;
--==>>SMITH	(NULL)

SELECT ENAME, NVL(COMM, 0)
FROM EMP
WHERE EMPNO = 7369;
--==>> SMITH	0

SELECT ENAME "사원명", COMM "수당", NVL(COMM, -1) "함수호출결과"
FROM TBL_EMP
--==>>
/*
SMITH	(NULL)   -1
ALLEN	300	    300
WARD	500	    500
JONES	(NULL)	 -1
MARTIN	1400   1400
BLAKE	(NULL)	 -1
CLARK	(NULL)	 -1
SCOTT	(NULL)	 -1
KING	(NULL)	 -1
TURNER	0	      0
ADAMS	(NULL)	 -1
JAMES	(NULL)	 -1
FORD	(NULL)	 -1
MILLER	(NULL)	 -1
*/

SELECT EMPNO "사원번호", ENAME "사원명",  SAL "급여", NVL(COMM,0) "커미션",  SAL*12+NVL(COMM,0) "연봉"      -- 수식 주목!
FROM TBL_EMP;
/*
7369	SMITH	800	    0	9600
7499	ALLEN	1600	300	19500
7521	WARD	1250	500	15500
7566	JONES	2975	0	35700
7654	MARTIN	1250	1400	16400
7698	BLAKE	2850	0	34200
7782	CLARK	2450	0	29400
7788	SCOTT	3000	0	36000
7839	KING	5000	0	60000
7844	TURNER	1500	0	18000
7876	ADAMS	1100	0	13200
7900	JAMES	950	    0	11400
7902	FORD	3000	0	36000
7934	MILLER	1300	0	15600
*/

--○ NVL2()
--> 첫 번째 파라미터 값이 NULL 이 아닌 경우, 두 번째 파라미터 값을 반환하고
--  첫 번째 파라미터 값이 NULL 인 경우, 세 번째 파라미터 값을 반환한다.

SELECT ENAME, COMM, NVL2(COMM, '널아니네?청기올려', '널이네?백기올려') "확인여부"
FROM TBL_EMP;
--==>>
/*
SMITH		    널이네?백기올려
ALLEN	300	    널아니네?청기올려
WARD	500	    널아니네?청기올려
JONES		    널이네?백기올려
MARTIN	1400	널아니네?청기올려
BLAKE		    널이네?백기올려
CLARK		    널이네?백기올려
SCOTT		    널이네?백기올려
KING		    널이네?백기올려
TURNER	0	    널아니네?청기올려
ADAMS		    널이네?백기올려
JAMES		    널이네?백기올려
FORD		    널이네?백기올려
MILLER		    널이네?백기올려
*/

--○ NVL2()활용~ 연봉 조회
--   COMM 이 NULL 이 아니면... SAL*12+COMM
--   COMM 이 NULL 이면........ SAL*12
SELECT EMPNO "사원번호", ENAME "사원명", SAL "급여", NVL2(COMM, COMM, 0) "커미션", SAL*12+NVL2(COMM, COMM,0)"연봉"
FROM TBL_EMP;
--==>>
/*
7369	SMITH	800	    0	9600
7499	ALLEN	1600	300	19500
7521	WARD	1250	500	15500
7566	JONES	2975	0	35700
7654	MARTIN	1250	1400	16400
7698	BLAKE	2850	0	34200
7782	CLARK	2450	0	29400
7788	SCOTT	3000	0	36000
7839	KING	5000	0	60000
7844	TURNER	1500	0	18000
7876	ADAMS	1100	0	13200
7900	JAMES	950	    0	11400
7902	FORD	3000	0	36000
7934	MILLER	1300	0	15600
*/

-- 정답!!
SELECT EMPNO "사원번호", ENAME "사원명", SAL "급여", COMM "커미션", NVL2(COMM, SAL*12+COMM,SAL*12)"연봉"
FROM TBL_EMP;
/*
7369	SMITH	800		    9600
7499	ALLEN	1600	300	19500
7521	WARD	1250	500	15500
7566	JONES	2975		35700
7654	MARTIN	1250   1400	16400
7698	BLAKE	2850		34200
7782	CLARK	2450		29400
7788	SCOTT	3000		36000
7839	KING	5000		60000
7844	TURNER	1500	0	18000
7876	ADAMS	1100		13200
7900	JAMES	950		11400
7902	FORD	3000		36000
7934	MILLER	1300		15600
*/

--○ COALESCE() 각종 NULL을 처리할 수 있는 유용한 함수인 코알레스 함수
--> 매개변수 제한이 없는 형태로 인지하고 활용한다.
--   맨 앞에 있는 매개변수부터 차례로 NULL 인지 아닌지 확인하여
--   NULL 이 아닐 경우 적용(반환, 처리)하고
--   NULL 인 경우에는 그 다음 매개변수의 값으로 적용(반환, 처리)한다.
--   NVL() 나 NVL2() 에 비해 모~~~ 든 경우의 수를 고려하여 처리할 수 있는 특징을 갖고 있다.

SELECT NULL "기본확인"
     , COALESCE(NULL, NULL, NULL, NULL,30) "함수확인1"
     , COALESCE(NULL, NULL, NULL, NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,100) "함수확인2"
     , COALESCE(10, NULL, NULL, NULL) "함수확인3"
     , COALESCE(NULL, NULL, 200, NULL, NULL) "함수확인4"
FROM DUAL;
--==>> (NULL)   30	100	10	200
-- ★콤마는 앞에 찍자!

--○ 실습을 위한 데이터 추가 입력
INSERT INTO TBL_EMP(EMPNO,ENAME, JOB, MGR, HIREDATE, DEPTNO)
VALUES(8000, '송해덕', 'SALESMAN', 7839, SYSDATE,10);
--==>>  1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_EMP(EMPNO, ENAME, JOB, MGR, HIREDATE, COMM,DEPTNO)
VALUES(8001, '이다영', 'SALESMAN', 7839, SYSDATE, 100, 10);
--==>>  1 행 이(가) 삽입되었습니다.

-- 잘못입력한 '이효진', '송효진' 삭제해줌!
DELETE 
FROM TBL_EMP
WHERE ENAME = '송효진';

SELECT *
FROM TBL_EMP;

COMMIT;
--==>> 커밋 완료.



--○ TBL_EMP 테이블에서 모든 사원들의
--   사원번호, 사원명, 급여, 커미션, 연봉 항목을 조회한다.
--   단, 급여(SAL)는 매월 지급한다. (→ 1회/월)
--   또한, 수당(COMM)은 매년 지급한다. (→ 1회/연)
SELECT EMPNO "사원번호", ENAME "사원명", SAL "급여", COMM "커미션"
    , COALESCE(SAL*12+COMM, SAL*12, COMM, 0) "연봉"
FROM TBL_EMP;
----------------------------------------여기까지왔으면 둘다 널이라는 것!
-- 첫 번째 파라미터가 NULL 인 애들은 두 번째 파라미터 실행
-- 두 번째 파라미터가 NULL 인 애들은 세 번째 파라미터 실행
-- .....
--==>>
/*
7369	SMITH	800		         9600
7499	ALLEN	1600	300	    19500
7521	WARD	1250	500	    15500
7566	JONES	2975		    35700
7654	MARTIN	1250	1400	16400
7698	BLAKE	2850		    34200
7782	CLARK	2450		    29400
7788	SCOTT	3000		    36000
7839	KING	5000		    60000
7844	TURNER	1500	   0	18000
7876	ADAMS	1100		    13200
7900	JAMES	950		        11400
7902	FORD	3000		    36000
7934	MILLER	1300		    15600
8000	송해덕			            0
8001	이다영		     100	  100
*/

--------------------------------------------------------------------------------
--※ 날짜에 대한 세션 설정 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
--==>> Session이(가) 변경되었습니다.


--○ 현재 날짜 및 시간을 반환하는 함수 SYSDATE, CURRENT_DATE, LOCALTIMESTAMP  ()← 이거 안붙이지만 한수!
--   사용빈도 높은 함수 → SYSDATE
SELECT SYSDATE, CURRENT_DATE, LOCALTIMESTAMP
FROM DUAL;
--==>> 
/*
2021-08-27 16:33:18	
2021-08-27 16:33:18	
21/08/27 16:33:18.000000000
*/

--※ 날짜에 대한 세션 설정 다시 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

SELECT SYSDATE
FROM DUAL;
--==>> 2021-08-27

--○ 컬럼과 컬럼의 연결(결합)
--   문자타입과 문자타입의 연결
--   『+』 연산자를 통한 결함 수행은 불가능 → 『||』 파이프 라고 부름!

SELECT 1+1
FROM DUAL;

SELECT '송해덕' + '이다영'
FROM DUAL;
--==>> 에러 발생
/*
ORA-01722: invalid number
01722. 00000 -  "invalid number"
*Cause:    The specified number was invalid.
*Action:   Specify a valid number.
*/

SELECT '송해덕', '이다영'
FROM DUAL;
--==>> 송해덕	이다영

SELECT '송해덕'||'이다영'
FROM DUAL;
--==>> 송해덕이다영

SELECT EMPNO, ENAME
FROM TBL_EMP;

SELECT EMPNO || ENAME
FROM TBL_EMP;
--==>>
/*
7369SMITH
7499ALLEN
7521WARD
7566JONES
7654MARTIN
7698BLAKE
7782CLARK
7788SCOTT
7839KING
7844TURNER
7876ADAMS
7900JAMES
7902FORD
7934MILLER
8000송해덕
8001이다영
*/

--      문자타입  날짜타입 문자타입 숫자타입  문자타입
--      --------   -------  ------- -----   ----------
SELECT '해덕이는', SYSDATE,'에 연봉', 500,'억을 원한다.'
FROM DUAL;
--==>> 해덕이는	2021-08-27	에 연봉	500	억을 원한다.


--      문자타입  날짜타입 문자타입 숫자타입  문자타입
--      --------   -------  ------- -----   ----------
SELECT '해덕이는'|| SYSDATE||'에 연봉'|| 500||'억을 원한다.'
FROM DUAL;
--==>> 해덕이는2021-08-27에 연봉500억을 원한다.

--※ 오라클에서 문자 타입의 형태로 형 변환하는 별도의 과정 없이
--   위에서 처리한 내용처럼 『||』만 삽입해주면 간단히 컬럼과 컬럼을
--   (즉, 서로 다름 종류의 데이터들을) 결합하는 것이 가능하다.
--   MSSQL 서버에서는 모든 데이터를 문자 타입으로 CONVERT 해야 한다.

--○ TML_EMP 테이블의 정보를 활용하여
--   모든 직원들의 데이터에 대해서
--   다음과 같은 결과를 얻을 수 있도록 쿼리문을 구성하다.

--   SMITH 의 현재 연봉은 9600인데 희망 연봉은 19200이다. (지금 연봉의 2배)
--   ALLER 의 현재 연봉은 19500인데 희망 연봉은 39000이다.
--                          :
DELETE
FROM TBL_EMP
WHERE EMPNO IN (8000,8001);
--==>> 2개 행 이(가) 삭제되었습니다.

SELECT *
FROM TBL_EMP;

COMMIT;
--==>> 커밋 완료.

--① COALESCE
/* 방법1(내가 한 것)
SELECT ENAME || '의 현재 연봉은 ' || COALESCE(SAL*12+COMM, SAL*12, COMM, 0) || '인데 희망연봉은 ' 
            || COALESCE((SAL*12+COMM)*2, (SAL*12)*2, COMM*2, 0) || '이다.'    
FROM TBL_EMP;
*/
-- 방법2 (2배 한것을 한번에 묶어준 것)
SELECT ENAME || '의 현재 연봉은 ' || COALESCE(SAL*12+COMM, SAL*12, COMM, 0) || '인데 희망연봉은 ' 
            || COALESCE(SAL*12+COMM, SAL*12, COMM, 0)*2 || '이다.'
FROM TBL_EMP;
--==>>
/*
SMITH의 현재 연봉은 9600인데 희망연봉은 19200이다.
ALLEN의 현재 연봉은 19500인데 희망연봉은 39000이다.
WARD의 현재 연봉은 15500인데 희망연봉은 31000이다.
JONES의 현재 연봉은 35700인데 희망연봉은 71400이다.
MARTIN의 현재 연봉은 16400인데 희망연봉은 32800이다.
BLAKE의 현재 연봉은 34200인데 희망연봉은 68400이다.
CLARK의 현재 연봉은 29400인데 희망연봉은 58800이다.
SCOTT의 현재 연봉은 36000인데 희망연봉은 72000이다.
KING의 현재 연봉은 60000인데 희망연봉은 120000이다.
TURNER의 현재 연봉은 18000인데 희망연봉은 36000이다.
ADAMS의 현재 연봉은 13200인데 희망연봉은 26400이다.
JAMES의 현재 연봉은 11400인데 희망연봉은 22800이다.
FORD의 현재 연봉은 36000인데 희망연봉은 72000이다.
MILLER의 현재 연봉은 15600인데 희망연봉은 31200이다.
*/

--② NVL()
-- 방법1
SELECT ENAME || '의 현재 연봉은 ' || NVL(SAL*12+COMM, SAL*12) || '인데 희망연봉은 ' 
            || NVL(SAL*12+COMM, SAL*12)*2 || '이다.'
FROM TBL_EMP;

-- 방법2 (위에서 배운거 SAL *12 + NVL(COMM,0) 인데 작동안해서 괄호 추가해줌 (SAL *12 + NVL(COMM,0)) 이렇게!)
-- 왜이렇게 전체 괄호를 해줘야해? → 연산자 우선순위 때문! NVL 과 || 연산이 충돌이 일어나서 괄호를 해줘야한다!
SELECT ENAME || '의 현재 연봉은 ' || (SAL *12 + NVL(COMM,0))
            || '인데 희망 연봉은 ' || (SAL *12 + NVL(COMM,0)) *2 || '이다.'
FROM TBL_EMP;

/*
SMITH의 현재 연봉은 9600인데 희망연봉은 19200이다.
ALLEN의 현재 연봉은 19500인데 희망연봉은 39000이다.
WARD의 현재 연봉은 15500인데 희망연봉은 31000이다.
JONES의 현재 연봉은 35700인데 희망연봉은 71400이다.
MARTIN의 현재 연봉은 16400인데 희망연봉은 32800이다.
BLAKE의 현재 연봉은 34200인데 희망연봉은 68400이다.
CLARK의 현재 연봉은 29400인데 희망연봉은 58800이다.
SCOTT의 현재 연봉은 36000인데 희망연봉은 72000이다.
KING의 현재 연봉은 60000인데 희망연봉은 120000이다.
TURNER의 현재 연봉은 18000인데 희망연봉은 36000이다.
ADAMS의 현재 연봉은 13200인데 희망연봉은 26400이다.
JAMES의 현재 연봉은 11400인데 희망연봉은 22800이다.
FORD의 현재 연봉은 36000인데 희망연봉은 72000이다.
MILLER의 현재 연봉은 15600인데 희망연봉은 31200이다.
*/

-- 잠시 조회
SELECT *
FROM TBL_EMP;

--③ NVL2()
-- 내가푼 것
SELECT ENAME || '의 현재 연봉은 ' || NVL2(COMM, SAL*12+COMM, SAL*12) || '인데 희망연봉은 ' 
            || NVL2(COMM, (SAL*12+COMM)*2, (SAL*12)*2)|| '이다.'
FROM TBL_EMP;

-- 방법2 (2배 한것을 한번에 묶어준 것)
SELECT ENAME || '의 현재 연봉은 ' || NVL2(COMM, SAL*12+COMM, SAL*12) || '인데 희망연봉은 ' 
            || NVL2(COMM, SAL*12+COMM, SAL*12)*2|| '이다.'
FROM TBL_EMP;
/*
SMITH의 현재 연봉은 9600인데 희망연봉은 19200이다.
ALLEN의 현재 연봉은 19500인데 희망연봉은 39000이다.
WARD의 현재 연봉은 15500인데 희망연봉은 31000이다.
JONES의 현재 연봉은 35700인데 희망연봉은 71400이다.
MARTIN의 현재 연봉은 16400인데 희망연봉은 32800이다.
BLAKE의 현재 연봉은 34200인데 희망연봉은 68400이다.
CLARK의 현재 연봉은 29400인데 희망연봉은 58800이다.
SCOTT의 현재 연봉은 36000인데 희망연봉은 72000이다.
KING의 현재 연봉은 60000인데 희망연봉은 120000이다.
TURNER의 현재 연봉은 18000인데 희망연봉은 36000이다.
ADAMS의 현재 연봉은 13200인데 희망연봉은 26400이다.
JAMES의 현재 연봉은 11400인데 희망연봉은 22800이다.
FORD의 현재 연봉은 36000인데 희망연봉은 72000이다.
MILLER의 현재 연봉은 15600인데 희망연봉은 31200이다.
*/

-- SMITH's 입사일은 1980-12-17이다. 그리고 급여는 800이다.
-- ALLEN's 입사입을 1981-02-20이다. 그리고 급여는 1600이다.
/*
SELECT ENAME || ''S' || '입사일은' || HIREDATE || '이다.' ||' 그리고 급여는 ' || SAL || '이다.'
FROM TBL_EMP;
--==>> 오류 발생

ORA-00923: FROM keyword not found where expected
00923. 00000 -  "FROM keyword not found where expected"
*Cause:    
*Action:
1,078행, 20열에서 오류 
*/

SELECT ENAME || '''s' || '입사일은' || HIREDATE || '이다.' ||' 그리고 급여는 ' || SAL || '이다.'
FROM TBL_EMP;
-- 's 를 사용하려면 ''를 두번입력해야 한다!

--※ 문자열을 나타내는 홑따옴표 사이에서(시작과 끝)
--   홑따옴표 두개가 홑따옴표 하나(어퍼스트로피)를 의미한다.
--   결과적으로...
--   홑따옴표 하나 『'』는 문자열의 시작을 나타내고
--   홑따옴표 두개는 『''』는 문자열 영역 안에서 어퍼스트로피를 나타내며
--   다시 등장하는 홑따옴표 하나 『'』가 문자열 영역의 종료를 의미하게 되는 것이다.
/*
SMITH's입사일은1980-12-17이다. 그리고 급여는 800이다.
ALLEN's입사일은1981-02-20이다. 그리고 급여는 1600이다.
WARD's입사일은1981-02-22이다. 그리고 급여는 1250이다.
JONES's입사일은1981-04-02이다. 그리고 급여는 2975이다.
MARTIN's입사일은1981-09-28이다. 그리고 급여는 1250이다.
BLAKE's입사일은1981-05-01이다. 그리고 급여는 2850이다.
CLARK's입사일은1981-06-09이다. 그리고 급여는 2450이다.
SCOTT's입사일은1987-07-13이다. 그리고 급여는 3000이다.
KING's입사일은1981-11-17이다. 그리고 급여는 5000이다.
TURNER's입사일은1981-09-08이다. 그리고 급여는 1500이다.
ADAMS's입사일은1987-07-13이다. 그리고 급여는 1100이다.
JAMES's입사일은1981-12-03이다. 그리고 급여는 950이다.
FORD's입사일은1981-12-03이다. 그리고 급여는 3000이다.
MILLER's입사일은1982-01-23이다. 그리고 급여는 1300이다.
*/

SELECT *
FROM TBL_EMP
WHERE JOB = 'saleman';
--==>> 조회 결과 없음
-- 데이터 값은 대소문자를 정확히 구분하는데 사용자는 소문자로 입력할 수 있자나! 그래서 변환함수 써줘!

--○ UPPER(), LOWER(), INITCAP()
--   대문자   소문자   첫글자만 대문자

SELECT 'oRAcLE' "1", UPPER('oRAcLE') "2", LOWER('oRAcLE') "3", INITCAP('oRAcLE') "4"
FROM DUAL;
--==>> oRAcLE	ORACLE	oracle	Oracle
--> UPPER() 는 모두 대문자로 변환하여 반환하는 함수
--  LOWER() 는 모두 소문자로 변환하여 반환하는 함수
--  INITCAP() 는 첫 글자만 대문자로 하고 나머지는 모두 소문자로 변환하여 반환하는 함수

SELECT *
FROM TBL_EMP
WHERE JOB = (입력값);

-- 검색할 때 입력값에는 대소문자 구분없이 다 찾아줘야할때 처리를 해줘야함!


SELECT *
FROM TBL_EMP
WHERE JOB = 'sALeSmAn';


SELECT *
FROM TBL_EMP
WHERE JOB = UPPER('sALeSmAn');
-- 이러면 되자나요! → 이거는 테이블의 안에 값이 모두 대문자일때만 가능! 그래서

SELECT *
FROM TBL_EMP
WHERE UPPER(JOB) = UPPER('sALeSmAn');

SELECT *
FROM TBL_EMP
WHERE LOWER(JOB) = LOWER('sALeSmAn');

SELECT *
FROM TBL_EMP
WHERE INITCAP(JOB) = INITCAP('sALeSmAn');
-- 둘다 UPPER() / LOWER() / INITCAP() 해주면 됨

COMMIT;
--==>> 커밋 완료.
-- 수업때는 창닫는 표시 했을 때 그냥 커밋한다고 하면 되지만!
-- 실무에서는 절대 그러면 안되고 ★취소★한다음에 COMMIT시점을 찾아가서 찾아보고 확인하고 해야함!






























