SELECT USER
FROM DUAL;
--==>> SCOTT

-- 다시해보기!!

--○ TBL_입고 테이블에서 입고수량을 수정(변경)하는 프로시저를 작성한다.
--   프로시저 명 : PRC_입고_UPDATE(입고번호, 변경할입고수량);
--   [힌트]입고수량이 변경되면서 재고가 마이너스로 바뀌면 안된다.

--연습
CREATE OR REPLACE PROCEDURE PRC_입고_UDPATE
( V_입고번호    IN TBL_입고.입고번호%TYPE
, V_입고수량    IN TBL_입고.입고수량%TYPE
)
IS
    V_재고수량      TBL_상품.재고수량%TYPE;
    V_이전입고수량  TBL_입고.입고수량%TYPE;
    V_상품코드      TBL_상품.상품코드%TYPE;
    USER_DEFINE_ERROR EXCEPTION;
    
BEGIN
   
    SELECT 입고수량,상품코드 INTO V_이전입고수량, V_상품코드
    FROM TBL_입고
    WHERE 입고번호 = V_입고번호;
    
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 = V_상품코드;
    

    IF ( (V_재고수량 - V_이전입고수량 + V_입고수량) < 0)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
        
    UPDATE TBL_입고
    SET 입고수량 = V_입고수량
    WHERE 입고번호 = V_입고번호;
    
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 - V_이전입고수량 + V_입고수량
    WHERE 상품코드 = V_상품코드;
    
    COMMIT;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '재고부족!');
                    ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_입고_UPDATE
( V_입고번호        IN TBL_입고.입고번호%TYPE
, V_입고수량        IN TBL_입고.입고수량%TYPE
)
IS
    -- V_상품코드 선언
    V_상품코드 TBL_상품.상품코드%TYPE;
    
    -- V_이전입고수량 선언
    V_이전입고수량 TBL_입고.입고수량%TYPE;
    
    --V_재고수량 선언
    V_재고수량  TBL_상품.재고수량%TYPE;
    
    USER_DEFINE_ERROR EXCEPTION;
    
    
BEGIN
    --V_상품코드에 값넣기
    SELECT 상품코드, 입고수량 INTO V_상품코드, V_이전입고수량
    FROM TBL_입고
    WHERE 입고번호 = V_입고번호;
    
    -- V_재고수량 값넣기
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 = V_상품코드;
    
    --조건문
    IF ((V_재고수량 - V_이전입고수량 + V_입고수량) < 0 )
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    --UPDATE 쿼리문 TBL_입고 / TBL_상품
    UPDATE TBL_입고
    SET 입고수량 = V_입고수량       -- CHECK~!!!
    WHERE 입고번호 = V_입고번호;
    
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 - V_이전입고수량 + V_입고수량
    WHERE 상품코드 = V_상품코드;
    
    -- 커밋
    --COMMIT;
    
    -- 예외처리
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20003,'출고번호가 존재하지 않습니다!');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
END;
--==>> Procedure PRC_입고_UPDATE이(가) 컴파일되었습니다.


--○ TBL_출고 테이블에서 출고수량을 삭제하는 프로시저를 작성한다.
--   프로시저 명 : PRC_출고_DELETE(출고번호);
--   [힌트]출고 내역이 없어지고 재고가 늘어가는 것(입고INSERT와 크게 다르지 않음)

--   2번 프로시저 작성할 때, 만약 출고번호 1, 2, 3, 4가 있다면
--   2를 삭제하면 2를 빈 공간으로 둔 채 1, 3, 4로 해야하나요?
--   아니면 1, 2, 3... 으로 하나씩 땡겨와야 하나요?? -> 1, 3, 4 되도록!

--연습
CREATE OR REPLACE PROCEDURE PRC_출고_DELETE
( V_출고번호    IN TBL_출고.출고번호%TYPE
)
IS 
    V_출고수량  TBL_출고.출고수량%TYPE;
    V_상품코드  TBL_상품.상품코드%TYPE;
    
BEGIN
    SELECT 상품코드, 출고수량 INTO V_상품코드, V_출고수량
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    DELETE
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 + V_출고수량
    WHERE 상품코드 = V_상품코드;
    /*
    -- 서브쿼리문 사용도 가능!
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 + V_출고수량;
    WHERE 상품코드 = (SELECT 상품코드
                     FROM TBL_출고
                     WHERE 출고번호 = V_출고번호);
    */
    
    COMMIT;
    
    EXCEPTION WHEN OTHERS THEN ROLLBACK;
END;

--==>> Procedure PRC_출고_DELETE이(가) 컴파일되었습니다.
---------------------------------------------------------------
-- 첫번째 나의 풀이 (땡!)
CREATE OR REPLACE PROCEDURE PRC_출고_DELETE(V_출고번호 IN TBL_출고.출고번호%TYPE)
IS
    -- 주요변수 선언
    V_상품코드      TBL_출고.상품코드%TYPE;
    V_출고수량      TBL_출고.출고수량%TYPE;
    V_이전출고번호  TBL_출고.출고번호%TYPE;
    USER_DEFINE_ERROR EXCEPTION;
    
BEGIN
    -- V_상품코드 값 넣기, V_출고수량 값 넣기
    SELECT 상품코드, 출고수량 INTO V_상품코드,V_출고수량
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    --V_이전출고번호 값 넣기
    SELECT 출고번호 INTO V_이전출고번호
    FROM TBL_출고
    WHERE 상품코드 = V_상품코드;
    
    IF (V_이전출고번호<V_출고번호)        -- 이거는 우리가 넣지않아고 발생하는 에러
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    
    -- 삭제 쿼리문
    DELETE
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    -- 삭제 후 재고량 UPDATE
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 + V_출고수량
    WHERE 상품코드 = V_상품코드;
    
    --커밋
    --COMMIT;
    
    -- 예외처리
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20003,'출고번호가 존재하지 않습니다!');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
END;
--==>> Procedure PRC_출고_DELETE이(가) 컴파일되었습니다.

--같이논의------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_출고_DELETE(V_출고번호 IN TBL_출고.출고번호%TYPE)
IS
    -- 주요변수 선언
    V_상품코드      TBL_출고.상품코드%TYPE;
    V_출고수량      TBL_출고.출고수량%TYPE;
    USER_DEFINE_ERROR EXCEPTION;
    
BEGIN
    -- V_상품코드 값 넣기, V_출고수량 값 넣기
    SELECT 상품코드, 출고수량 INTO V_상품코드,V_출고수량
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    -- 삭제 쿼리문
    DELETE
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    -- 삭제 후 재고량 UPDATE
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 + V_출고수량
    WHERE 상품코드 = V_상품코드;
    
    --커밋
    --COMMIT;
    
    -- 예외처리
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK;
    
END;

--> 굳이 조건 추가 안해도 됨!! SQL내엣 알아서 실행됨!



--○ TBL 입고 테이블에서 입고 수량을 삭제하는 프로시저를 작성한다.
--   프로시저 명 : PRC_입고_DELETE(입고번호);
--   [힌트] 고민 많이해야함
--   입고수량 10개들어오고 현재 재고 20개 이 데이터에 대해 입고삭제 가 20개면 현재 재고량 없음
--   입고번호 확인해서 삭제하면 재고가 마이너스가 될 수 있음 이런것 고려

-- 연습
CREATE OR REPLACE PROCEDURE PRC_입고_DELETE
(V_입고번호 IN TBL_입고.입고번호%TYPE)
IS
    V_상품코드  TBL_상품.상품코드%TYPE;
    V_입고수량 TBL_입고.입고수량%TYPE;
    V_재고수량  TBL_상품.재고수량%TYPE;
    USER_DEFINE_ERROR EXCEPTION;
    
BEGIN
    
    SELECT 상품코드, 입고수량   INTO V_상품코드, V_입고수량
    FROM TBL_입고
    WHERE 입고번호 = V_입고번호;
    
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 = V_상품코드;

    IF ( (V_재고수량 - V_입고수량) <0 )
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    DELETE
    FROM TBL_입고
    WHERE 입고번호 = V_입고번호;
    
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 - V_입고수량
    WHERE 상품코드 = V_상품코드;
    
    COMMIT;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20004,'입고내역삭제불가!');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
END;

--==>> Procedure PRC_입고_DELETE이(가) 컴파일되었습니다.
-------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_입고_DELETE(V_입고번호 TBL_입고.입고번호%TYPE)
IS
    V_상품코드 TBL_상품.상품코드%TYPE;   
    V_입고수량 TBL_입고.입고수량%TYPE;   
    V_재고수량 TBL_상품.재고수량%TYPE;   
    USER_DEFINE_ERROR EXCEPTION;
    
BEGIN
    SELECT 상품코드, 입고수량 INTO V_상품코드,V_입고수량
    FROM TBL_입고
    WHERE 입고번호 = V_입고번호;
    
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 = V_상품코드;
    
    IF (V_재고수량 - V_입고수량 <0)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
        
    DELETE
    FROM TBL_입고
    WHERE 입고번호 = V_입고번호;
    
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 - V_입고수량
    WHERE 상품코드 = V_상품코드;
    
    --COMMIT;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20004,'입고내역 삭제불가!');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
END;
--==>> Procedure PRC_입고_DELETE이(가) 컴파일되었습니다.



--------------------------------------------------------------------------------
--■■■ CURSOR(커서) ■■■--

-- 1. 오라클에서 하나의 레코드가 아닌 여러 레코드로 구성된 작업 영역에서
--   SQL 문을 실행하고 그 과정에서 발생한 정보를 저장하기 위하여
--   커서(CURSOR)를 사용하며, 커서에는 암시적 커서와 명시적 커서가 있다.

--2. 암시적 커서는 모든 SQL 문에 존재하며,
--   SQL 문 실행 후 오직 하나의 행(ROW)만 출력하게 된다.
--   그러나 SQL 문을 실행한 결과물(RESULT SET)이
--   여러 행(ROW)으로 구성된 경우
--   커서(CURSOR) 를 명시적으로 선언해야 여러 행(ROW)을 다룰 수 있다.




--○ 커서 이용 전 상황(단일 행 접근 시)
SET SERVEROUTPUT ON;
--==>> 작업이 완료되었습니다.

DECLARE
    V_NAME  TBL_INSA.NAME%TYPE;
    V_TEL   TBL_INSA.TEL%TYPE;
    
BEGIN
    SELECT NAME, TEL INTO V_NAME, V_TEL
    FROM TBL_INSA
    WHERE NUM=1001;
    
    DBMS_OUTPUT.PUT_LINE(V_NAME|| ' , '||V_TEL);

END;
--==>> 홍길동 , 011-2356-4528


--○ 커서 이용 전 상황(다중 행 접근 시)   -- WHERE 조건절만 없앤 상태
DECLARE
    V_NAME  TBL_INSA.NAME%TYPE;
    V_TEL   TBL_INSA.TEL%TYPE;
    
BEGIN
    SELECT NAME, TEL INTO V_NAME, V_TEL
    FROM TBL_INSA;
    
    DBMS_OUTPUT.PUT_LINE(V_NAME|| ' , '||V_TEL);

END;
--==>> 에러 발생
/*
ORA-01422: exact fetch returns more than requested number of rows
*/

--○ 커서 이용 전 상황(다중 행 접근 시 - 반복문 활용함)
--나의 풀이
DECLARE
    V_NAME TBL_INSA.NAME%TYPE;
    V_TEL   TBL_INSA.TEL%TYPE;
    

    V_NUM   TBL_INSA.NUM%TYPE;

BEGIN
  
       FOR V_NUM IN 1001 .. 1062 LOOP
        SELECT NAME, TEL INTO V_NAME, V_TEL
        FROM TBL_INSA
        WHERE NUM = V_NUM;

        DBMS_OUTPUT.PUT_LINE(V_NAME || ' , ' || V_TEL);
        
    END LOOP;
END;
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.
/*
홍길동 , 011-2356-4528
이순신 , 010-4758-6532
이순애 , 010-4231-1236
김정훈 , 019-5236-4221
한석봉 , 018-5211-3542
이기자 , 010-3214-5357
장인철 , 011-2345-2525
김영년 , 016-2222-4444
나윤균 , 019-1111-2222
김종서 , 011-3214-5555
유관순 , 010-8888-4422
정한국 , 018-2222-4242
조미숙 , 019-6666-4444
황진이 , 010-3214-5467
이현숙 , 016-2548-3365
이상헌 , 010-4526-1234
엄용수 , 010-3254-2542
이성길 , 018-1333-3333
박문수 , 017-4747-4848
유영희 , 011-9595-8585
홍길남 , 011-9999-7575
이영숙 , 017-5214-5282
김인수 , 
김말자 , 011-5248-7789
우재옥 , 010-4563-2587
김숙남 , 010-2112-5225
김영길 , 019-8523-1478
이남신 , 016-1818-4848
김말숙 , 016-3535-3636
정정해 , 019-6564-6752
지재환 , 019-5552-7511
심심해 , 016-8888-7474
김미나 , 011-2444-4444
이정석 , 011-3697-7412
정영희 , 
이재영 , 011-9999-9999
최석규 , 011-7777-7777
손인수 , 010-6542-7412
고순정 , 010-2587-7895
박세열 , 016-4444-7777
문길수 , 016-4444-5555
채정희 , 011-5125-5511
양미옥 , 016-8548-6547
지수환 , 011-5555-7548
홍원신 , 011-7777-7777
허경운 , 017-3333-3333
산마루 , 018-0505-0505
이기상 , 
이미성 , 010-6654-8854
이미인 , 011-8585-5252
권영미 , 011-5555-7548
권옥경 , 010-3644-5577
김싱식 , 011-7585-7474
정상호 , 016-1919-4242
정한나 , 016-2424-4242
전용재 , 010-7549-8654
이미경 , 016-6542-7546
김신제 , 010-2415-5444
임수봉 , 011-4151-4154
김신애 , 011-4151-4444
이다영 , 010-4113-2353
박혜진 , 010-6331-3939
*/

-----------------------------------------------
-- 같이 풀이
DECLARE
    V_NAME TBL_INSA.NAME%TYPE;
    V_TEL   TBL_INSA.TEL%TYPE;
    
    V_NUM   TBL_INSA.NUM%TYPE := 1001;
    
BEGIN
    LOOP
        SELECT NAME, TEL INTO V_NAME, V_TEL
        FROM TBL_INSA
        WHERE NUM = V_NUM;
        
        DBMS_OUTPUT.PUT_LINE(V_NAME || ' , ' || V_TEL);
                
        EXIT WHEN V_NUM >= 1062;
        V_NUM := V_NUM + 1;
        
    END LOOP;
END;
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.
/*
홍길동 , 011-2356-4528
이순신 , 010-4758-6532
이순애 , 010-4231-1236
김정훈 , 019-5236-4221
한석봉 , 018-5211-3542
이기자 , 010-3214-5357
장인철 , 011-2345-2525
김영년 , 016-2222-4444
나윤균 , 019-1111-2222
김종서 , 011-3214-5555
유관순 , 010-8888-4422
정한국 , 018-2222-4242
조미숙 , 019-6666-4444
황진이 , 010-3214-5467
이현숙 , 016-2548-3365
이상헌 , 010-4526-1234
엄용수 , 010-3254-2542
이성길 , 018-1333-3333
박문수 , 017-4747-4848
유영희 , 011-9595-8585
홍길남 , 011-9999-7575
이영숙 , 017-5214-5282
김인수 , 
김말자 , 011-5248-7789
우재옥 , 010-4563-2587
김숙남 , 010-2112-5225
김영길 , 019-8523-1478
이남신 , 016-1818-4848
김말숙 , 016-3535-3636
정정해 , 019-6564-6752
지재환 , 019-5552-7511
심심해 , 016-8888-7474
김미나 , 011-2444-4444
이정석 , 011-3697-7412
정영희 , 
이재영 , 011-9999-9999
최석규 , 011-7777-7777
손인수 , 010-6542-7412
고순정 , 010-2587-7895
박세열 , 016-4444-7777
문길수 , 016-4444-5555
채정희 , 011-5125-5511
양미옥 , 016-8548-6547
지수환 , 011-5555-7548
홍원신 , 011-7777-7777
허경운 , 017-3333-3333
산마루 , 018-0505-0505
이기상 , 
이미성 , 010-6654-8854
이미인 , 011-8585-5252
권영미 , 011-5555-7548
권옥경 , 010-3644-5577
김싱식 , 011-7585-7474
정상호 , 016-1919-4242
정한나 , 016-2424-4242
전용재 , 010-7549-8654
이미경 , 016-6542-7546
김신제 , 010-2415-5444
임수봉 , 011-4151-4154
김신애 , 011-4151-4444
이다영 , 010-4113-2353
박혜진 , 010-6331-3939
*/

-- 이렇게 커서안써도 조회를 할 수 있음!
-- 그런데 문제점이 뭐야?
-- 1. 직접 NUM 시작과 끝을 찾아야 한다.
-- 2. 그리고 1001 1002 1003번 데이터가 순차적으로 들어가 있어야 처리가 가능함!
--  (= 데이터가 시리얼화 되어있어야 한다.)
-- 이문제를 해결할 수 있는 개념이 커서!


CREATE TABLE 테이블명
CREATE USER 유저명
CREATE INDEX 인덱스명
CREATE SEQUENCE 시퀀스명


--○ 커서 이용 후 상황(다중 행 접근 시)
-- 이렇게 하면 데이터가 시리얼화되지 않아도 실행 가능!

-- 주석없앰
DECLARE
    V_NAME  TBL_INSA.NAME%TYPE;
    V_TEL   TBL_INSA.TEL%TYPE;
    
    CURSOR CUR_INSA_SELECT
    IS
    SELECT NAME, TEL
    FROM TBL_INSA;
    
BEGIN
    OPEN CUR_INSA_SELECT;
    
    LOOP      
        FETCH CUR_INSA_SELECT INTO V_NAME, V_TEL;   
        EXIT WHEN CUR_INSA_SELECT%NOTFOUND;       
        DBMS_OUTPUT.PUT_LINE(V_NAME||', '||V_TEL);     
    END LOOP;

    CLOSE CUR_INSA_SELECT;

END;

-----------------------------------------------------------------
--주석
DECLARE
    V_NAME  TBL_INSA.NAME%TYPE;
    V_TEL   TBL_INSA.TEL%TYPE;
    
    -- 커서 이용을 위한 커서 변수 선언(→ 커서 정의) CHECK~!!!
    /*
    변수명 데이터타입;
    NUM     NUMBER;
    NAME    VARCHAR2(20);
    NAL     DATE;
    
    이랬지만 커서는 CREATE예시처럼 커서 커서명
    */
    CURSOR CUR_INSA_SELECT
    IS
    SELECT NAME, TEL
    FROM TBL_INSA;
    
BEGIN
    -- 커서 오픈
    OPEN CUR_INSA_SELECT;
    
    -- 커서 오픈 시 쏟아져나오는 데이터들 처리(잡아내기)
    LOOP
        -- 한 행 한 행 끄집어내어 가져오는 행위 → 『FETCH』
        FETCH CUR_INSA_SELECT INTO V_NAME, V_TEL;
        
        -- 반복문을 빠져나가는 조건은...
        -- 커서로부터 아무것도 찾지 못했을 때...(커서가 비어있을대까지 반복한다)
        EXIT WHEN CUR_INSA_SELECT%NOTFOUND;     -- 위치 기억!!
        
        -- 출력
        DBMS_OUTPUT.PUT_LINE(V_NAME||', '||V_TEL);
        
    END LOOP;
    
    -- 커서 클로즈(다시 커서를 쓸 수 있게 만들어줘야함!!)
    CLOSE CUR_INSA_SELECT;

END;
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.
/*
이다영, 010-4113-2353
박혜진, 010-6331-3939
홍길동, 011-2356-4528
이순신, 010-4758-6532
이순애, 010-4231-1236
김정훈, 019-5236-4221
한석봉, 018-5211-3542
이기자, 010-3214-5357
장인철, 011-2345-2525
김영년, 016-2222-4444
나윤균, 019-1111-2222
김종서, 011-3214-5555
유관순, 010-8888-4422
정한국, 018-2222-4242
조미숙, 019-6666-4444
황진이, 010-3214-5467
이현숙, 016-2548-3365
이상헌, 010-4526-1234
엄용수, 010-3254-2542
이성길, 018-1333-3333
박문수, 017-4747-4848
유영희, 011-9595-8585
홍길남, 011-9999-7575
이영숙, 017-5214-5282
김인수, 
김말자, 011-5248-7789
우재옥, 010-4563-2587
김숙남, 010-2112-5225
김영길, 019-8523-1478
이남신, 016-1818-4848
김말숙, 016-3535-3636
정정해, 019-6564-6752
지재환, 019-5552-7511
심심해, 016-8888-7474
김미나, 011-2444-4444
이정석, 011-3697-7412
정영희, 
이재영, 011-9999-9999
최석규, 011-7777-7777
손인수, 010-6542-7412
고순정, 010-2587-7895
박세열, 016-4444-7777
문길수, 016-4444-5555
채정희, 011-5125-5511
양미옥, 016-8548-6547
지수환, 011-5555-7548
홍원신, 011-7777-7777
허경운, 017-3333-3333
산마루, 018-0505-0505
이기상, 
이미성, 010-6654-8854
이미인, 011-8585-5252
권영미, 011-5555-7548
권옥경, 010-3644-5577
김싱식, 011-7585-7474
정상호, 016-1919-4242
정한나, 016-2424-4242
전용재, 010-7549-8654
이미경, 016-6542-7546
김신제, 010-2415-5444
임수봉, 011-4151-4154
김신애, 011-4151-4444
*/

--------------------------------------------------------------------------------
-- PL/SQL의 마지막

-- ■■■ TRIGGER(트리거) ■■■--

-- 사전적인 의미 : 방아쇠, 촉발시키다. 야기하다. 유발하다.

-- 1. TRIGGER(트리거)란?
--   DML 작업 즉, INSERT, UPDATE, DELETE 작업이 일어날 때
--   자동적으로 실행되는(유발되는, 촉발되는) 객체로
--   이와 같은 특징을 강조하여(부각시켜) DML TRIGGER 라고 부르기도 한다.
--   TRIGGER는 데이터 무결성 뿐 아니라
--   다음과 같은 작업에도 널리 사용된다.

-- 자동으로 파생된 열 값 생성
-- 잘못된 트랜잭션 방지
-- 복잡한 보안 권한 강제 수행
-- 분산 데이터베이스 노드 상에서 참조 무결성 강제 수행
-- 복잡한 업무 규칙 강제 적용 ex) 업무시간과 점심시간이외에 쇼핑몰 방문못한다.
-- 투명한 이벤트 로깅 제공
-- 복잡한 감사 제공
-- 동기 테이블 복제 유지관리   ex)동기화
-- 테이블 액세스 통계 수집    ex)누가 INSERT했는지 누가 UPDATE했는지..

-- 2. TRIGGER 내에서는 COMMIT, ROLLBACK 문을 사용할 수 없다.


-- 3. 특징 및 종류
-- 사전에 움직여야하는 트리거 / 사후에 움직여야하는 트리거
-- BEFORE 에서도 사전(STATEMENT) 사후(ROW)
-- AFTER 에서도 사전(STATEMENT) 사후(ROW)

-- BEFORE STATEMENT TRIGGER
-- SQL 구문이 실행되기 전에 그 문장에 대해 한 번 싱행

-- BEFORE ROW TRIGGER
-- SQL 구문이 실행되기 전에(DML 작업을 수행하기 전에)
-- 각 행(ROW)에 대해 한 번씩 실행

-- AFTER STATEMENT TRIGGER
-- SQL 구문이 실행된 후 그 문장에 대해 한 번 실행

-- AFTER ROW TRIGGER
-- SQL 구문이 실행된 후에(DML 작업을 수행한 후에)
-- 각 행(ROW)에 대해 한 번씩 실행

-- 4. 형식 및 구조
/*
CREATE [OR REPLACE] TRIGGER 트리거명
    [BEFORE] | [AFTER]
    이벤트1 [OR 이벤트2 [OR 이벤트3]] ON 테이블명
    [FOR EACH ROW [WHEN TRIGGER 조건]]
[DECLARE]
    -- 선언 구문;
BEGIN
    -- 실행 구문;
END;
*/



-- ■■■ AFTER STATEMENT TRIGGER 상황 실습 ■■■--
--※ DML 작업에 대한 이벤트 기록에 많이 활용됨!!

-- TBL_TEST1 / TBL_EVENTLOG

--○ TRIGGER(트리거) 생성(TRG_EVENTLOG)
CREATE OR REPLACE TRIGGER TRG_EVENTLOG
            AFTER
            INSERT OR UPDATE OR DELETE ON TBL_TEST1         -- CHECK~!!! 기록은 TBL_EVENTLOG지만 대상테이블은 TBL_TEST1!

DECLARE
BEGIN
    -- 이벤트 종류 구분(조건문을 통한 분기)
    IF (INSERTING)  -- INSERT가 일어났을 때의 조건은! INSERTING!
        THEN INSERT INTO TBL_EVENTLOG(MEMO)
            VALUES('INSERT 쿼리문이 수행되었습니다.');
    ELSIF (UPDATING)
        THEN INSERT INTO TBL_EVENTLOG(MEMO)
            VALUES('UPDATE 쿼리문이 수행되었습니다.');
    ELSIF (DELETING)
        THEN INSERT INTO TBL_EVENTLOG(MEMO)
            VALUES('DELETE 쿼리문이 수행되었습니다.');
    END IF;
    
    --COMMIT    -- ★트리거는 COMMIT 이나 ROLLBACK사용 못함★
    --※ TRIGGER 내에서는 COMMIT구문 사용 불가~!!! CHECK~!!!

END;
--==>> Trigger TRG_EVENTLOG이(가) 컴파일되었습니다.


-- ■■■ BEFORE STATEMENT TRIGGER 에 대한 상황 실습 ■■■--
-- 사전에 액션을 처리하는 것
--※ DML 작업 수행 전에 작업 가능여부 확인
--   (보안 정책 적용 / 복잡한 업무 규칙 적용)
-- 오전 8시 이전이나 오후 6시 이후에는 DML작업을 못하게 막으려 한다.

--○ TRIGGER(트리거) 작성(TRG_TEST1_DML)
CREATE OR REPLACE TRIGGER TRG_TEST1_DML
            BEFORE
            INSERT OR UPDATE OR DELETE ON TBL_TEST1
DECLARE
BEGIN
    -- 조건 확인 후 작업 가능 여부
    IF (시간이 오전 8시 이전이거나... 오후 6시 이후라면)
        THEN 작업을 하지 못하도록 처리하겠다.
    END IF;
END;

--------------------------------------------------------------
CREATE OR REPLACE TRIGGER TRG_TEST1_DML
            BEFORE
            INSERT OR UPDATE OR DELETE ON TBL_TEST1
DECLARE
BEGIN
    -- 조건 확인 후 작업 가능 여부
    IF (시간이 오전 8시 이전이거나... 오후 6시 이후라면)
        THEN 예외를 발생시키도록 하겠다.
    END IF;
END;

--------------------------------------------------------------
CREATE OR REPLACE TRIGGER TRG_TEST1_DML
            BEFORE
            INSERT OR UPDATE OR DELETE ON TBL_TEST1;
--DECLARE 지워도됨!
BEGIN
    -- 조건 확인 후 작업 가능 여부
    IF (  TO_NUMBER(TO_CHAR(SYSDATE,'HH24')) < 8 OR TO_NUMBER(TO_CHAR(SYSDATE,'HH24')) > 17 ) 
          -- 숫자 체크~!!!(18:30분은 HH24로 추출하면 18나와서 안됨)
        THEN RAISE_APPLICATION_ERROR(-20005, '작업은 08:00 ~ 18:00 까지만 가능합니다.');
    END IF;
END;

--------------------------------------------------------------
CREATE OR REPLACE TRIGGER TRG_TEST1_DML
            BEFORE
            INSERT OR UPDATE OR DELETE ON TBL_TEST1
BEGIN
    -- 조건 확인 후 작업 가능 여부
    IF (  TO_NUMBER(TO_CHAR(SYSDATE,'HH24')) < 8 OR TO_NUMBER(TO_CHAR(SYSDATE,'HH24')) > 17 ) 
          -- 숫자 체크~!!!(18:30분은 HH24로 추출하면 18나와서 안됨)
        THEN RAISE_APPLICATION_ERROR(-20005, '작업은 08:00 ~ 18:00 까지만 가능합니다.');
    END IF;
END;
--==>> Trigger TRG_TEST1_DML이(가) 컴파일되었습니다.

-- 노트북 시간 바꾸는 것은 각각의 컴퓨터에 오라클이 깔려있으니까 클라이언트와 서버를 다 같이 바꾸는 것임











