SELECT USER
FROM DUAL;
--==>> SCOTT

-- ■■■ FUNCTION(함수) ■■■--

-- 1. 함수란 하나 이상의 PL/SQL 문으로 구성된 서브루틴으로
--    코드를 다시 사용할 수 있도록 캡슐화 하는데 사용된다.(얕은 의미의 캡슐화)
--    오라클에서는 오라클에 정의된 기본 제공 함수를 사용하거나
--    직접 스토어드 함수를 만들 수 있다. (→ 사용자 정의 함수)
--    이 사용자 정의 함수는 시스템 함수처럼 쿼리에서 호출하거나
--    저장 프로시저처럼 EXECUTE 문을 통해 실행할 수 있다.

-- 2. 형식 및 구조
/*
CREATE [OR REPLACE] FUNCTION 함수명
[(
    매개변수1 자료형
  , 매개변수2 자료형
)]
RETURN 데이터타입            -- 함수는 반드시 RETURN이 있어야함!
IS
    -- 주요 변수 선언(지역변수)
BEGIN
    -- 실행문
    ...
    RETURN(값);
    
    [EXCEPTION]
        -- 예외 처리 구문;
END;
*/

--※ 사용자 정의 함수(스토어드 함수)는
--   IN 파라미터(입력 매개변수)만 사용할 수 있으며
--   반드시 반환될 값의 데이터타입을 RETURN 문에 선언해야 하고,
--   FUNCTION 은 반드시 단일 값만 반환한다.

--○ TBL_INSA 테이블에서 주민등록번호를 가지고 성별을 조회한다.

SELECT *
FROM TBL_INSA;

SELECT NAME, SSN, DECODE(SUBSTR(SSN,8,1),'1','남자','2','여자','확인불가')"성별"
FROM TBL_INSA;
/*
             ↓ 주민등록번호
            \  /
       -----   ---------
       |               |
       ------------  ---
                  /  \
                   ↓ 성별

*/

--○ FUNCTION 생성
-- 함수명 : FN_GENDER()
--                      SSN(주민등록번호) → 'YYMMDD-NNNNNNN'

CREATE OR REPLACE FUNCTION FN_GENDER
( VSSN  VARCHAR2    -- 매개변수 : 자릿수(길이) 지정 안함
)
RETURN VARCHAR2     -- RETURN 꼭 구성! 반환 자료형 : 자릿수(길이) 지정 안함!
IS
    -- 주요 변수 선언
    VRESULT VARCHAR2(20);
BEGIN
    -- 연산 및 처리
    IF ( SUBSTR(VSSN,8,1) IN ('1','3') )
        THEN VRESULT := '남자';
    ELSIF ( SUBSTR(VSSN,8,1) IN ('2','4') )
        THEN VRESULT := '여자';
    ELSE
        VRESULT := '성별확인불가';
    END IF;
    
    -- 최종 결과값 반환
    RETURN VRESULT;
END;
--==>> Function FN_GENDER이(가) 컴파일되었습니다.



--○ 임의의 정수 두 개를 매개변수(입력 파라미터)로 넘겨받아
--   A 의 B 승의 값을 반환하는 사용자 정의 함수를 작성한다.
--   함수명 : FN_POW()
/*
사용 예)
SELECT FN_POW(10,3)
FROM DUAL;
--==>> 1000
*/
CREATE OR REPLACE FUNCTION FN_POW
( A NUMBER
, B NUMBER
)
RETURN NUMBER
IS
    -- 주요 변수 선언
    VRESULT NUMBER
BEGIN
    IF A>0 AND B>0
        THEN VRESULT := POWER(A,B);
    ELSE
        VRESULT := 0;
    END IF;
    
    -- 최종 결과값 반환
    RETURN VRESULT;
END;
--==>> 에러
-- POWER 함수 사용하는 거 아님!! 반복문 사용!!

-- 나의 풀이-------------------------------------------
CREATE OR REPLACE FUNCTION FN_POW
( A NUMBER
, B NUMBER
)
RETURN NUMBER
IS
    -- 주요 변수 선언
    VRESULT NUMBER :=1;
    VCOUNT  NUMBER :=0;
BEGIN
    -- FOR LOOP 문
    FOR VCOUNT IN 1 .. B LOOP
    VRESULT := VRESULT * A;
    END LOOP;
    
    -- 최종 결과값 반환
    RETURN VRESULT;
END;
--==>> Function FN_POW이(가) 컴파일되었습니다.


-- 같이 풀이-------------------------------------------
CREATE OR REPLACE FUNCTION FN_POW(A NUMBER, B NUMBER)
RETURN NUMBER
IS
    V_RESULT    NUMBER := 1;        -- 누적 곱을 담을 꺼여서 0 말고 1로 초기화
    V_NUM       NUMBER;
BEGIN
    FOR V_NUM IN 1 .. B LOOP
        V_RESULT := V_RESULT * A;
    END LOOP;
    
    -- CHECK~!!!
    RETURN V_RESULT;
    
END;

--연습
CREATE OR REPLACE FUNCTION FN_POW2(A NUMBER, B NUMBER)
RETURN  NUMBER      --CHECK~!! ; 안붙는다!!!!!
IS
    VRESULT NUMBER :=1;
    VNUM    NUMBER;
    
BEGIN
    FOR VNUM IN 1 .. B LOOP
        VRESULT := VRESULT * A;
    END LOOP;
    
    RETURN VRESULT;
    
END;
--==>> Function FN_POW2이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--○ 과제1 (카페에 올리기)
-- TBL_INSA 테이블의 급여 계산 전용 함수를 정의한다.
-- 급여는 『(기본급*12)+수당』을 기반으로 연산을 수행한다.
-- 함수명 : FN_PAY(기본급, 수당)
CREATE OR REPLACE FUNCTION FN_PAY
( BASIC NUMBER
, SU NUMBER)
RETURN  NUMBER
IS 
    V_RESULT    NUMBER :=0;
    
BEGIN
    V_RESULT := (BASIC * 12) + SU;
    
    RETURN V_RESULT;
END;
--==>> Function FN_PAY이(가) 컴파일되었습니다.


--○ 과제2
-- TBL_INSA 테이블의 입사일을 기준으로
-- 현재까지의 근무년수를 반환하는 함수를 정의한다.
-- 단, 근무년수는 소수점 이하 한자리까지 계산한다.
-- 함수명 : FN_WORKYEAR(입사일)
CREATE OR REPLACE FUNCTION FN_WORKYEAR(IBSA DATE)
RETURN NUMBER
IS
    V_RESULT    NUMBER;
BEGIN
    V_RESULT := TRUNC(MONTHS_BETWEEN(SYSDATE,IBSA)/12,1);
    RETURN V_RESULT;
END;
--==>> Function FN_WORKYEAR이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------

--※ 참고(★기억해두기★)

-- 1. INSERT, UPDATE, DELETE, (MERGE)
--==>> DML(Data Manipulation Language)
-- COMMIT / ROLLBACK 이 필요하다.

-- 2. CREATE, DROP, ALTER, (TRUNCATE)
--==>> DDL(Data Definition Language)
-- 실행하면 자동으로 COMMIT 된다.

--3. GRANT, REVOKE
--==>> DCL(Data Control Language)
-- 실행하면 자동으로 COMMIT 된다.

-- 4. COMMIT, ROLLBACK
--==>> TCL(Transaction Control Language)

-- 정적 PL/SQL문 → DML문, TCL문만 사용 가능하다.
-- 동적 PL/SQL문 → DML문, DDL문, DCL문, TCL문 사용 가능하다.

--------------------------------------------------------------------------------
-- PL/SQL 의 꽃! P가 프로시저
-- ■■■ PROCEDURE(프로시저) ■■■--


-- 1. PL/SQL 에서 가장 대표적인 구조인 스토어드 프로시저는
--   개발자가 자주 작성해야 하는 업무의 흐름을
--   미리 작성하여 데이터베이스 내에 저장해 두었다가
--   필요할 때 마다 호출하여 실행할 수 있도록 처리해 주는 구문이다.

-- 2. 형식 및 구조
-- RETURN 문이 없음!!
-- DBA라면 IN OUT 잘알아야함!!
/*
CREATE [OR REPLACE] PROCEDURE 프로시저명
[(
    매개변수 IN 데이터타입       -- 입력 파라미터      -- IN 명시 안하면  INOUT으로 쓰는 것
  , 매개변수 OUT 데이터타입      -- 출력 파라미터
  , 매개변수 INOUT 데이터타입    -- 입출력 파라미터
)]
IS
    -- 주요 변수 선언
BEGIN
    -- 실행구문
    ...
    [EXCEPTION]
        -- 예외 처리 구문
END;
*/

--※ FUNCTION 과 비교했을 때...
--   『RETURN 반환자료형』 부분이 존재하지 않으며,
--   『RETURN』문 자체도 존재하지 않으며,
--   프로시저 실행 시 넘겨주게 되는 매개변수의 종류는
--   IN, OUT, INOUT 으로 구분된다.

-- 3. 실행(호출)
/*
EXEC[UTE] 프로시저명[(인수1, 인수2, ...)];
*/


--○ INSERT 쿼리 실행을 프로시저로 작성( → INSERT 프로시저 )

-- SQL로~


-- 프로시저 생성(작성)
CREATE OR REPLACE PROCEDURE PRC_STUDENTS_INSERT
( V_ID      IN TBL_IDPW.ID%TYPE      -- 두 테이블에 있는 ID데이터타입과 같아야 하니까!
, V_PW      IN TBL_IDPW.PW%TYPE
, V_NAME    IN TBL_STUDENTS.NAME%TYPE
, V_TEL     IN TBL_STUDENTS.TEL%TYPE
, V_ADDR    IN TBL_STUDENTS.ADDR%TYPE
)
IS
    -- 주요 변수 선언 별도로 필요 없음!! 위에꺼 잡아오면 됨!
BEGIN
    -- TBL_IDPW 테이블에 데이터 입력
    INSERT INTO TBL_IDPW(ID, PW)
    VALUES(V_ID, V_PW);
    
    -- TBL_STUDENTS 테이블에 데이터 입력
    INSERT INTO TBL_STUDENTS(ID, NAME, TEL, ADDR)
    VALUES(V_ID, V_NAME, V_TEL, V_ADDR);
    
    -- 커밋
    COMMIT;
    
END;
--==>> Procedure PRC_STUDENTS_INSERT이(가) 컴파일되었습니다.
--------------------------------------------------------------------------------


--○ TBL_SUNGJUK 테이블에 데이터 입력 시
--   특정 항목의 데이터(학번, 이름, 국어점수, 영어점수, 수학점수)만 입력하면
--   내부적으로 총점, 평균, 등급 항목이 함께 입력 처리될 수 있도록 하는
--   프로시저를 생성한다.
--   프로시저 명 : PRC_SUNGJUK_INSERT()
/*
실행 예_
EXEC PRC_SUNGJUK_INSERT(1, '김진희', 90, 80, 70);

프로시저 호출로 처리된 결과)
학번  이름  국어점수  영어점수  수학점수  총점  평균  등급
 1   김진희    90        80        70     240    80     B
*/
-- 나의 풀이---------------------------------------------------------
CREATE OR REPLACE PROCEDURAL PRC_SUNGJUK_INSERT
( V_HAKBUN  IN TBL_SUNGJUK.HAKBUN%TYPE
, V_NAME    IN TBL_SUNGJUK.NAME%TYPE
, V_KOR     IN TBL_SUNGJUK.KOR%TYPE
, V_ENG     IN TBL_SUNGJUK.ENG%TYPE
, V_MAT     IN TBL_SUNGJUK.MAT%TYPE
--, V_TOT     IN TBL_SUNGJUK.TOT%TYPE
--, V_AVG     IN TBL_SUNGJUK.AVG%TYPE
--, V_GRADE   IN TBL_SUNGJUK.GRADE%TYPE
)
IS
    -- 주요 변수 선언
    V_TOT   NUMBER(3);      -- 이부분 틀림!
    V_AVG   NUMBER(4,1);
    V_GRADE CHAR;
     
BEGIN
    V_TOT := V_KOR + V_ENG + V_MAT;
    V_AVG := V_TOT / 3;
    IF V_AVG>=90
        THEN V_GRADE := 'A'; 
    ELSIF V_AVG>=80
        THEN V_GRADE := 'B';
    ELSIF V_AVG>=70
        THEN V_GRADE := 'C';
    ELSIF V_AVG>=60
        THEN V_GRADE := 'D';
    ELSE
        V_GRADE := 'F';
    END IF;
    
    -- 데이터 입력
    INSERT INTO(HAKBUN,NAME, KOR, ENG, MAT, TOT, AVG, GRADE)                -- 이부분 틀림! TBL_SUNGJUK 을 안넣음!!!!
    VALUES(V_HAKBUN,V_NAME, V_KOR, V_ENG, V_MAT, V_TOT, V_AVG, V_GRADE);
    
    -- 커밋
    COMMIT;
END;

-- 같이 풀이--------------------------------------------------------------
--CREATE OR REPLACE PROCEDURAL PRC_SUNGJUK_INSERT
CREATE OR REPLACE PROCEDURE PRC_SUNGJUK_INSERT
( V_HAKBUN  IN TBL_SUNGJUK.HAKBUN%TYPE
, V_NAME    IN TBL_SUNGJUK.NAME%TYPE
, V_KOR     IN TBL_SUNGJUK.KOR%TYPE
, V_ENG     IN TBL_SUNGJUK.ENG%TYPE
, V_MAT     IN TBL_SUNGJUK.MAT%TYPE
)
IS
     -- 아래의 INSERT 쿼리문을 수행하는데 필요한 주요 변수 선언
    V_TOT   TBL_SUNGJUK.TOT%TYPE;   -- 여기서는 내부에서 사용하는 지역변수이기 때문에
    V_AVG   TBL_SUNGJUK.AVG%TYPE;   -- IN 안써도 됨!    위에는 ,로 구분 여기는 ;로 구분!        
    V_GRADE TBL_SUNGJUK.GRADE%TYPE;
BEGIN
    -- 아래의 INSERT 쿼리문을 수행하기 위해서는
    -- 위에서 선언한 변수들에 값을 담아내야 한다.
    V_TOT := V_KOR + V_ENG + V_MAT;
    V_AVG := V_TOT / 3;
    IF (V_AVG>=90)
        THEN V_GRADE := 'A'; 
    ELSIF (V_AVG>=80)
        THEN V_GRADE := 'B';
    ELSIF (V_AVG>=70)
        THEN V_GRADE := 'C';
    ELSIF (V_AVG>=60)
        THEN V_GRADE := 'D';
    ELSE
        V_GRADE := 'F';
    END IF;
    
    -- 위의 일련의 과정(line 336 ~ 348)을 통해 담아낸 값들로
    -- INSERT 쿼리문 실행
    INSERT INTO TBL_SUNGJUK(HAKBUN,NAME, KOR, ENG, MAT, TOT, AVG, GRADE)
    VALUES(V_HAKBUN,V_NAME, V_KOR, V_ENG, V_MAT, V_TOT, V_AVG, V_GRADE);
    
    -- 커밋
    COMMIT;
END;
--==>> Procedure PRC_SUNGJUK_INSERT이(가) 컴파일되었습니다.
--------------------------------------------------------------------------------




--○ TBL_SUNGJUK 테이블에서
--   특정 학생의 점수(학번, 국어, 영어, 수학)
--   데이터 수정 시 총점, 평균, 등급까지 수정하는 프로시저를 작성한다.
--   프로시저 명 : PRC_SUNGJUK_UPDATE()
/*
실행 예)
EXEC PRC_SUNGJUK_UPDATE(2, 100, 100, 100);

프로시저 호출로 처리된 결과)
학번  이름  국어점수  영어점수  수학점수  총점  평균  등급
 2   김소연   100      100        100     300   100     A
*/
-- 나의 풀이---------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_SUNGJUK_UPDATE
( V_HAKBUN  IN TBL_SUNGJUK.HAKBUN%TYPE
, V_KOR     IN TBL_SUNGJUK.KOR%TYPE
, V_ENG     IN TBL_SUNGJUK.ENG%TYPE
, V_MAT     IN TBL_SUNGJUK.MAT%TYPE
)
IS
    V_TOT   TBL_SUNGJUK.TOT%TYPE;
    V_AVG   TBL_SUNGJUK.AVG%TYPE;
    V_GRADE TBL_SUNGJUK.GRADE%TYPE;
BEGIN
    V_TOT := V_KOR + V_ENG + V_MAT;
    V_AVG := V_TOT / 3;
    IF (V_AVG>=90)
        THEN V_GRADE := 'A'; 
    ELSIF (V_AVG>=80)
        THEN V_GRADE := 'B';
    ELSIF (V_AVG>=70)
        THEN V_GRADE := 'C';
    ELSIF (V_AVG>=60)
        THEN V_GRADE := 'D';
    ELSE
        V_GRADE := 'F';
    END IF;
    
    UPDATE TBL_SUNGJUK      
    SET KOR = V_KOR                 -- := 아님!!
       ,ENG = V_ENG
       ,MAT = V_MAT
       ,TOT = V_TOT
       ,AVG = V_AVG
       ,GRADE = V_GRADE
    WHERE HAKBUN = V_HAKBUN;
    
    COMMIT;
END;
--==>> Procedure PRC_SUNGJUK_UPDATE이(가) 컴파일되었습니다.

-- 같이 풀이-----------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_SUNGJUK_UPDATE
( V_HAKBUN  IN TBL_SUNGJUK.HAKBUN%TYPE
, V_KOR     IN TBL_SUNGJUK.KOR%TYPE
, V_ENG     IN TBL_SUNGJUK.ENG%TYPE
, V_MAT     IN TBL_SUNGJUK.MAT%TYPE
)
IS
    -- UPDATE 진행 시 필요한 데이터를 담아낼 주요 변수 선언
    V_TOT   TBL_SUNGJUK.TOT%TYPE;
    V_AVG   TBL_SUNGJUK.AVG%TYPE;
    V_GRADE TBL_SUNGJUK.GRADE%TYPE;
BEGIN
    -- 아래 UPDATE 쿼리문 수행을 위해
    -- 위에서 선언한 변수들에 값을 담아내기
    V_TOT := V_KOR+V_ENG+V_MAT;
    V_AVG := V_TOT / 3;
    IF (V_AVG>=90)
        THEN V_GRADE := 'A'; 
    ELSIF (V_AVG>=80)
        THEN V_GRADE := 'B';
    ELSIF (V_AVG>=70)
        THEN V_GRADE := 'C';
    ELSIF (V_AVG>=60)
        THEN V_GRADE := 'D';
    ELSE
        V_GRADE := 'F';
    END IF;
    
    -- UPDATE 쿼리문 수행
    UPDATE TBL_SUNGJUK
    SET KOR=V_KOR, ENG=V_ENG, MAT=V_MAT, TOT=V_TOT , AVG=V_AVG, GRADE=V_GRADE
    WHERE HAKBUN = V_HAKBUN;
    --커밋
    COMMIT;
END;
--==>> Procedure PRC_SUNGJUK_UPDATE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------

--○ TBL_STUDENTS 테이블에서 
--   전화번호와 주소 데이터를 수정하는(변경하는) 프로시저를 작성한다.
--   단, ID 와 PW가 일치하는 경우에만 수정을 진행할 수 있도록 한다.
-- 프로시저 명 : PRC_STUDENTS_UPDATE()
/*
실행 예)
EXEC PRC_STUDENTS_UPDATE('superman','java006$','010-9999-9999','인천');

프로시저 호출로 처리된 결과
superman	손범석	010-9999-9999	인천

아이디와 패스워드가 일치하지 않으면 프로시저 돌아가지 않도록!
*/
-- 나의 풀이-----------------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_STUDENTS_UPDATE
( V_ID      IN TBL_STUDENTS.ID%TYPE
, V_PW      IN TBL_STUDENTS.PW%TYPE
, V_TEL     IN TBL_STUDENTS.TEL%TYPE
, V_ADDR    IN TBL_STUDENTS.ADDR%TYPE
)
IS 
BEGIN
    WHILE ID = V_ID AND PW = V_PW LOOP
        UPDATE TBL_STUDETNS
           SET ID = V_ID, PW = V_PW, TEL=V_TEL, ADDR = V_ADDR
    END  LOOP;
     
    COMMIT;
END;

-- 같이 풀이-----------------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_STUDENTS_UPDATE
( V_ID      IN TBL_STUDENTS.ID%TYPE             
, V_PW      IN TBL_IDPW.PW%TYPE                 --CHECK~!!! TBL_IDPW
, V_TEL     IN TBL_STUDENTS.TEL%TYPE
, V_ADDR    IN TBL_STUDENTS.ADDR%TYPE
)
IS 
BEGIN
    -- UPDATE 쿼리문 구성
    UPDATE(SELECT I.ID, I.PW, S.TEL, S.ADDR
           FROM TBL_IDPW I JOIN TBL_STUDENTS S
           ON I.ID = S.ID) T
    SET T.TEL=V_TEL, T.ADDR=V_ADDR
    WHERE T.ID = V_ID AND T.PW = V_PW;          --CHECK~!!! AND 와 ;
    
    -- 커밋
    COMMIT;
END;
--==>> Procedure PRC_STUDENTS_UPDATE이(가) 컴파일되었습니다.




--○ TBL_INSA 테이블을 대상으로 신규 데이터 입력 프로시저를 작성한다.
--  NUM, NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG  
--  구조를 갖고 있는 대상 테이블에 데이터 입력 시
--  NUM 컬럼(사원번호)의 값은
--  기존 부여된 사원번호 마지막 번호의 그 다음 번호를 자동으로
--  입력 처리할 수 있는 프로시저를 구성한다.
--  프로시저 명 : PRC_INSA_INSERT(NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG);
--                               ↑NUM 빠져있음!!
/*
EXEC PRC_INSA_INSERT('이다영', '951027-2234567', SYSDATE, '서울', '010-4113-2353', '영업부', '대리', 10000000, 2000000); -- 천만, 이백만

프로시저 호출로 처리된 결과)
1061 이다영 951027-2234567 SYSDATE 서울 010-4113-2353 영업부 대리 10000000 2000000
*/
CREATE OR REPLACE PROCEDURE PRC_INSA_INSERT
( V_NAME        IN TBL_INSA.NAME%TYPE
, V_SSN         IN TBL_INSA.SSN%TYPE
, V_IBSADATE    IN TBL_INSA.IBSADATE%TYPE
, V_CITY        IN TBL_INSA.CITY%TYPE
, V_TEL         IN TBL_INSA.TEL%TYPE
, V_BUSEO       IN TBL_INSA.BUSEO%TYPE
, V_JIKWI       IN TBL_INSA.JIKWI%TYPE
, V_BASICPAY    IN TBL_INSA.BASICPAY%TYPE
, V_SUDANG      IN TBL_INSA.SUDANG%TYPE
)
IS
BEGIN
    UPDATE
    SET
    WHERE
END;






