SELECT USER
FROM DUAL;
--==>> SCOTT


-- ■■■ BEFORE ROW TRIGGER 상황 실습 ■■■--
--※ 참조 관계가 설정된 데이터(자식) 삭제를 먼저 수행하는 모델

--○ TRIGGER 작성(TRG_TEST2_DELETE)
CREATE OR REPLACE TRIGGER TRG_TES2_DELETE
        BEFORE
        DELETE ON TBL_TEST2 --여기까지 쓰면 STATEMENT TRIGGER
        FOR EACH ROW
BEGIN
    DELETE
    FROM TBL_TEST3
    WHERE CODE=:OLD.CODE;    -- 시간을 멈춰서 이시간을 기준으로 삭제되기 이전의 코드!
END;
--==>> Trigger TRG_TES2_DELETE이(가) 컴파일되었습니다.


--※ 『:OLD』
-- 참조 전 열의 값
-- (INSERT : 입력하기 이전 자료, DELETE : 삭제하기 이전 자료, 삭제할 자료)

--※ UPDATE → DELETE 그리고 INSERT 가 결합된 형태
--             이 과정에서 UPDATE 하기 이전의 자료는 :OLD
--             이 과정에서 UPDATE 한 후의 자료는 :NEW




-- ■■■ AFTER ROW TRIGGER 상황 실습 ■■■--
--※ 참조 테이블 관련 트랜잭션 처리

-- TBL_상품, TBL_입고, TBL_출고 활용

--○ TBL_입고 테이블의 데이터 입력 시(입고 이벤트 발생 시)
--   TBL_상품 테이블의 재고수량 변동 트리거 작성(TRG_IBGO)
CREATE OR REPLACE TRIGGER TRG_IBGO
        AFTER
        INSERT ON TBL_입고
        FOR EACH ROW
BEGIN
     IF (INSERTING)
        THEN UPDATE TBL_상품
             SET 재고수량 = 재고수량 + 새로입고되는 입고수량
             WHERE 상품코드 = 새로 입고되는 상품코드;
     END IF;    
END;
----------------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_IBGO
        AFTER
        INSERT ON TBL_입고
        FOR EACH ROW
BEGIN
     IF (INSERTING)
        THEN UPDATE TBL_상품
             SET 재고수량 = 재고수량 + :NEW.입고수량
             WHERE 상품코드 = :NEW.상품코드;
     END IF;    
END;
--==>> Trigger TRG_IBGO이(가) 컴파일되었습니다.

-- 트리거 삭제시 : DROP TRIGGER TRG_IBGO;



--○ TBL_상품, TBL_입고, TBL_출고의 관계에서
--   입고수량, 재고수량의 트랜잭션 처리가 이루어질 수 있도록
--   TRG_IBGO 트리거를 재구성한다.

---- 답))예외처리 안해도 됨!!
CREATE OR REPLACE TRIGGER TRG_IBGO
        AFTER
        INSERT OR DELETE OR UPDATE ON TBL_입고
        FOR EACH ROW

BEGIN          
     IF (INSERTING)
        THEN UPDATE TBL_상품
             SET 재고수량 = 재고수량 + :NEW.입고수량
             WHERE 상품코드 = :NEW.상품코드;
     ELSIF (UPDATING)
        THEN UPDATE TBL_상품
             SET 재고수량 = (재고수량 - :OLD.입고수량) + :NEW.입고수량
             WHERE 상품코드 = :NEW.상품코드;
     ELSIF (DELETING)
        THEN UPDATE TBL_상품
             SET 재고수량 = 재고수량 - :OLD.입고수량
             WHERE 상품코드 = :OLD.상품코드;
     END IF;
END;
--==>> Trigger TRG_IBGO이(가) 컴파일되었습니다.

-----------------------------------------------------
-- 예외처리한 것
CREATE OR REPLACE TRIGGER TRG_IBGO
        AFTER
        INSERT OR DELETE OR UPDATE ON TBL_입고
        FOR EACH ROW
DECLARE
    V_재고수량  TBL_상품.재고수량%TYPE;
    
BEGIN
     IF (DELETING OR UPDATING)
        THEN SELECT 재고수량 INTO V_재고수량
             FROM TBL_상품
             WHERE 상품코드 = :OLD.상품코드;
     END IF;
     
     IF( (DELETING AND V_재고수량 - :OLD.입고수량<0) OR (UPDATING AND ((V_재고수량 - :OLD.입고수량) + :NEW.입고수량)<0) )
        THEN RAISE_APPLICATION_ERROR(-20002,'재고가 부족합니다.');
     END IF;
     
          
     IF (INSERTING)
        THEN UPDATE TBL_상품
             SET 재고수량 = 재고수량 + :NEW.입고수량
             WHERE 상품코드 = :NEW.상품코드;
     ELSIF (UPDATING)
        THEN UPDATE TBL_상품
             SET 재고수량 = (재고수량 - :OLD.입고수량) + :NEW.입고수량
             WHERE 상품코드 = :NEW.상품코드;
     ELSIF (DELETING)
        THEN UPDATE TBL_상품
             SET 재고수량 = 재고수량 - :OLD.입고수량
             WHERE 상품코드 = :OLD.상품코드;
     END IF;
END;
--==>> Trigger TRG_IBGO이(가) 컴파일되었습니다.

--------------------------------------------------------------
--○ TBL_상품, TBL_입고, TBL_출고 의 관계에서
--   출고수량, 재고수량의 트랜잭션 처리가 이루어 질 수 있도록
--   TRG_CHULGO 트리거 작성한다.

-- 답))예외처리 안해도 됨!!
CREATE OR REPLACE TRIGGER TRG_CHULGO
        AFTER
        INSERT OR DELETE OR UPDATE ON TBL_출고
        FOR EACH ROW
BEGIN   
    IF (INSERTING)
        THEN UPDATE TBL_상품
             SET 재고수량 = 재고수량 - :NEW.출고수량
             WHERE 상품코드 = :NEW.상품코드;
    ELSIF (UPDATING)
        THEN UPDATE TBL_상품
             SET 재고수량 = (재고수량 + :OLD.출고수량) - :NEW.출고수량
             WHERE 상품코드 = :NEW.상품코드;
    
    ELSIF(DELETING)
        THEN UPDATE TBL_상품
             SET 재고수량 = 재고수량 + :OLD.출고수량
             WHERE 상품코드 = :OLD.상품코드;
    END IF;
END;
--==>> Trigger TRG_CHULGO이(가) 컴파일되었습니다.

--------------------------------------------------------------
CREATE OR REPLACE TRIGGER TRG_CHULGO
        AFTER
        INSERT OR DELETE OR UPDATE ON TBL_출고
        FOR EACH ROW
DECLARE
    V_재고수량  TBL_상품.재고수량%TYPE;
    
BEGIN
    IF (DELETING OR UPDATING)
        THEN SELECT 재고수량 INTO V_재고수량
             FROM TBL_상품
             WHERE 상품코드 = :OLD.상품코드;
    END IF;
    
    IF ( (DELETING AND V_재고수량 + :OLD.출고수량<0) OR (UPDATING AND V_재고수량 + :OLD.출고수량 - :NEW.출고수량<0))
        THEN RAISE_APPLICATION_ERROR(-20002,'재고가 부족합니다.');
    END IF;
    
    IF (INSERTING)
        THEN UPDATE TBL_상품
             SET 재고수량 = 재고수량 - :NEW.출고수량
             WHERE 상품코드 = :NEW.상품코드;
    ELSIF (UPDATING)
        THEN UPDATE TBL_상품
             SET 재고수량 = (재고수량 + :OLD.출고수량) - :NEW.출고수량
             WHERE 상품코드 = :NEW.상품코드;
    
    ELSIF(DELETING)
        THEN UPDATE TBL_상품
             SET 재고수량 = 재고수량 + :OLD.출고수량
             WHERE 상품코드 = :OLD.상품코드;
    END IF;
END;
--==>> Trigger TRG_CHULGO이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------


-- ■■■ PACKAGE(패키지) ■■■--

-- 1. PL/SQL 의 패키지는 관계되는 타입, 프로그램 객체,
--    서브 프로그램(PROCEDURE, FUNCTION 등)을 ★논리적으로 묶어놓은 것★으로
--    오라클에서 제공하는 패키지 중 하나가 바로 『DBMS_OUTPUT』이다.

-- ex) DBMS_OUTPUT.PUT_LINE()에서 
--     ----------- 이만큼이 패키지다!

-- 2. 패키지는 서로 유사한 업무에 사용되는 여러 개의 프로시저와 함수를
--    하나의 패키지로 만들어 관리함으로써 향후 유지보수가 편리하고
--    전체 프로그램을 모듈화 할 수 있는 장점이 있다.

-- 3. 패키지는 명세부(PACKAGE SPECIFICATION)와
--    몸체부(PACKAGE BODY)로 구성되어 있으며,
--    명세 부분에는 TYPE, CONSTRAINT, VARIABLE, EXCEPTION, CURSOR,
--    SUBPROGRAM 이 선언되고
--    몸체 부분에는 이들의 실제 내용이 존재하게 된다.
--    그리고 호출할 때에는 『패키지명.프로시저명』 형식의 참조를 이용해야 한다.

-- 4. 형식 및 구조(명세부)
-- 패키지안에 이런 것이 있구나 알게 해주려는 것!
/*
CREATE [OR REPLACE] PACKAGE 패키지명
IS
    전역변수 선언;
    커서 선언;
    예외 선언;
    함수 선언;
    프로시저 선언;
        :
END 패키지명;
*/

-- 5. 형식 및 구조(몸체부)
/*
CREATE [OR RELACE] PACKAGE BODY 패키지명
IS
    FUNCTION 함수명[(인수, ...)]
    RETURN 자료형
    IS
        변수선언;
    BEGIN
        함수 몸체 구성 코드;
        RETURN 값;
    END;
    
    PROCEDURE 프로시저명[(인수, ...)]
    IS
        변수 선언;
    BEGIN
        프로시저 몸체 구성 코드;
    END;
END 패키지명;
*/


--○ 주민번호 입력 시 성별을 반환하는 함수
--   이 함수를 구성요소로 하는 패키지 작성

-- 함수 준비
CREATE OR REPLACE FUNCTION FN_GENDER(V_SSN VARCHAR2)
RETURN VARCHAR2
IS
    V_RESULT VARCHAR2(20);
BEGIN
    IF (SUBSTR(V_SSN,8,1) IN ('1','3'))
        THEN V_RESULT := '남자';
    ELSIF (SUBSTR(V_SSN,8,1) IN ('2','4'))
        THEN V_RESULT := '여자';
    ELSE 
        V_RESULT := '확인불가';
    END IF;
    
    RETURN V_RESULT;
END;
--==>> Function FN_GENDER이(가) 컴파일되었습니다.

-- 패키지 등록
-- 1. 명세부 작성
CREATE OR REPLACE PACKAGE INSA_PACK
IS
    FUNCTION FN_GENDER(V_SSN VARCHAR2)
    RETURN VARCHAR2;
    
END INSA_PACK;  -- 패키지의 이름과 END 패키지명은 정확히 같아야함!!
--==>> Package INSA_PACK이(가) 컴파일되었습니다.


-- 2. 몸체부 작성
CREATE OR REPLACE PACKAGE BODY INSA_PACK
IS
    -- 위에 선언한 함수 복붙에서 CREATE OR REPLACE 빼면 됨!
    FUNCTION FN_GENDER(V_SSN VARCHAR2)
    RETURN VARCHAR2
    IS
        V_RESULT VARCHAR2(20);
    BEGIN
        IF (SUBSTR(V_SSN,8,1) IN ('1','3'))
            THEN V_RESULT := '남자';
        ELSIF (SUBSTR(V_SSN,8,1) IN ('2','4'))
            THEN V_RESULT := '여자';
        ELSE 
            V_RESULT := '확인불가';
        END IF;
        
        RETURN V_RESULT;
    END;
    
END INSA_PACK;
--==>> Package Body INSA_PACK이(가) 컴파일되었습니다.





