SELECT USER
FROM DUAL;
--==>> HR

--○ %TYPE

-- 1. 특정 테이블에 포함되어 있는 컬럼의 자료형을 참조하는 데이터타입
--    필드명과 같은 타입 선언 / 칼럼 단위로 데이터 타입을 참조

-- 2. 형식 및 구조
-- 변수명 테이블명.컬럼명%TYPE [:= 초기값];
SELECT FIRST_NAME
FROM EMPLOYEES;
-- 이름을 어떤 변수에 담으려고 한다! 그럴때 데이터 타입을 지정해주어야 할때 사용!

DESC EMPLOYEES;
-- 이렇게 확인하지 않더라도 %TYPE을 하면 됨!

SET SERVEROUTPUT ON;


--○ HR.EMPLOYEES 테이블의 특정 데이터를 변수에 저장
DECLARE
    --VNAME  VARCHAR2(20)
    VNAME EMPLOYEES.FIRST_NAME%TYPE;        -- VARCHAR(20)
BEGIN
    SELECT FIRST_NAME INTO VNAME
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 103;
    
    DBMS_OUTPUT.PUT_LINE(VNAME);
END;
--==>>
/*
Alexander


PL/SQL 프로시저가 성공적으로 완료되었습니다.
*/

--○ %ROWTYPE

-- 1. 테이블의 레코드와 같은 구조의 구조체 변수를 선언(여러 개의 컬럼)
--    로우(행) 전체에 대한 데이터 타입을 참조

-- 2. 형식 및 구조
-- 변수명 테이블명%ROWTYPE;

DESC EMPLOYEES;

--○ HR.EMPLOYEES 테이블의 값 여러개를 변수에 저장
DECLARE
    -- 원래 같으면 DESC로 보고 적어야 하지만
    --VNAME   VARCHAR2(20);
    --VPHONE  VARCHAR2(20);
    --VEMAIL  VARCHAR2(25);
    
    --VNAME   EMPLOYEES.FIRST_NAME%TYPE;
    --VPHONE  EMPLOYEES.PHONE_NUMBER%TYPE;
    --VEMAIL  EMPLOYEES.EMAIL%TYPE;
    
    -- 행에 있는데이터타입을 모두 담아온다 
    VEMP    EMPLOYEES%ROWTYPE;
BEGIN
    SELECT FIRST_NAME, PHONE_NUMBER, EMAIL
      INTO VEMP.FIRST_NAME, VEMP.PHONE_NUMBER, VEMP.EMAIL
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 103;
    
    DBMS_OUTPUT.PUT_LINE(VEMP.FIRST_NAME || ' - ' || VEMP.PHONE_NUMBER || ' - ' || VEMP.EMAIL);
END;
--==>>
/*
Alexander - 590.423.4567 - AHUNOLD


PL/SQL 프로시저가 성공적으로 완료되었습니다.
*/


--○ HR.EMPLOYEES  테이블의 여러 명 데이터 여러 개를 변수에 저장
--   103번 사원만 골라서 담아내는 것이 아니라
--   전체 사원의 이름, 전화번호, 이메일을 변수에 담아 출력
DECLARE
    -- 행에 있는데이터타입을 모두 담아온다 
    VEMP    EMPLOYEES%ROWTYPE;
BEGIN
    SELECT FIRST_NAME, PHONE_NUMBER, EMAIL
      INTO VEMP.FIRST_NAME, VEMP.PHONE_NUMBER, VEMP.EMAIL
    FROM EMPLOYEES;
    
    DBMS_OUTPUT.PUT_LINE(VEMP.FIRST_NAME || ' - ' || VEMP.PHONE_NUMBER || ' - ' || VEMP.EMAIL);
END;
--==>> 에러 발생
/*
RA-01422: exact fetch returns more than requested number of rows
*/
--> 여러 개의 행(ROWS) 정보를 얻어와 담으려고 하면
-- 변수에 저장하는 것 자체가 불가능한 상황...

-- 불가~!!!
-- EMPLOYEES 에 있는 행이 107개 인데 이걸 한곳에 담을 수 없다!


















