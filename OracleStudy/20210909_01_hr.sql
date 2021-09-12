SELECT USER
FROM DUAL;
--==>> HR

--■■■ PRIMARY KEY ■■■--

-- 1. 테이블에 대한 기본 키를 생성한다.

-- 2. 테이블에서 각 행을 유일하게 식별하는 컬럼(단일 프라이머리키) 또는 컬럼의 집합(복합프라이머리키)이다.
--    기본 키는 테이블 당 최대 하나만 존재한다.
--    그러나 반드시 하나의 컬럼으로만 구성되는 것은 아니다.
--    NULL일 수 없고, 이미 테이블에 존재하고 있는 데이터를
--    다시 입력할 수 없도록 처리된다.
--    UNIQUE INDEX 가 자동으로 생성된다.(오라클이 자체적으로 만든다.)


-- 3. 형식 및 구조 ([] 생략가능하다는 표현)
-- ① 컬럼 레벨의 형식
-- 컬럼명 데이터타입 [CONSTRAINT명] PRIMARY KEY[(컬럼명, ...)]

-- ② 테이블 레벨의 형식 (권장!!)
-- 컬럼명 데이터 타입
-- , 컬럼명 데이터 타입
-- , CONSTRAINT CONSTRAINT명 PRIMARY KEY(컬럼명[,...])

-- 4. CONSTRAINT 추가 시 CONSTRAINT 명을 생략하면
--    오라클 서버가 자동적으로 CONSTRAINT 명을 부여하게 된다.
--    (하지만 권장하지 않음! 직접쓰자!)
--    일반적으로 CONSTRAINT 명은 『테이블명_컬럼명_CONSTRAINT약어』
--    형식으로 기술한다.



--○ PK 지정 실습(① 컬럼 레벨의 형식)
-- 테이블 생성
CREATE TABLE TBL_TEST1
( COL1  NUMBER(5)       PRIMARY KEY
, COL2  VARCHAR2(30)
);
--==>> Table TBL_TEST1이(가) 생성되었습니다.


-- INSERT 구문 사용할 때
--INSERT INTO TBL_TEST1(COL1,COL2) VALUES(1,'TSET');        -- 권장!!
--INSERT INTO TBL_TEST1 VALUES(1,'TEST');                   -- 빠르게 넣어야할 때 아니면 권장X
--INSERT INTO TBL_TESL1(COL1) VALUES(4);                    -- COL2는 NULL로 넣겠다!
--INSERT INTO TBL_TEST1(COL2,COL1) VALUES('ABCD',2);        -- 바꿔서 넣는것도 가능!   

-- 데이터 입력
INSERT INTO TBL_TEST1(COL1,COL2) VALUES(1,'TSET');
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST1(COL1,COL2) VALUES(2,'ABCD');
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST1(COL1,COL2) VALUES(3,'NULL');
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST1(COL1) VALUES(4); 
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST1(COL1,COL2) VALUES(2,'ABCD');      --> 에러 발생 (숫자 2때문에 안되는 것!)
INSERT INTO TBL_TEST1(COL1,COL2) VALUES(2,'KKKK');      --> 에러 발생
INSERT INTO TBL_TEST1(COL1,COL2) VALUES(5,'ABCD');  --동명이인 같은 것!
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST1(COL1,COL2) VALUES(NULL,NULL);     --> 에러 발생 (NULL 안된다!)
INSERT INTO TBL_TEST1(COL1,COL2) VALUES(NULL, 'STUDY');  --> 에러 발생
INSERT INTO TBL_TEST1(COL2) VALUES('STUDY');             --> 에러 발생

COMMIT;
--==>> 커밋 완료.

SELECT *
FROM TBL_TEST1;
--==>>
/*
1	TSET
2	ABCD
3	NULL
4	
5	ABCD
*/

DESC TBL_TEST1;
--==>> DESC를 통해서 PRIMARY 제약조건을 확인할 수 없다! NOT NULL은 확인 가능!
/*
이름   널?       유형           
---- -------- ------------ 
COL1 NOT NULL NUMBER(5)     → PK 제약 확인 불가    
COL2          VARCHAR2(30) 
*/

--○ 제약조건 확인
SELECT *
FROM USER_CONSTRAINTS;

--TBL_TEST1만 보기
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TBL_TEST1';
--==>>
/*
HR	SYS_C007057	P	TBL_TEST1					ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	GENERATED NAME			21/09/09	HR	SYS_C007057		
*/

--○ 제약조건이 지정된 컬럼 확인(조회)    
SELECT *
FROM USER_CONS_COLUMNS;             -- CONS 는 약어!
--==>>
/*
HR	REGION_ID_NN	REGIONS	    REGION_ID	
HR	REG_ID_PK	    REGIONS 	REGION_ID	1
HR	COUNTRY_ID_NN	COUNTRIES	COUNTRY_ID	
HR	COUNTRY_C_ID_PK	COUNTRIES	COUNTRY_ID	1
HR	COUNTR_REG_FK	COUNTRIES	REGION_ID	1
HR	LOC_ID_PK	    LOCATIONS	LOCATION_ID	1
HR	LOC_CITY_NN	    LOCATIONS	CITY	
HR	LOC_C_ID_FK	    LOCATIONS	COUNTRY_ID	1
HR	DEPT_ID_PK	    DEPARTMENTS	DEPARTMENT_ID	1
HR	DEPT_NAME_NN	DEPARTMENTS	DEPARTMENT_NAME	
HR	DEPT_MGR_FK	DEPARTMENTS	MANAGER_ID	1
HR	DEPT_LOC_FK	DEPARTMENTS	LOCATION_ID	1
HR	JOB_ID_PK	JOBS	JOB_ID	1
HR	JOB_TITLE_NN	JOBS	JOB_TITLE	
HR	EMP_EMP_ID_PK	EMPLOYEES	EMPLOYEE_ID	1
HR	EMP_LAST_NAME_NN	EMPLOYEES	LAST_NAME	
HR	EMP_EMAIL_NN	EMPLOYEES	EMAIL	
HR	EMP_EMAIL_UK	EMPLOYEES	EMAIL	1
HR	EMP_HIRE_DATE_NN	EMPLOYEES	HIRE_DATE	
HR	EMP_JOB_NN	EMPLOYEES	JOB_ID	
HR	EMP_JOB_FK	EMPLOYEES	JOB_ID	1
HR	EMP_SALARY_MIN	EMPLOYEES	SALARY	
HR	EMP_MANAGER_FK	EMPLOYEES	MANAGER_ID	1
HR	EMP_DEPT_FK	EMPLOYEES	DEPARTMENT_ID	1
HR	JHIST_EMPLOYEE_NN	JOB_HISTORY	EMPLOYEE_ID	
HR	JHIST_EMP_ID_ST_DATE_PK	JOB_HISTORY	EMPLOYEE_ID	1
HR	JHIST_EMP_FK	JOB_HISTORY	EMPLOYEE_ID	1
HR	JHIST_START_DATE_NN	JOB_HISTORY	START_DATE	
HR	JHIST_DATE_INTERVAL	JOB_HISTORY	START_DATE	
HR	JHIST_EMP_ID_ST_DATE_PK	JOB_HISTORY	START_DATE	2
HR	JHIST_END_DATE_NN	JOB_HISTORY	END_DATE	
HR	JHIST_DATE_INTERVAL	JOB_HISTORY	END_DATE	
HR	JHIST_JOB_NN	JOB_HISTORY	JOB_ID	
HR	JHIST_JOB_FK	JOB_HISTORY	JOB_ID	1
HR	JHIST_DEPT_FK	JOB_HISTORY	DEPARTMENT_ID	1
HR	SYS_C007057	TBL_TEST1	COL1	1
*/
SELECT *
FROM USER_CONS_COLUMNS
WHERE TABLE_NAME = 'TBL_TEST1';
--==>>
/*
HR	SYS_C007057	TBL_TEST1	COL1	1
*/


--○ 제약조건이 설정된 소유주, 제약조건명, 테이블명, 제약조건종류, 컬럼명 항목 조회
--(위에 조회한 두 테이블에서 원하는 값만 가져오기!)
SELECT UC.OWNER, UC.CONSTRAINT_NAME, UC.TABLE_NAME
     , UC.CONSTRAINT_TYPE, UCC.COLUMN_NAME
FROM USER_CONSTRAINTS UC, USER_CONS_COLUMNS UCC
WHERE UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
  AND UC.TABLE_NAME = 'TBL_TEST1';
--==>> HR	SYS_C007057	TBL_TEST1	P	COL1



--○ PK 지정 실습(② 테이블 레벨의 형식)      → 이걸로 사용하는 법 익숙하게하면 1번 방식은 그냥할수있음!
-- 테이블 생성
CREATE TABLE TBL_TEST2
( COL1  NUMBER(5)
, COL2  VARCHAR2(30)
, CONSTRAINT TEST2_COL1_PK PRIMARY KEY(COL1)    -- TBL_TEST2 가 아니라!! TEST2!!
);
--==>> Table TBL_TEST2이(가) 생성되었습니다.

-- 데이터 입력
INSERT INTO TBL_TEST2(COL1,COL2) VALUES(1,'TSET');
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST2(COL1,COL2) VALUES(2,'ABCD');
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST2(COL1,COL2) VALUES(3,NULL);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST2(COL1) VALUES(4);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST2(COL1,COL2) VALUES(2,'ABCD');      --> 에러 발생 (숫자 2때문에 안되는 것!)
INSERT INTO TBL_TEST2(COL1,COL2) VALUES(2,'KKKK');      --> 에러 발생
INSERT INTO TBL_TEST2(COL1,COL2) VALUES(5,'ABCD');  --동명이인 같은 것!
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST2(COL1,COL2) VALUES(NULL,NULL);     --> 에러 발생 (NULL 안된다!)
INSERT INTO TBL_TEST2(COL1,COL2) VALUES(NULL, 'STUDY');  --> 에러 발생
INSERT INTO TBL_TEST2(COL2) VALUES('STUDY');             --> 에러 발생

COMMIT;
--==>> 커밋 완료.

SELECT *
FROM TBL_TEST2;
--==>>
/*
1	TSET
2	ABCD
3	
5	ABCD
4	
*/

--○ 제약조건이 설정된 소유주, 제약조건명, 테이블명, 제약조건종류, 컬럼명 항목 조회
--(위에 조회한 두 테이블에서 원하는 값만 가져오기!)
SELECT UC.OWNER, UC.CONSTRAINT_NAME, UC.TABLE_NAME
     , UC.CONSTRAINT_TYPE, UCC.COLUMN_NAME
FROM USER_CONSTRAINTS UC, USER_CONS_COLUMNS UCC
WHERE UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
  AND UC.TABLE_NAME = 'TBL_TEST2';
--==>>
/*
HR	TEST2_COL1_PK	TBL_TEST2	P	COL1
*/


--○ PK 지정 실습(③ 다중 컬럼 PK지정 → 복합 프라이머리 키)
-- 테이블 생성
/*
CREATE TABLE TBL_TEST3
( COL1 NUMBER(5)
, COL2 VARCHAR2(30)
, CONSTRAINT TEST3_COL1_PK PRIMARY KEY(COL1)
, CONSTRAINT TEST3_COL2_PK PRIMARY KEY(COL2)
);
*/
--(X)이렇게 하면 안댄다! 이거는 제약조건을 두개 만들겠다는 뜻!
--      한 테이블에 제약조건은 하나만 가능하다! 


CREATE TABLE TBL_TEST3
( COL1 NUMBER(5)
, COL2 VARCHAR2(30)
, CONSTRAINT TEST3_COL1_COL2_PK PRIMARY KEY(COL1,COL2)
);
--==>> Table TBL_TEST3이(가) 생성되었습니다.

--? 복합 프라이머리 키 입력하는 것을 컬럼레벨 형식으로 지정하는 것도 가능하지만 바람직하지 못하다!



-- 데이터 입력
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(1,'TEST');
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(2,'ABCD');
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(3, NULL);          --> 에러 발생
INSERT INTO TBL_TEST3(COL1) VALUES(4);                      --> 에러 발생
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(3,'ABCD');         -- CHCECK~!!!(복합 PK이기 때문에 가능!)
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(2,'TEST');         -- CHCECK~!!!
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(1,'KKKK');         -- CHCECK~!!!
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(NULL, NULL);       --> 에러 발생      
INSERT INTO TBL_TEST3(COL1, COL2) VALUES(NULL, 'STUDY');    --> 에러 발생
INSERT INTO TBL_TEST3(COL2) VALUES('TEST');                 --> 에러 발생

COMMIT;
--==>> 커밋 완료.

SELECT *
FROM TBL_TEST3;
--==>>
/*
1	KKKK
1	TEST
2	ABCD
2	TEST
3	ABCD
*/


--○ PK 지정 실습(④ 테이블 생성 이후 제약조건 추가 → PK 지정)
-- 테이블 생성
CREATE TABLE TBL_TEST4
( COL1  NUMBER(5)
, COL2 VARCHAR2(30)
);
--==>> Table TBL_TEST4이(가) 생성되었습니다.

-- 그런데 테이블 생성 이후 PK추가하려고 하는데 이미 제약조건에 위배되는 값이 있으면 이후에 PK지정할 수 없음!
-- 예를 들어 이미 컬럼 값에 NULL 이 있거나 중복이 있으면 안됨!!

--※ 이미 만들어져 있는 테이블에
--   부여하려는 제약조건을 위반한 데이터가 포함되어 있을 경우
--   해당 테이블에 제약조건을 추가하는 것은 불가능하다.



-- 제약 조건 추가
/*
ALTER TABLE TBL_TEST4
ADD 여기에 뒤에는 제약조건 구문 똑같음! 추가해주면 됨!
*/
ALTER TABLE TBL_TEST4
ADD CONSTRAINT TEST4_COL1_PK PRIMARY KEY(COL1);
--==>> Table TBL_TEST4이(가) 변경되었습니다.


-- 데이터 입력
INSERT INTO TBL_TEST4(COL1,COL2) VALUES(1,'TSET');
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST4(COL1,COL2) VALUES(2,'ABCD');
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST4(COL1,COL2) VALUES(3,NULL);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST4(COL1) VALUES(4);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST4(COL1,COL2) VALUES(2,'ABCD');      --> 에러 발생 (숫자 2때문에 안되는 것!)
INSERT INTO TBL_TEST4(COL1,COL2) VALUES(2,'KKKK');      --> 에러 발생
INSERT INTO TBL_TEST4(COL1,COL2) VALUES(5,'ABCD');  --동명이인 같은 것!
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST4(COL1,COL2) VALUES(NULL,NULL);     --> 에러 발생 (NULL 안된다!)
INSERT INTO TBL_TEST4(COL1,COL2) VALUES(NULL, 'STUDY');  --> 에러 발생
INSERT INTO TBL_TEST4(COL2) VALUES('STUDY');             --> 에러 발생

COMMIT;
--==>> 커밋 완료.
SELECT *
FROM TBL_TEST4;
--==>>
/*
1	TSET
2	ABCD
3	
4	
5	ABCD
*/

-- 제약조건을 매번 확인하니까 뷰를 하나 만들자!
--※ 제약조건 확인용 전용 뷰(VIEW) 생성
CREATE OR REPLACE VIEW VIEW_CONSTCHECK
AS
SELECT UC.OWNER "OWNER"
     , UC.CONSTRAINT_NAME "CONSTRAINT_NAME"
     , UC.TABLE_NAME "TABLE_NAME"
     , UC.CONSTRAINT_TYPE "CONSTRAINT_TYPE"
     , UCC.COLUMN_NAME "COLUMN_NAME"
     , UC.SEARCH_CONDITION "SEARCH_CONDITION"
     , UC.DELETE_RULE "DELETE_RULE"
FROM USER_CONSTRAINTS UC  JOIN  USER_CONS_COLUMNS UCC
ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME;
--==>> View VIEW_CONSTCHECK이(가) 생성되었습니다.


--○ 생성된 뷰(VIEW)를 통한 제약 조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST4';
--==>> HR	TEST4_COL1_PK	TBL_TEST4	P	COL1		

--------------------------------------------------------------------------------

--■■■ UNIQUE(UK:U) ■■■--
-- NULL을 허용하는 것 이외에는 PK와 유사

-- 1. 테이블에서 지정한 컬럼의 데이터가 중복되지 않고
--    테이블 내에서 유일할 수 있도록 설정하는 제약조건.
--    PRIMARY KEY 와 유사한 제약조건 이지만, NULL 을 허용한다는 차이가 있다.
--    내부적으로 PRIMARY KEY 와 마찬가지로 UNIQUE INDEX 가 자동 생성된다.
--    하나의 테이블 내에서 UNIQUE 제약조건은 여러 번 설정하는 것이 가능하다.
--    즉, 하나의 테이블에 UNIQUE 제약조건을 여러 개 만드는 것이
--    가능하다는 것이다.

-- 2. 형식 및 구조
-- ① 컬럼 레벨의 형식
-- 컬럼명 데이터 타입 [CONSTRAINT CONSTRAINT명] UNIQUE

-- ② 테이블 레벨의 형식
-- 컬럼명 데이터 타입
--, 컬럼명 데이터 타입
--, CONSTRAINT CONSTRAINT명 UNIQUE(컬럼명, ...)


--○ UK 지정 실습(① 컬럼 레벨의 형식)
-- 테이블 생성
CREATE TABLE TBL_TEST5
( COL1  NUMBER(5)       PRIMARY KEY
, COL2  VARCHAR(30)     UNIQUE
);
--==>> Table TBL_TEST5이(가) 생성되었습니다.


-- 제약 조건 조회
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST5';
--==>>
/*
HR	SYS_C007061	TBL_TEST5	P	COL1		
HR	SYS_C007062	TBL_TEST5	U	COL2		
*/

-- 데이터 입력
INSERT INTO TBL_TEST5(COL1,COL2) VALUES(1,'TSET');
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST5(COL1,COL2) VALUES(2,'ABCD');
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST5(COL1,COL2) VALUES(3,NULL);        -- CHECK~!! NULL 허용!
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST5(COL1) VALUES(4);                  -- NULL 을 고유한 값으로 갖지 않는다!
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST5(COL1,COL2) VALUES(2,'ABCD');      --> 에러 발생 (숫자 2때문에 안되는 것!) PK 때문
INSERT INTO TBL_TEST5(COL1,COL2) VALUES(2,'KKKK');      --> 에러 발생                           PK 때문
INSERT INTO TBL_TEST5(COL1,COL2) VALUES(5,'ABCD');  -- CHECK~!!    --> 에러 발생 --> 제약조건 이름 달아야하는 이유!(어디에서 오류나는지 확인하기 위해 )
INSERT INTO TBL_TEST5(COL1,COL2) VALUES(NULL,NULL);     --> 에러 발생 (NULL 안된다!)
INSERT INTO TBL_TEST5(COL1,COL2) VALUES(NULL, 'STUDY');  --> 에러 발생
INSERT INTO TBL_TEST5(COL2) VALUES('STUDY');             --> 에러 발생


COMMIT;
--==>> 커밋 완료.

SELECT *
FROM TBL_TEST5;
--==>>
/*
1	TSET
2	ABCD
3	
4	
*/


--○ UK 지정 실습(② 테이블 레벨의 형식)
-- 테이블 생성
CREATE TABLE TBL_TEST6
( COL1  NUMBER(5)
, COL2 VARCHAR(30)
, CONSTRAINT TEST6_COL1_PK PRIMARY KEY(COL1)
, CONSTRAINT TEST6_COL2_UK UNIQUE(COL2)
);
--==>> Table TBL_TEST6이(가) 생성되었습니다.


-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST6';
--==>>
/*
HR	TEST6_COL1_PK	TBL_TEST6	P	COL1		
HR	TEST6_COL2_UK	TBL_TEST6	U	COL2		
*/


--○ UK 지정 실습(③ 테이블 생성 이후 제약조건 추가)
-- 테이블 생성
CREATE TABLE TBL_TEST7
( COL1  NUMBER(5)
, COL2 VARCHAR(30)
);
--==>> Table TBL_TEST7이(가) 생성되었습니다.

-- 제약조건 확인(조회)
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST7';
--==>> 조회 결과 없음 → 제약조건을 설정하지 않았음


-- 제약 조건 추가
ALTER TABLE TBL_TEST7
ADD ( CONSTRAINT TEST7_COL1_PK PRIMARY KEY(COL1)
    , CONSTRAINT TEST7_COL2_UK UNIQUE(COL2));
--==>> Table TBL_TEST7이(가) 변경되었습니다.


-- 제약조건 확인(조회)
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST7';
--==>>
/*
HR	TEST7_COL1_PK	TBL_TEST7	P	COL1		
HR	TEST7_COL2_UK	TBL_TEST7	U	COL2		
*/

--------------------------------------------------------------------------------

--■■■ CHECK(CK:C) ■■■--

-- 1. 컬럼에서 허용 가능한 데이터의 범위나 조건을 지정하기 위한 제약조건
--    컬럼에 입력되는 데이터를 검사하여 조건에 맞는 데이터만 입력될 수 있도록 처리하며,
--    수정되는 데이터 또한 검사하여 조건에 맞는 데이터로 수정되는 것만 허용하는
--    기능을 수행하게 된다.

--2. 형식 및 구조
-- ① 컬럼 레벨의 형식
-- 컬럼명 데이터 타입 [CONSTRAINT CONSTRAINT명] CHEKC (컬럼 조건)

-- ② 테이블 레벨의 형식
-- 컬럼명 데이터타입
--, 컬럼명 데이터 타입
--, CONSTRAINT CONSRAINT명 CHECK(컬럼 조건)

--  -99999999999999999999999999999999999999 ~ 99999999999999999999999999999999999999

--※ NUMBER(38)        까지...
--   CHAR(2000)        까지...
--   VARCHAR2(4000)    까지...
--   NCHAR(1000)       까지...
--   NVARCHAR2(2000)   까지...
-- 외울 필요는 없고!1 그때그때 길이 길게해서 찍어보면 알수 있음!!
/*
CREATE TABLE OHOH
( COL1  NUMBER(999999999999999999999999999999999999999999999999999999999999999999999999999)
);
--==>>
ORA-01727: numeric precision specifier is out of range (1 to 38)
01727. 00000 -  "numeric precision specifier is out of range (1 to 38)"
*/


--○ CK 지정 실습(① 컬럼 레벨의 형식)
-- 테이블 생성
CREATE TABLE TBL_TEST8
( COL1  NUMBER(5)   PRIMARY KEY
, COL2  VARCHAR2(30)
, COL3  NUMBER(3)   CHECK(COL3 BETWEEN 0 AND 100)       -- → -999 ~ 999 
);
---==>> Table TBL_TEST8이(가) 생성되었습니다.

-- 데이터 입력
INSERT INTO TBL_TEST8(COL1, COL2, COL3) VALUES(1, '승균', 100);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST8(COL1, COL2, COL3) VALUES(2, '범석', 101);   --> 에러발생   
INSERT INTO TBL_TEST8(COL1, COL2, COL3) VALUES(3, '진희', -1);    --> 에러 발생
INSERT INTO TBL_TEST8(COL1, COL2, COL3) VALUES(4, '지윤', 80);
--==>> 1 행 이(가) 삽입되었습니다.

COMMIT;
--==>> 커밋 완료.

SELECT *
FROM TBL_TEST8;
--==>>
/*
1	승균	100
4	지윤	80
*/

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME='TBL_TEST8';
--==>>
/*
HR	SYS_C007067	TBL_TEST8	C	COL3	COL3 BETWEEN 0 AND 100	
HR	SYS_C007068	TBL_TEST8	P	COL1		
*/


--○ CK 지정 실습(② 테이블 레벨의 형식)
-- 테이블 생성
CREATE TABLE TBL_TEST9
( COL1  NUMBER(5)
, COL2  VARCHAR(30)
, COL3  NUMBER(3)
, CONSTRAINT TEST9_COL1_PK PRIMARY KEY(COL1)
, CONSTRAINT TEST9_COL3_CK CHECK(COL3 BETWEEN 0 AND 100)
);
--==>> Table TBL_TEST9이(가) 생성되었습니다.


-- 데이터 입력
INSERT INTO TBL_TEST9(COL1, COL2, COL3) VALUES(1, '승균', 100);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_TEST9(COL1, COL2, COL3) VALUES(2, '범석', 101);   --> 에러발생   
INSERT INTO TBL_TEST9(COL1, COL2, COL3) VALUES(3, '진희', -1);    --> 에러 발생
INSERT INTO TBL_TEST9(COL1, COL2, COL3) VALUES(4, '지윤', 80);
--==>> 1 행 이(가) 삽입되었습니다.

COMMIT;
--==>> 커밋 완료.


SELECT *
FROM TBL_TEST9;
--==>>
/*
1	승균	100
4	지윤	80
*/

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST9';
--==>>
/*
HR	TEST9_COL3_CK	TBL_TEST9	C	COL3	COL3 BETWEEN 0 AND 100	
HR	TEST9_COL1_PK	TBL_TEST9	P	COL1		
*/
-- 위에와 다른점은 제약조건의 이름을 지정해줌!!



--○ CK 지정 실습(③ 테이블 생성 이후 제약조건 추가)
-- 테이블 생성
CREATE TABLE TBL_TEST10
( COL1  NUMBER(5)
, COL2  VARCHAR(30)
, COL3  NUMBER(3)
);
--==>> Table TBL_TEST10이(가) 생성되었습니다.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST10';
--==>> 조회결과 없음 → 지정된 제약조건 없음

--제약조건 추가
ALTER TABLE TBL_TEST10
ADD ( CONSTRAINT TEST10_COL1_PK PRIMARY KEY(COL1)
    , CONSTRAINT TEST10_COL3_CK CHECK(COL3 BETWEEN 0 AND 100) );
--==>> Table TBL_TEST10이(가) 변경되었습니다.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST10';
--==>>
/*
HR	TEST10_COL1_PK	TBL_TEST10	P	COL1		
HR	TEST10_COL3_CK	TBL_TEST10	C	COL3	COL3 BETWEEN 0 AND 100	
*/


--○ 실습 문제
-- 다음과 같이 TBL_TESTMEMBER 테이블을 생성하여
-- SSN컬럼(주민번호 컬럼)에서
-- 데이터 입력 시 성별이 유효한 데이터만 입력될 수 있도록
-- 체크 제약조건을 추가할 수 있도록 한다.
-- → 주민번호 특정 자리에 입력 가능한 데이터로 1,2,3,4 를 적용
-- 또한, SID 컬럼에는 PRIMARY KEY 제약조건을 설정할 수 있도록 한다.

-- 테이블 생성
CREATE TABLE TBL_TESTMEMBER
( SID   NUMBER
, NAME  VARCHAR(30)         --                      |
, SSN   CHAR(14)            -- 입력 형태 → 'YYMMDD-NNNNNNN'
, TEL   VARCHAR2(40)
);
--==>> Table TBL_TESTMEMBER이(가) 생성되었습니다.

ALTER TABLE TBL_TESTMEMBER
ADD( CONSTRAINT TESTMEMBER_SID_PK PRIMARY KEY(SID)
   , CONSTRAINT TESTMEMBER_SSN_CK CHECK(SUBSTR(SSN,8,1) IN('1','2','3','4')) );      -- OR / IN / =ANY 
--==>> Table TBL_TESTMEMBER이(가) 변경되었습니다.

INSERT INTO TBL_TESTMEMBER(SID,NAME,SSN,TEL) VALUES(1,'정효진', 451205-7856985,01045457878);
--==>> 에러 발생
/*
INSERT INTO TBL_TESTMEMBER(SID,NAME,SSN,TEL) VALUES(1,'정효진', 451205-7856985,01045457878)
오류 보고 -
ORA-02290: check constraint (HR.TESTMEMBER_SSN_CK) violated
*/

-- 제약조건 조회
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TESTMEMBER';
--==>>
/*
HR	TESTMEMBER_SID_PK	TBL_TESTMEMBER	P	SID		
HR	TESTMEMBER_SSN_CK	TBL_TESTMEMBER	C	SSN	SUBSTR(SSN,8,1) IN(1,2,3,4)	
*/

-- !!!!!!!!!!!!!!!!!!! 다하고 보니까 숫자에 ' ' 를 안함!!!!!!!!!!!!!!!!!
-- ★제약조건은 수정을 못함!!★ 제거하고 다시 만들어야함 DROP!

-- ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
ALTER TABLE TBL_TESTMEMBER DROP CONSTRAINT TESTMEMBER_SSN_CK;
--==>> Table TBL_TESTMEMBER이(가) 변경되었습니다.

-- 다시 CHECK 제약조건 입력!
ALTER TABLE TBL_TESTMEMBER
ADD(CONSTRAINT TESTMEMBER_SSN_CK CHECK(SUBSTR(SSN,8,1) IN('1','2','3','4')) );
--==>> Table TBL_TESTMEMBER이(가) 변경되었습니다.

-- 제약조건 조회
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TESTMEMBER';
--==>>
/*
HR	TESTMEMBER_SID_PK	TBL_TESTMEMBER	P	SID		
HR	TESTMEMBER_SSN_CK	TBL_TESTMEMBER	C	SSN	SUBSTR(SSN,8,1) IN('1','2','3','4')	
*/

-- 입력 테스트
INSERT INTO TBL_TESTMEMBER(SID,NAME,SSN,TEL) 
VALUES(1,'박효빈', '980611-2234567','010-1111-1111');
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_TESTMEMBER(SID,NAME,SSN,TEL) 
VALUES(2,'손다정', '940603-2234567','010-2222-2222');
--==>> 1 행 이(가) 삽입되었습니다.

SELECT *
FROM TBL_TESTMEMBER;

COMMIT;
--==>> 커밋 완료.


INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)
VALUES(3,'이찬호', '941108-1234567', '010-3333-3333');
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)
VALUES(4,'손범석', '960816-5234567', '010-4444-4444');
--==>> 에러 발생
/*
NSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)
VALUES(4,'손범석', '960816-5234567', '010-4444-4444')
오류 보고 -
ORA-02290: check constraint (HR.TESTMEMBER_SSN_CK) violated
*/

INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)
VALUES(5,'이다영', '951027-9234567', '010-5555-5555');
--==>>
/*
명령의 724 행에서 시작하는 중 오류 발생 -
INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)
VALUES(5,'이다영', '951027-9234567', '010-5555-5555')
오류 보고 -
ORA-02290: check constraint (HR.TESTMEMBER_SSN_CK) violated
*/

--3,4 도 테스트 해보기!!
/*
INSERT INTO TBL_TESTMEMBER(SID, NAME, SSN, TEL)
VALUES(5,'정효진','950105-3456789','010-6666-6666');

INSERT INTO TBL_TESTMEMBER(SID, NAME,SSN, TEL)
VALUES(6,'정효','941231-4456789','010-7777-7777');

DELETE
FROM TBL_TESTMEMBER
WHERE NAME = '정효';
*/

--
SELECT *
FROM TBL_TESTMEMBER;
--==>>
/*
1	박효빈	980611-2234567	010-1111-1111
2	손다정	940603-2234567	010-2222-2222
3	이찬호	941108-1234567	010-3333-3333
*/

--------------------------------------------------------------------------------
--?? 1정규화 하고 나서 테이블 쪼개지면서 식별자를 같게 해야해서 PRIMARY키를 설정해야함!! 알아서 생기는 것 아님!!


-- ■■■ FOREIGN KEY(FK:F:R) ■■■--
-- 다른 제약조건과 형식이 조금 다름!!

-- 1. 참조 키 또는 외래 키(FK)는
--    두 테이블의 데이터 간 연결을 설정하고
--    강제 적용시키는데 사용되는 열이다.
--    한 테이블의 기본 키 값이 있는 열을
--    다른 테이블에 추가하면 테이블 간 연결을 설정할 수 있다.
--    이 때, 두 번째 테이블에 추가되는 열이 외래키가 된다.

-- 2. 부모 테이블(참조받는 컬럼이 포함된 테이블)이 먼저 생성된 후
--    자식 테이블(참조하는 컬럼이 포함된 테이블)이 생성되어야 한다.
--    이 때, 자식 테이블에 FOREIGN KEY 제약조건이 설정된다.

-- 3. 형식 및 구조
-- ① 컬럼 레벨의 형식
--   컬럼 명 테이터 타입 [CONSTRAINT CONSTRAINT명]
--                       REFERENCES 참조테이블명(참조컬럼명)
--                       [ON DELETE CASCADE | ON DELETE SET NULL]

-- ② 테이블 레벨의 형식
--  컬럼명 데이터 타입
-- , 컬럼명 데이터 타입
-- , CONSTRAINT CONSTRAINT명 FOREIGN KEY(컬럼명)
--              REFERENCES 참조테이블명(참조컬럼명)
--              [ON DELETE CASCADE | ON DELETE SET NULL]    



--※ FOREIGN KEY 제약조건을 설정하는 실습을 진행하기 위해서는
--   독립적인 하나의 테이블을 생성하여 처리하는 것이 아니라
--   부모 테이블 생성 작업을 먼저 수행해야 한다.
--   그리고 이 때, 부모 테이블에는 반드시 PK 또는 UK 제약조건이
--   설정된 컬럼이 존재해야 한다.


-- 테이블 생성
CREATE TABLE TBL_JOBS
( JIKWI_ID      NUMBER(5)
, JIKWI_NAME    VARCHAR(30)
, CONSTRAINT JOBS_ID_PK PRIMARY KEY(JIKWI_ID)
);
--==>> Table TBL_JOBS이(가) 생성되었습니다.

-- 부모 테이블에 데이터 입력
INSERT INTO TBL_JOBS(JIKWI_ID, JIKWI_NAME) VALUES(1,'사원');
INSERT INTO TBL_JOBS(JIKWI_ID, JIKWI_NAME) VALUES(2,'대리');
INSERT INTO TBL_JOBS(JIKWI_ID, JIKWI_NAME) VALUES(3,'과장');
INSERT INTO TBL_JOBS(JIKWI_ID, JIKWI_NAME) VALUES(4,'부장');
--==>> 1 행 이(가) 삽입되었습니다. * 4
SELECT *
FROM TBL_JOBS;
--==>>
/*
1	사원
2	대리
3	과장
4	부장
*/

COMMIT;
--==>> 커밋 완료.


--○ FK 지정 실습(① 컬럼 레벨의 형식)
-- FORIGN이라는 단어 등장하지 않음!!
-- 테이블 생성
CREATE TABLE TBL_EMP1
( SID       NUMBER(5)       PRIMARY KEY
, NAME      VARCHAR2(30)
, JIKWI_ID  NUMBER(5)       REFERENCES TBL_JOBS(JIKWI_ID)
);
--==>> Table TBL_EMP1이(가) 생성되었습니다.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP1';
--==>> 
/*
HR	SYS_C007077	TBL_EMP1	P	SID		
HR	SYS_C007078	TBL_EMP1	R	JIKWI_ID		NO ACTION       -- DELETE_RULE에 NO ACTION 이 생김!
*/

-- 데이터 입력
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(1,'최현정',1);    --현정이가 사원이라는 뜻!
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(2,'최수지',2);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(3,'정가연',3);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(4,'이다영',4);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(5,'손범석',5);    --에러 발생(세번째 컬럼 때문!! 부모에는 4까지밖에 없음!)
/*
명령의 838 행에서 시작하는 중 오류 발생 -
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(5,'손범석',5)
오류 보고 -
ORA-02291: integrity constraint (HR.SYS_C007078) violated - parent key not found
*/
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(5,'손범석',1);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_EMP1(SID, NAME) VALUES(6,'정효진');                    --인턴예시 생각하면 이거 가능하다! (대신 JIKWI_ID 안적어야함!)
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_EMP1(SID, NAME, JIKWI_ID) VALUES(7,'손다정', NULL);    --위와 같은 구문!
--==>> 1 행 이(가) 삽입되었습니다.

SELECT *
FROM TBL_EMP1;
--==>>
/*
1	최현정	1
2	최수지	2
3	정가연	3
4	이다영	4
5	손범석	1
6	정효진	
7	손다정	
*/

COMMIT;
--==>> 커밋 완료.

--○ FK 지정 식습(② 테이블 레벨의 형식)
CREATE TABLE TBL_EMP2
( SID       NUMBER(5)
, NAME      VARCHAR2(30)
, JIKWI_ID  NUMBER(5)
, CONSTRAINT EMP2_SID_PK PRIMARY KEY(SID)
, CONSTRAINT EMP2_JIKWI_ID_FK FOREIGN KEY(JIKWI_ID)
             REFERENCES TBL_JOBS(JIKWI_ID)
);
--==>> Table TBL_EMP2이(가) 생성되었습니다.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP2';
--==>>
/*
HR	EMP2_SID_PK	TBL_EMP2	P	SID		
HR	EMP2_JIKWI_ID_FK	TBL_EMP2	R	JIKWI_ID		NO ACTION
*/

--○ FK 지정 식습(③ 테이블 생성 이후 제약조건 추가)
-- 테이블 생성
CREATE TABLE TBL_EMP3
( SID       NUMBER(3)
, NAME      VARCHAR2(30)
, JIKWI_ID  NUMBER(5)
);
--==>> Table TBL_EMP3이(가) 생성되었습니다.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP3';
--==>> 조건 결과 없음 → 제약조건 설정되어 있지 않음

-- 제약 조건 추가
ALTER TABLE TBL_EMP3
ADD( CONSTRAINT EMP3_SID_PK PRIMARY KEY(SID)
    , CONSTRAINT EMP3_JIKWI_ID_FK FOREIGN KEY(JIKWI_ID)
                 REFERENCES TBL_JOBS(JIKWI_ID) );
--==>> Table TBL_EMP3이(가) 변경되었습니다.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP3';
--==>>
/*
HR	EMP3_SID_PK	        TBL_EMP3	P	SID		
HR	EMP3_JIKWI_ID_FK	TBL_EMP3	R	JIKWI_ID		NO ACTION
*/

-- 4. FOREIGN KEY 생성 시 주의사항
--    참조하고자 하는 부모 테이블을 먼저 생성해야 한다.
--    참조하고자 하는 테이블의 대상 컬럼이
--    PRIMARY KEY 나 UNIQUE 제약조건이 있어야 한다.
--    테이블 사이에 PRIMARY KEY 나 FOREIGN KEY 가 정의되어 있으면
--    PRIMARY KEY 제약조건이 설정된 컬럼의 데이터 삭제 시
--    FOREIGN KEY 컬럼에 그 값이 입력되어 있는 경우 삭제되지 않는다.
--    (단, FK 설정 과정에서 『ON DELETE CASECADE』 나
--    『ON DELETE SET NULL』 옵션을 사용하여 설정한 경우에는
--    삭제가 가능하다.)
--    부모 테이블을 제거하기 위해서는 자식 테이블들 먼저 제거해야 한다.


--부모 테이블
SELECT *
FROM TBL_JOBS;
--==>>
/*
1	사원
2	대리
3	과장
4	부장
*/

--자식 테이블
SELECT *
FROM TBL_EMP1;
--==>>
/*
1	최현정	1
2	최수지	2
3	정가연	3
4	이다영	4
5	손범석	1
6	정효진	
7	손다정	
*/

-- 이다영 부장의 직위를 사원으로 변경
UPDATE TBL_EMP1
SET JIKWI_ID=1
WHERE SID = 4;
--==>> 1 행 이(가) 업데이트되었습니다.

-- 확인
SELECT *
FROM TBL_EMP1;
--==>>
/*
1	최현정	1
2	최수지	2
3	정가연	3
4	이다영	1
5	손범석	1
6	정효진	
7	손다정	
*/


-- 커밋
COMMIT;
--==>> 커밋 완료.


-- 부모 테이블(TBL_JOBS)의 부장 데이터를 참조하고 있는
-- 자식 테이블(TBL_EMP1)의 데이터가 존재하지 않는 상황.

-- 이와 같은 상황에서 부모 테이블(TBL_JOBS)의
-- 부장 데이터 삭제
DELETE
FROM TBL_JOBS
WHERE JIKWI_ID=4;
--==>> 1 행 이(가) 삭제되었습니다.

--확인
SELECT *
FROM TBL_JOBS;
--==>>
/*
1	사원
2	대리
3	과장
*/

-- 커밋
COMMIT;
--==>> 커밋 완료.


-- 부모 테이블(TBL_JOBS)의 사원 데이터를 참조하고 있는
-- 자식 테이블(TBL_EMP1)의 데이터가 3건 존재하고 있는 상황.

-- 이와 같은 상황에서 부모 테이블(TBL_JOBS)의
--  사원 데이터 삭제
DELETE
FROM TBL_JOBS
WHERE JIKWI_ID = 1;
--==>> 에러 발생
/*
명령의 1,021 행에서 시작하는 중 오류 발생 -
DELETE
FROM TBL_JOBS
WHERE JIKWI_ID = 1
오류 보고 -
ORA-02292: integrity constraint (HR.SYS_C007078) violated - child record found
*/

--그러면 부모 테이블(TBL_JOBS) 제거
DROP TABLE TBL_JOBS;
--==>> 에러 발생
/*
명령의 1,035 행에서 시작하는 중 오류 발생 -
DROP TABLE TBL_JOBS
오류 보고 -
ORA-02449: unique/primary keys in table referenced by foreign keys
02449. 00000 -  "unique/primary keys in table referenced by foreign keys"
*Cause:    An attempt was made to drop a table with unique or
           primary keys referenced by foreign keys in another table.
*Action:   Before performing the above operations the table, drop the
           foreign key constraints in other tables. You can see what
           constraints are referencing a table by issuing the following
           command:
           SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = "tabnam";
*/

--※ 부모 테이블의 데이터를 자유롭게 삭제하기 위해서는
-- 『ON DELETE CASECADE』 옵션 지정이 필요하다.

-- TBL_EMP1 테이블(자식 테이블)에서 FK 제약조건을 제거한 후
-- CASCADE 옵션을 포함하여 다시 FK 제약조건을 설정한다.

--○ 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP1';
--==>>
/*
HR	SYS_C007077	TBL_EMP1	P	SID		
HR	SYS_C007078	TBL_EMP1	R	JIKWI_ID		NO ACTION
*/

--○ 제약조건 제거
ALTER TABLE TBL_EMP1
DROP CONSTRAINT SYS_C007078;    -- 이래서 제약조건명 명명해주는 것이 좋음!
--==>> Table TBL_EMP1이(가) 변경되었습니다.

--○ 제약조건 제거 이후 다시 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME =  'TBL_EMP1';
--==>> HR	SYS_C007077	TBL_EMP1	P	SID		


--○ 『ON DELETE CASCADE』 옵션이 포함된 내용으로 제약조건 재지정
ALTER TABLE TBL_EMP1
ADD CONSTRAINT EMP1_JIKWIID_FK FOREIGN KEY(JIKWI_ID)
               REFERENCES TBL_JOBS(JIKWI_ID)
               ON DELETE CASCADE;
--==>> Table TBL_EMP1이(가) 변경되었습니다.


--○ 제약조건 재지정 이후 다시 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_EMP1';
--==>>
/*
HR	SYS_C007077	        TBL_EMP1	P	SID		
HR	EMP1_JIKWIID_FK	    TBL_EMP1	R	JIKWI_ID		CASCADE     --이전까지는 NO ACTION 이었는데 CASCADE로 바뀜!
*/

--> CASCADE 옵셥을 지정한 후에는
--  참조받고 있는 부모 테이블의 데이터를
--  언제든지 제한없이 삭제하는 것이 가능하다.
--  단, ... ... ... 부모 테이블의 데이터가 삭제될 경우
--  이를 참조하는 자식 테이블의 데이터도 모~~~~~~두 함께 삭제된다.
--  CHECK~!!!

-- 부모 테이블
SELECT *
FROM TBL_JOBS;
--==>>
/*
1	사원
2	대리
3	과장
*/

-- 자식 테이블
SELECT *
FROM TBL_EMP1;
--==>>
/*
1	최현정	1     ←
2	최수지	2
3	정가연	3
4	이다영	1     ←
5	손범석	1     ←
6	정효진	
7	손다정	
*/

--○ TBL_JOBS(부모 테이블)의 사원 데이터 삭제
DELETE
FROM TBL_JOBS
WHERE JIKWI_ID=1;
--==>> 1 행 이(가) 삭제되었습니다.
-- 자식이 있는데도 지워짐!! ON DELETE CASCADE!

-- 부모 테이블
SELECT *
FROM TBL_JOBS;
--==>>
/*
2	대리
3	과장
*/

-- 자식 테이블
SELECT *
FROM TBL_EMP1;
--==>>
/*
2	최수지	2
3	정가연	3
6	정효진	
7	손다정	
*/



-- 지금은 3건이어서 그렇지 실무에서는 회원등급 몇만건 몇백만건 이러면 큰일
-- 그래서 정말 필요할 때만 써야함!! 엄청 위험한 옵션!!
--------------------------------------------------------------------------------

-- ■■■ NOT NULL(NN:CK:C) ■■■--

-- 1. 테이블에서 지정한 컬럼의 데이터가 NULL 을 갖지 못하도록 하는 제약조건.

-- 2. 형식 및 구조           -- NOT NULL 제약조건만큼은 컬럼 레벨 형식을 사용하자!!!
-- ① 컬럼 레벨의 형식       -- (다른 제약조건은 테이블 형식으로!)
-- 컬럼명 데이터 타입 [CONSTRAINT CONSTRAINT명] NOT NULL

-- ② 테이블 레벨의 형식
-- 컬럼명 데이터타입
--, 컬럼명 데이터타입
--, CONSTRAINT CONSTRAINT명 CHECK(컬럼명 IS NOT NULL)

-- 3. 기존에 생성되어 있는 테이블에 NOT NULL 제약조건을 추가할 경우
--    ADD 보다 MODIFY 절이 더 많이 사용된다.       -- CHECK~!!!

-- ALTER TABLE 테이블명
-- MODIFY 컬럼명 데이터타입 NOT NULL;

-- 4. 기존 테이블에 데이터가 이미 들어있지 않은 컬럼(→ NULL 인 상태)을
--    NOT NULL 제약조건을 갖게끔 수정하는 경우에는 에러 발생한다.


--○ NOT NULL 지정 실습(① 컬럼 레벨의 형식)
-- 테이블 생성
CREATE TABLE TBL_TEST11
( COL1      NUMBER(5)       PRIMARY KEY
, COL2      VARCHAR2(30)    NOT NULL
);
--==>> Table TBL_TEST11이(가) 생성되었습니다.

--테이블 확인
SELECT *
FROM TAB;

-- 데이터 입력
INSERT INTO TBL_TEST11(COL1, COL2) VALUES(1, 'TEST');
INSERT INTO TBL_TEST11(COL1, COL2) VALUES(2, 'ABCD');
INSERT INTO TBL_TEST11(COL1, COL2) VALUES(3, NULL); --> 에러 발생
INSERT INTO TBL_TEST11(COL1) VALUES(4);             --> 에러 발생

SELECT *
FROM TBL_TEST11;
--==>>
/*
1	TEST
2	ABCD
*/

COMMIT;
--==>> 커밋 완료.


--제약 조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST11';
--==>>
/*
HR	SYS_C007084	TBL_TEST11	C	COL2	"COL2" IS NOT NULL	
HR	SYS_C007085	TBL_TEST11	P	COL1		
*/

--○ NOT NULL 지정 실습(② 테이블 레벨의 형식)
-- 테이블 생성
CREATE TABLE TBL_TEST12
( COL1      NUMBER(5)
, COL2      VARCHAR2(30)
, CONSTRAINT TEST12_COL1_PK PRIMARY KEY(COL1)
, CONSTRAINT TEST12_COL2_NN CHECK(COL2 IS NOT NULL)
);
--==>> Table TBL_TEST12이(가) 생성되었습니다.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST12';
--==>>
/*
HR	TEST12_COL2_NN	TBL_TEST12	C	COL2	COL2 IS NOT NULL	
HR	TEST12_COL1_PK	TBL_TEST12	P	COL1		
*/


--○ NOT NULL 지정 실습(③ 테이블 생성 이후 제약조건 추가)
-- 테이블 생성
CREATE TABLE TBL_TEST13
( COL1   NUMBER(5)
, COL2  VARCHAR2(30)
);
--==>> Table TBL_TEST13이(가) 생성되었습니다.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST13';
--==>> 조회 결과 없음 → 제약조건이 설정되지 않음

--제약 조건 추가
ALTER TABLE TBL_TEST13
ADD( CONSTRAINT TEST13_COL1_PK PRIMARY KEY(COL1)
    , CONSTRAINT TEST13_COL2_NN CHECK(COL2 IS NOT NULL) );
--==>> Table TBL_TEST13이(가) 변경되었습니다.

-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST13';
--==>> 
/*
HR	TEST13_COL1_PK	TBL_TEST13	P	COL1		
HR	TEST13_COL2_NN	TBL_TEST13	C	COL2	COL2 IS NOT NULL	
*/


--※ NOT NULL 제약조건만 TBL_TEST13 테이블의 COL2 에 추가하는 경우
-- 다음과 같은 방법도 가능하다.
ALTER TABLE TBL_TEST13
MODIFY COL2 NOT NULL;
--==>> Table TBL_TEST13이(가) 변경되었습니다.




-- TBL_TEST11 / TBL_TEST12 / TBL_TEST13

-- 컬럼 레벨에서 NOT NULL  제약조건을 지정한 테이블
DESC TBL_TEST11;
--==>>
/*
이름   널?       유형           
---- -------- ------------ 
COL1 NOT NULL NUMBER(5)    
COL2 NOT NULL VARCHAR2(30) 
*/
--> DESC 를 통해 COL2 컬럼이  NOT NULL 인 정보가 확인되는 상황

-- 테이블 레벨에서 NOT NULL  제약조건을 지정한 테이블
DESC TBL_TEST12;
--==>>
/*
이름   널?       유형           
---- -------- ------------ 
COL1 NOT NULL NUMBER(5)    
COL2          VARCHAR2(30)      -- 여기에는 NOT NULL 로 안나옴!\
*/
--> DESC 를 통해 COL2 컬럼이 NOT NULL 인 정보가 확인되지 않은 상황


-- 테이블 생성 이후 ADD 를 통해 NOT NULL 제약조건을 추가하였으며
-- 또한, MODIFY 절을 통해 NOT NULL 제약조건을 다시 추가한 테이블
DESC TBL_TEST13;
--==>>
/*
이름   널?       유형           
---- -------- ------------ 
COL1 NOT NULL NUMBER(5)    
COL2 NOT NULL VARCHAR2(30) 
*/
--> DESC 를 통해 COL2 컬럼이  NOT NULL 인 정보가 확인되는 상황


-- 제약조건 확인 전용 뷰(VIEW) 조회
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME IN('TBL_TEST11', 'TBL_TEST12', 'TBL_TEST13');
--==>>
/*
HR	SYS_C007084	    TBL_TEST11	C	COL2	"COL2" IS NOT NULL	
HR	SYS_C007085	    TBL_TEST11	P	COL1		
HR	TEST12_COL2_NN	TBL_TEST12	C	COL2	COL2 IS NOT NULL	
HR	TEST12_COL1_PK	TBL_TEST12	P	COL1		
HR	TEST13_COL1_PK	TBL_TEST13	P	COL1		
HR	TEST13_COL2_NN	TBL_TEST13	C	COL2	COL2 IS NOT NULL	
HR	SYS_C007090	    TBL_TEST13	C	COL2	"COL2" IS NOT NULL	
*/
--> 이렇게 조회되는 결과가 다르게 나오기 때문에 컬럼 레벨로 입력하는 것이 좋음!


