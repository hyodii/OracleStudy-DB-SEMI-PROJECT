SELECT USER
FROM DUAL;
--==>> SCOTT

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
( -- 매개변수 선언
  V_NAME        IN TBL_INSA.NAME%TYPE
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
    -- INSERT 쿼리문 수행에 필요한 변수 추가 선언
    V_NUM   TBL_INSA.NUM%TYPE;
BEGIN
    -- 선언한 변수에 값 담아내기(시퀀스 안쓸려고 이거 만든 것!)
    SELECT MAX(NUM)+1 INTO V_NUM
    FROM TBL_INSA;
    
    
    -- INSERT 쿼리문(데이터 입력이니까)
    INSERT INTO TBL_INSA(NUM, NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG)
    VALUES(V_NUM,V_NAME, V_SSN, V_IBSADATE, V_CITY, V_TEL, V_BUSEO, V_JIKWI, V_BASICPAY, V_SUDANG);
    
    -- COMMIT
    COMMIT;
END;
--==>> Procedure PRC_INSA_INSERT이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------

--○ TBL_상품, TBL_입고 테이블을 대상으로...
--   TBL_입고 테이블에 데이터 입력 시(즉, 입고 이벤트 발생 시)
--   TBL_상품 테이블의 재고수량이 함께 변동될 수 있는 기능을 가진
--   프로시저를 작성한다.
--   단, 이 과정에서 입고번호는 자동 증가 처리한다.(시퀀스 사용 안함)
--   TBL_입고 테이블 구성 컬럼
--   → 입고번호, 상품코드, 입고일자, 입고수량, 입고단가
--   프로시저 명 : PRC_입고_INSERT(상품코드, 입고수량, 입고단가)

-- [힌트] 재고수량 파악 SELECT
-- , 재고수량 변경은 UPDATE이고 현재있는 재고와 입력된 입고수량을 더해야함!
-- , 입고테이블 INSERT

--※ TBL_입고 테이블에 입고 이벤트 발생 시...
--   관련 테이블에서 수행되어야 하는 내용
--   0. SELECT → TBL_입고
--      SELECT NVL(MAX(입고번호),0)
--      FROM TBL_입고;
--   1. INSERT → TBL_입고
--      INSERT INTO TBL_입고(입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
--      VALUES(1,'C001', SYSDATE, 30, 1000);
--   2. UPDATE → TBL_상품
--      UPDATE TBL_상품
--      SET 재고수량 = 기본재고수량 + 30(← 입고수량)
--      WHERE 상품코드 = 'C001';
-- 나의 풀이(해결못함 풀이참조)---------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_입고_INSERT
( V_상품코드  IN TBL_입고.상품코드%TYPE               
, V_입고수량  IN TBL_입고.입고수량%TYPE
, V_입고단가  IN TBL_입고.입고단가%TYPE
)
IS 
    -- 시퀀스, 재고수량 변수
    V_NUM       TBL_입고.입고번호%TYPE;
    V_재고수량  TBL_상품.재고수량%TYPE;
BEGIN
    -- 입고번호 증가시키기
    SELECT MAX(입고번호)+1 INTO V_NUM
    FROM TBL_입고;
    
    -- 재고수량 설정
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 =(SELECT 상품코드
                     FROM TBL_입고);
    
    -- 입고에 데이터 입력
    INSERT INTO TBL_입고(입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
    VALUES(V_NUM, V_상품코드,SYSDATE, V_입고수량,V_입고단가);
    
    -- 상품의 재고수량 업데이트
    UPDATE TBL_상품
    SET 재고수량 = V_재고수량 + V_입고수량
    WHERE 상품코드 = V_상품코드;
                     
    -- 커밋
    COMMIT;
END;
--==>> Procedure PRC_입고_INSERT이(가) 컴파일되었습니다.

-- 풀이 ------------------------------------------------------------------------
-- 1 → 2 → 0 순서로 만들어야함(위에 적으 1 2 0 참고)
CREATE OR REPLACE PROCEDURE PRC_입고_INSERT
( V_상품코드  IN TBL_상품.상품코드%TYPE           -- CHECK~!!! 
, V_입고수량  IN TBL_입고.입고수량%TYPE
, V_입고단가  IN TBL_입고.입고단가%TYPE
)
IS
    -- 아래의 쿼리문을 수행하기 위해 필요한 데이터 변수로 선어
    V_입고번호  TBL_입고.입고번호%TYPE;
BEGIN
    -- 0.선언한 변수에 값 담아내기
    SELECT NVL(MAX(입고번호),0) INTO V_입고번호     -- 입고번호가 지금은 NULL이라!! 연산안댐!!!
    FROM TBL_입고;                                  -- INTO CHECK~!!!
    
    -- 수행되어야 하는 쿼리문
    -- 1. INSERT TBL_입고
    -- 입고날짜는 디폴트여서 빼도됨!
    INSERT INTO TBL_입고(입고번호, 상품코드, 입고수량, 입고단가)      
    VALUES((V_입고번호+1), V_상품코드, V_입고수량,V_입고단가);
    
    -- 2. UPDATE → TBL_상품
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 + V_입고수량
    WHERE 상품코드 = V_상품코드;
    
    -- 커밋
    COMMIT;
    
    -- 하나의 프로시저에서 두개의 DML구문이 있음! → 위험한 구문임
    -- 은행 계좌이체 예시처럼 INSERT되고 UPDATE안되거나 반대경우면 문제! 그래서!
    -- 예외처리(다른 어딘가에서 예외가 발생하면 롤백해라 인서트도 안대는것!)
    -- BEGIN 부분 전체가 TRY-CATCH 에 담기는 걸로 생각하면 될까요?? OK

    EXCEPTION
        WHEN OTHERS THEN ROLLBACK;
    
END;
--==>> Procedure PRC_입고_INSERT이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------
--■■■ 프로시저 내에서의 예외 처리 ■■■--

--○ TBL_MEMBER 테이블에서 데이터를 입력하는 프로시저 작성
--   단, 이 프로시저를 통해 데이터를 입력할 경우
--   CITY(지역) 항목에 '서울', '인천', '경기' 만 입력이 가능하도록 구성한다.
--   허용된 지역 외의 지역을 프로시저 호출을 통해 입력하려고 하는 경우
--   예외 처리를 하려고 한다.
--   프로시저 명 : PRC_MEMBER_INSERT(이름, 전화번호, 지역)

-- 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_MEMBER_INSERT
( V_NAME    IN TBL_MEMBER.NAME%TYPE
, V_TEL     IN TBL_MEMBER.TEL%TYPE
, V_CITY    IN TBL_MEMBER.CITY%TYPE
)
IS
    --실행 영역의 쿼리문 수행을 위해 필요한 변수 선언
    V_NUM   TBL_MEMBER.NUM%TYPE;
    
    -- 사용자 정의 예외에 대한 변수 선언  CHECK~!!!
    USER_DEFINE_ERROR EXCEPTION;
    
BEGIN
    -- 프로시저를 통해 입력 처리를 정상적으로 진행해야 할 데이터인지 아닌지 여부를
    -- 가장 먼저 확인할 수 있도록 코드 구성
    IF (V_CITY NOT IN('서울', '인천', '경기'))
        -- 예외 발생
        --THEN USER_DEFINE_ERROR 를 발생시키겠다.
        THEN RAISE USER_DEFINE_ERROR;       -- 자바에서의 THROW
    END IF;
    
    -- 선언한 변수에 값 담아내기
    SELECT NVL(MAX(NUM),0) INTO V_NUM
    FROM TBL_MEMBER;

    -- 쿼리문 구성
    INSERT INTO TBL_MEMBER(NUM, NAME, TEL, CITY)
    VALUES((V_NUM+1),V_NAME,V_TEL,V_CITY);
    
    -- 커밋
    COMMIT;
    
    -- 예외처리 구문 
    -- (사용자정의에러는 일반적으로 20001번부터 쓰면됨 숫자앞에 -는 ORA- 할때 -)
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001,'서울,인천,경기만 입력이 가능합니다.');
                 ROLLBACK;      -- 에러만 띄우는 것이 아니라 ROLLBACK도~!!!
        WHEN OTHERS
            THEN ROLLBACK;
    
END;
--==>> Procedure PRC_MEMBER_INSERT이(가) 컴파일되었습니다.




--------------------------------------------------------------------------------

--○ TBL_출고 테이블에 데이터 입력시(즉, 출고 이벤트 발생 시)
--   TBL_상품 테이블의 재고수량이 변동되는 프로시저를 작성한다.
--   단, 출고번호는 입고번호와 마찬가지로 자동 증가.
--   또한, 출고수량이 재고수량보다 많은 경우...
--   출고 액션을 취소할 수 있도록 처리한다.(출고가 이루어지지 않도록...)
--   프로시저 명 : PRC_출고_INSERT(상품코드, 출고수량, 출고단가)
-- 나의 풀이-----------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_출고_INSERT
( V_상품코드    IN TBL_상품.상품코드%TYPE
, V_출고수량    IN TBL_출고.출고수량%TYPE
, V_출고단가    IN TBL_출고.출고단가%TYPE
)
IS
    -- 출고번호 증가시킬 변수
    V_NUM   TBL_출고.출고번호%TYPE;
    
    --재고수량 변수
    V_재고수량 TBL_상품.재고수량%TYPE;
                  
    -- 사용자정의 예외에 의한 변수 선언
    USER_DEFINE_ERROR EXCEPTION;
    
BEGIN
    -- 출고 번호 변수 지정
    SELECT NVL(MAX(출고번호),0) INTO V_NUM
    FROM TBL_출고;
    
    -- 재고수량
    SELECT NVL(재고수량,0) INTO V_재고수량
    FROM TBL_상품;
    
    --출고수량이 재고수량보다 많은 경우 출고 액션을 취소
    IF (NVL(V_출고수량,0) > V_재고수량)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- 출고 데이터 INSERT
    INSERT  INTO TBL_출고(출고번호,상품코드, 출고수량, 출고단가)
    VALUES ((V_NUM+1),V_상품코드, V_출고수량, V_출고단가);
    
    -- 출고했으니 상품테이블에서 재고수량 빼주자
    UPDATE TBL_상품
    SET 재고수량 = NVL(재고수량,0) - NVL(V_출고수량,0)
    WHERE 상품코드 = V_상품코드;
    
    --커밋
    COMMIT;
    
    -- 예외처리 구문
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'재고수량이 부족합니다.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
    
END;
--==>> Procedure PRC_출고_INSERT이(가) 컴파일되었습니다.

-- 같이 풀이-----------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_출고_INSERT
( V_상품코드    IN TBL_상품.상품코드%TYPE
, V_출고수량    IN TBL_출고.출고수량%TYPE
, V_출고단가    IN TBL_출고.출고단가%TYPE
)
IS
    -- 주요 변수 선언
    V_출고번호 TBL_출고.출고번호%TYPE;
    V_재고수량 TBL_상품.재고수량%TYPE;
    USER_DEFINE_ERROR EXCEPTION;        -- 사용자 정의 예외
    
BEGIN
-- 쿼리문은 지금 적은 순서대로 여야함!!!

    -- 쿼리문 수행 이전에 수행 가능 여부 확인 → 기존 재고 확인 → 출고수량과 비교
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 = V_상품코드;

    -- 출고를 정상적으로 진행해 줄 것인지 아닌지에 대한 여부 확인
    -- (즉, 출고하려는 수량이 파악한 재고수량보다 많으면... 예외 발생)
    IF (V_출고수량 > V_재고수량)
        -- 예외 발생
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- 선언한 변수에 값 담아내기
    SELECT NVL(MAX(출고번호),0) INTO V_출고번호
    FROM TBL_출고;

    -- 쿼리문 구성(INSERT → TBL_출고)
    INSERT INTO TBL_출고(출고번호, 상품코드, 출고수량, 출고단가)
    VALUES((V_출고번호+1), V_상품코드, V_출고수량, V_출고단가);
    
    -- 쿼리문 구석(UPDATE → TBL_상품)
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 - V_출고수량
    WHERE 상품코드 = V_상품코드;
    
    -- 커밋
    COMMIT;
    
    -- 예외 처리
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '재고부족~!!!');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
END;
--==>> Procedure PRC_출고_INSERT이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------

--○ TBL_출고 테이블에서 출고 수량을 수정(변경)하는 프로시저를 작성한다.
--   프로시저 명 : PRC_출고_UPDATE(출고번호, 변경할출고수량);
-- 출고번호를 통해서 2번 출고번호가 홈런볼이구나 라는걸 먼저 알아야함
-- 변경할 출고 수량 : 원래출고하려던 출고량 - 변경할출고량 + 원래재고량 
-- 70   30→40   60
-- 나의 풀이-----------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_출고_UPDATE
( V_출고번호          TBL_출고.출고번호%TYPE
, V_변경할출고수량    TBL_출고.출고수량%TYPE   
)
IS
    --주요 변수 선언
    V_상품코드 TBL_출고.상품코드%TYPE;
    V_출고수량 TBL_출고.출고수량%TYPE;
    V_재고수량 TBL_상품.재고수량%TYPE;
    V_상품코드 TBL_출고.상품코드%TYPE;
    USER_DEFINE_ERROR EXCEPTION;        -- 사용자 정의 예외
    
BEGIN
    SELECT 출고수량 INTO V_출고수량
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    SELECT 재고수량 INTO V_재고수량
    FROM TBL상품
    WHERE 상품코드 = V_상품코드;
    
    IF (V_변경할출고수량 > V_재고수량)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    UPDATE TBL_출고
    SET 출고수량 = 출고수량 - V_변경할출고수량
    WHERE 출고번호 = V_출고번호;
    
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 + (V_출고수량 - V_변경할출고수량)
    WHERE 상품코드 = V_상품코드;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20003,"재고량이 부족합니닷!");
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
        
END;
--==>> Procedure PRC_출고_UPDATE이(가) 컴파일되었습니다.



-- 같이 풀이-----------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_출고_UPDATE
(   -- 1. 매개변수 구성(IN!!!!)
    V_출고번호  IN TBL_출고.출고번호%TYPE
,   V_출고수량  IN TBL_출고.출고수량%TYPE   
)
IS
    -- 3. 주요 변수 선언
    V_상품코드  TBL_상품.상품코드%TYPE;
    
    -- 5. 주요 변수 추가 선언
    V_이전출고수량    TBL_출고.출고수량%TYPE;
    
    -- 7. 주요 변수 추가 선언
    V_재고수량  TBL_상품.재고수량%TYPE;
    
    -- 9. 주요 변수(사용자 정의 예외) 추가 선언
    USER_DEFINE_ERROR EXCEPTION;    
    
BEGIN

    -- 4. 상품 코드와 이전출고수량 파악을 위해 변경 이전의 출고 내역 확인
    /*
    SELECT 상품코드 INTO V_상품코드
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    SELECT 출고수량 INTO V_이전출고수량
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    */
    -- 위에 두개 묶어주자
    SELECT 상품코드, 출고수량 INTO V_상품코드, V_이전출고수량
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    
    -- 6. 출고를 정상적으로 수행할지말지 여부판단 필요
    -- 변경 이전의 출고수량 및 현재 재고 수량 확인해야 수행할수 있어서 위치 여기!!
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 = V_상품코드;
    
    -- 8. 파악한 재고수량에 따라 데이터 변경 실시 여부 판단
    --    (『재고수량 + 이전출고수량 < 현재출고수량』인 상황이라면...사용자 정의 예외 발생)
    IF ((V_재고수량 + V_이전출고수량) < V_출고수량)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- 2. 수행해야 할 쿼리문 구성(UPDATE → TBL_출고 / UPDATE → TBL_상품)
    UPDATE TBL_출고
    SET 출고수량 = V_출고수량       -- CHECK~!!!
    WHERE 출고번호 = V_출고번호;
    
    -- TBL_상품 업데이트 (여기서부터 필요한 값이 생김!)
    UPDATE TBL_상품
    --SET 재고수량 = 재고수량+이전출고수량-변경할출고수량
    --SET 재고수량 = 재고수량 + 기존출고수량 - V_출고수량 (이전출고수량)
    SET 재고수량 = 재고수량 + V_이전출고수량 - V_출고수량
    WHERE 상품코드 = V_상품코드;
    
    -- 10. 커밋
    COMMIT;
    
    -- 11. 예외처리(꼭 가장 마지막에 적어야함!!블레이스가 없기때문에!!)
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002,'재고 부족~!!!');   -- 예외가 같은에러는 번호 같게!! 안에문자는 달라고되지만 내용같게 통일하는것이 좋음!!
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
    
END;
--==>> Procedure PRC_출고_UPDATE이(가) 컴파일되었습니다.


