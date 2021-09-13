SELECT USER
FROM DUAL;
--==>>HR


--○ EMPLOYEES 테이블에서 SALARY를
--   각 부서의 이름별로 다른 인상률을 적용하여 수정할 수 있도록 한다.
--   Finance → 10%
--   Executive → 15%
--   Accounting → 20%
--   (쿼리문 구성 및 결과 확인 후 ROLLBACK)

--   나머지 → 0%

SELECT *
FROM DEPARTMENTS;
SELECT *
FROM EMPLOYEES;

UPDATE EMPLOYEES
SET SALARY =  CASE DEPARTMENT_ID WHEN (SELECT DEPARTMENT_ID
                                        FROM DEPARTMENTS
                                        WHERE DEPARTMENT_NAME = 'Finance') 
                               THEN SARARY*1.1
             CASE DEPARTMENT_ID WHEN (SELECT DEPARTMENT_ID
                                        FROM DEPARTMENTS
                                        WHERE DEPARTMENT_NAME = 'Executive') 
                               THEN SALARY*1.15
            CASE DEPARTMENT_ID WHEN (SELECT DEPARTMENT_ID
                                        FROM DEPARTMENTS
                                        WHERE DEPARTMENT_NAME = 'Accounting') 
                               THEN SALARY*1.2
                               ELSE SALARY END "인상된급여";

SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Finance';

SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Executive';

SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Accounting';

--풀이-------------------------------------------------------------------------
-- 메모리는 이렇게 하는게 더 아낄수 있음!
UPDATE EMPLOYEES
SET SALARY = CASE DEPARTMENT_ID WHEN ('Finance'의 부서아이디) 
                                 THEN SALARY * 1.1 
                                 WHEN ('Executive'의 부서아이디) 
                                 THEN SALARY * 1.15 
                                 WHEN ('Accounting'의 부서아이디) 
                                 THEN SALARY * 1.2 
                                 ELSE SALARY 
              END 
WHERE DEPARTMENT_ID IN ('Finance'의 부서아이디,'Executive'의 부서아이디, 'Accounting'의 부서아이디);


--WHERE절 빼도 똑같은 구문!
UPDATE EMPLOYEES
SET SALARY = CASE DEPARTMENT_ID_ID WHEN ('Finance'의 부서아이디) 
                                 THEN SALARY * 1.1 
                                 WHEN ('Executive'의 부서아이디) 
                                 THEN SALARY * 1.15 
                                 WHEN ('Accounting'의 부서아이디) 
                                 THEN SALARY * 1.2 
                                 ELSE SALARY 
              END;


-- ('Finance'의 부서아이디)
SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Finance';
--==>> 100

-- ('Executive'의 부서아이디)
SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Executive';
--==>> 90

-- ('Accounting'의 부서아이디)
SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Accounting';
--==>> 110


-- 넣어주기!
UPDATE EMPLOYEES
SET SALARY = CASE DEPARTMENT_ID WHEN (SELECT DEPARTMENT_ID
                                FROM DEPARTMENTS
                                WHERE DEPARTMENT_NAME = 'Finance') 
                                 THEN SALARY * 1.1 
                                 WHEN (SELECT DEPARTMENT_ID
                                FROM DEPARTMENTS
                                WHERE DEPARTMENT_NAME = 'Executive') 
                                 THEN SALARY * 1.15 
                                 WHEN (SELECT DEPARTMENT_ID
                                FROM DEPARTMENTS
                                WHERE DEPARTMENT_NAME = 'Accounting') 
                                 THEN SALARY * 1.2 
                                 ELSE SALARY 
              END 
WHERE DEPARTMENT_ID IN ((SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE DEPARTMENT_NAME = 'Finance')
                        ,(SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE DEPARTMENT_NAME = 'Executive')
                        , (SELECT DEPARTMENT_ID
                            FROM DEPARTMENTS
                            WHERE DEPARTMENT_NAME = 'Accounting'));
--==>> 11개 행 이(가) 업데이트되었습니다.
-- IN 안에 괄호로 묶어줘야함!

ROLLBACK;

SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN(90,100,110);
--==>> 11개 확인

--WHERE절 없이!
UPDATE EMPLOYEES
SET SALARY = CASE DEPARTMENT_ID_ID WHEN (SELECT DEPARTMENT_ID
                                        FROM DEPARTMENTS
                                        WHERE DEPARTMENT_NAME = 'Finance') 
                                 THEN SALARY * 1.1 
                                 WHEN (SELECT DEPARTMENT_ID
                                        FROM DEPARTMENTS
                                        WHERE DEPARTMENT_NAME = 'Executive') 
                                 THEN SALARY * 1.15 
                                 WHEN (SELECT DEPARTMENT_ID
                                        FROM DEPARTMENTS
                                        WHERE DEPARTMENT_NAME = 'Accounting') 
                                 THEN SALARY * 1.2 
                                 ELSE SALARY 
              END; 
--==>> 107개 업데이트 되어야함!

ROLLBACK;



-- WHERE 절 더 줄이기!
UPDATE EMPLOYEES
SET SALARY = CASE DEPARTMENT_ID WHEN (SELECT DEPARTMENT_ID
                                        FROM DEPARTMENTS
                                        WHERE DEPARTMENT_NAME = 'Finance') 
                                 THEN SALARY * 1.1 
                                 WHEN (SELECT DEPARTMENT_ID
                                        FROM DEPARTMENTS
                                        WHERE DEPARTMENT_NAME = 'Executive') 
                                 THEN SALARY * 1.15 
                                 WHEN (SELECT DEPARTMENT_ID
                                        FROM DEPARTMENTS
                                        WHERE DEPARTMENT_NAME = 'Accounting') 
                                 THEN SALARY * 1.2 
                                 ELSE SALARY 
              END
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                                        FROM DEPARTMENTS
                                        WHERE DEPARTMENT_NAME IN('Finance','Executive','Accounting'));
--==>>11개 행 이(가) 업데이트되었습니다.

ROLLBACK;
--==>> 롤백 완료.


--■■■ DELETE ■■■--

-- 1. 테이블에서 지정된 행(레코드)을 삭제하는 데 사용하는 구문.

-- 2. 형식 및 구조
-- DELETE [FROM] 테이블명
-- [WHERE 조건절]; --조건을 명시하고 SELECT로 확인한다음에 지우자!

SELECT *
FROM EMPLOYEES
WHERE EMPLOYEE_ID = 198;
--==>> 198	Donald	OConnell	DOCONNEL	650.507.9833	07/06/21	SH_CLERK	2600		124	50

DELETE
FROM EMPLOYEES
WHERE EMPLOYEE_ID = 198;
--==>> 1 행 이(가) 삭제되었습니다.

ROLLBACK;
--==>> 롤백 완료.


--○ EMPLOYEES 테이블에서 직원들의 정보를 삭제한다.
--   단, 부서명이 'IT'인 경우로 한정한다.

--※ 실제로는 EMPLOYEES 테이블의 데이터가(삭제하고자 하는 대상)
--   다른 테이블(혹은 자기 자신 테이블)에 의해 참조당하는 경우
--   삭제되지 ㅇ낳을 수 있다는 사실을 염두해야 하며...
--   그에 대한 이유도 알아야 한다.

DELETE
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                         FROM DEPARTMENTS 
                         WHERE DEPARTMENT_NAME = 'IT');
--==>>
/*
오류 보고 -
ORA-02292: integrity constraint (HR.DEPT_MGR_FK) violated - child record found
*/

SELECT *
FROM DEPARTMENTS;

--풀이--------------------------------------------------------------------------
SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID = ('IT'의 부서번호);

--('IT'의 부서번호)
SELECT DEPARTMENT_ID
FROM DEPARTMENTS 
WHERE DEPARTMENT_NAME = 'IT';
--==>> 60

-- 넣어주기
SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS 
                        WHERE DEPARTMENT_NAME = 'IT');
--==>>
/*
103	Alexander	Hunold	AHUNOLD	590.423.4567	06/01/03	IT_PROG	9000		    102	60
104	Bruce	Ernst	BERNST	590.423.4568	07/05/21	IT_PROG	6000		        103	60
105	David	Austin	DAUSTIN	590.423.4569	05/06/25	IT_PROG	4800		        103	60
106	Valli	Pataballa	VPATABAL	590.423.4560	06/02/05	IT_PROG	4800		103	60
107	Diana	Lorentz	DLORENTZ	590.423.5567	07/02/07	IT_PROG	4200		    103	60
*/

--삭제해주기
DELETE
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS 
                        WHERE DEPARTMENT_NAME = 'IT');
--==>> 에러 발생
/*
ORA-02292: integrity constraint (HR.DEPT_MGR_FK) violated - child record found
*/

--■■■ 뷰(VIEW) ■■■--

-- 1. 뷰(VIEW)란 이미 특정한 데이터베이스 내에 존재하는
--    하나 이상의 테이블에서 사용가자 얻기 원하는 데이터들만을
--    정확하고 편하게 가져오기 위하여 사전에 컬럼들만 모아서
--    만들어놓은 가상의 테이블로 편의성 및 보안에 목적이 있다.

--    가상의 테이블이란 뷰가 실제로 존재하는 테이블(객체)이 아니라
--    하나 이상의 테이블에서 파생된 또 다른 정보를 볼수 있는 방법이며
--    그 정보를 추출해내는 SQL 문장이라고 볼 수 있다는 것이다.

-- 2. 형식 및 구조
-- CREATE [OR REPLACE] VIEW 뷰이름
-- [(ALIAS[, ALIAS, ...])]
-- AS
-- 서브쿼리(SUBQUERY)
-- [WITH CHECK OPTION]
-- [WITH READ ONLY];


--○ 뷰(VIEW) 생성
CREATE OR REPLACE VIEW VIEW_EMPLOYEES
AS
SELECT E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY
     , C.COUNTRY_NAME, R.REGION_NAME
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L, COUNTRIES C, REGIONS R
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+)
  AND D.LOCATION_ID = L.LOCATION_ID(+)
  AND L.COUNTRY_ID = C.COUNTRY_ID(+)
  AND C.REGION_ID = R.REGION_ID(+);
--==>> View VIEW_EMPLOYEES이(가) 생성되었습니다.

--○ 뷰(VIEW) 조회
SELECT *
FROM VIEW_EMPLOYEES;

--뷰는 테이블 조회하는 거처럼 구조확인도 된다!
--○ 뷰(VIEW) 구조 확인
DESC VIEW_EMPLOYEES;
--==>>
/*
이름              널?       유형           
--------------- -------- ------------ 
FIRST_NAME               VARCHAR2(20) 
LAST_NAME       NOT NULL VARCHAR2(25) 
DEPARTMENT_NAME          VARCHAR2(30) 
CITY                     VARCHAR2(30) 
COUNTRY_NAME             VARCHAR2(40) 
REGION_NAME              VARCHAR2(25) 
*/

-- 유용한 기능!
--○ 뷰(VIEW) 소스 확인       -- CHECK~!!!
SELECT VIEW_NAME, TEXT                  -- TECXT
FROM USER_VIEWS                         -- USER_VIEWS
WHERE VIEW_NAME = 'VIEW_EMPLOYEES';

-- TEXT내용 복사 붙여넣기
-- 뷰소스 확인할 수 있음!!
/*
"SELECT E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY
     , C.COUNTRY_NAME, R.REGION_NAME
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L, COUNTRIES C, REGIONS R
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+)
  AND D.LOCATION_ID = L.LOCATION_ID(+)
  AND L.COUNTRY_ID = C.COUNTRY_ID(+)
  AND C.REGION_ID = R.REGION_ID(+)"
*/


-- 여기까지 SQL문 종료!
--------------------------------------------------------------------------------



























