SELECT USER
FROM DUAL;
--==>> SCOTT

-- ■■■ UNION / UNION ALL ■■■--

--○ 실습 테이블 생성(TBL_JUMUN)
CREATE TABLE TBL_JUMUN                   -- 주문 테이블 생성
( JUNO      NUMBER                      -- 주문 번호
, JECODE    VARCHAR2(30)                -- 제품 코드
, JUSU      NUMBER                      -- 수문 수량
, JUDAY     DATE DEFAULT SYSDATE        -- 주문 일자
);
--==>> Table TBL_JUMUN이(가) 생성되었습니다.
--  고객의 주문이 발생했을 경우 주문 내용에 대한 데이터가 입력될 수 있는 테이블

--○ 데이터 입력 → 고객의 주문 발생 / 접수
INSERT INTO TBL_JUMUN VALUES
(1, '홈런볼',20, TO_DATE('2001-11-01 09:00:10', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN VALUES
(2, '구운파',10, TO_DATE('2001-11-01 09:23:15', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN VALUES
(3, '빼빼로',30, TO_DATE('2001-11-02 12:00:11', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN VALUES
(4, '콘칩',10, TO_DATE('2001-11-02 15:16:17', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN VALUES
(5, '다이제',50, TO_DATE('2001-11-03 10:22:33', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN VALUES
(6, '홈런볼',50, TO_DATE('2001-11-04 11:11:11', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN VALUES
(7, '콘칩',20, TO_DATE('2001-11-06 19:10:10', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN VALUES
(8, '포카칩',40, TO_DATE('2001-11-13 09:07:09', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN VALUES
(9, '칙촉',30, TO_DATE('2001-11-15 10:23:24', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN VALUES
(10, '새우깡',20, TO_DATE('2001-11-16 14:20:00', 'YYYY-MM-DD HH24:MI:SS'));
--==>>1 행 이(가) 삽입되었습니다. * 10
SELECT *
FROM TBL_JUMUN;
--==>>
/*
1	홈런볼	20	2001-11-01 09:00:10
2	구운파	10	2001-11-01 09:23:15
3	빼빼로	30	2001-11-02 12:00:11
4	콘칩	10	2001-11-02 15:16:17
5	다이제	50	2001-11-03 10:22:33
6	홈런볼	50	2001-11-04 11:11:11
7	콘칩	20	2001-11-06 19:10:10
8	포카칩	40	2001-11-13 09:07:09
9	칙촉	30	2001-11-15 10:23:24
10	새우깡	20	2001-11-16 14:20:00
*/
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==> Session이(가) 변경되었습니다.

COMMIT;
--==>> 커밋 완료.

ROLLBACK;

--○ 데이터 추가 입력 → 2001년 부터 시작된 주문이... 현재(2021년)까지 계속 발생~!!!
INSERT INTO TBL_JUMUN VALUES(98785,'홈런볼',10,SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98786,'빼빼로',20,SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98787,'홈런볼',20,SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98788,'새우깡',20,SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98789,'콘칩',10,SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98790,'콘칩',20,SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98791,'꼬북칩',20,SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98792,'뽀빠이',10,SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98793,'홈런볼',30,SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98794,'홈런볼',10,SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.

SELECT *
FROM TBL_JUMUN;
--==>>
/*
1	홈런볼	20	2001-11-01 09:00:10
2	구운파	10	2001-11-01 09:23:15
3	빼빼로	30	2001-11-02 12:00:11
4	콘칩	10	2001-11-02 15:16:17
5	다이제	50	2001-11-03 10:22:33
6	홈런볼	50	2001-11-04 11:11:11
7	콘칩	20	2001-11-06 19:10:10
8	포카칩	40	2001-11-13 09:07:09
9	칙촉	30	2001-11-15 10:23:24
10	새우깡	20	2001-11-16 14:20:00

                 :
                 
98785	홈런볼	10	2021-09-07 14:25:57
98786	빼빼로	20	2021-09-07 14:26:00
98787	홈런볼	20	2021-09-07 14:26:03
98788	새우깡	20	2021-09-07 14:26:08
98789	콘칩	10	2021-09-07 14:26:12
98790	콘칩	20	2021-09-07 14:26:20
98791	꼬북칩	20	2021-09-07 14:27:28
98792	뽀빠이	10	2021-09-07 14:27:50
98793	홈런볼	30	2021-09-07 14:29:13
98794	홈런볼	10	2021-09-07 14:29:15
*/
--○ 커밋
COMMIT;
--==>> 커밋 완료.

--※ 진하가 과자 쇼핑몰 운영중...
--   TBL_JUMUN 테이블이 너무 무거워진 상황
--   어플리케이션과의 연동으로 인해 주문내역을 다른 테이블에 저장될 수 있도록
--   다시 구성하는 것은 불가능한 상황
--   기존의 모든 데이터를 덮어놓고 지우는 것도 불가능한 상황
--   → 결과적으로... 현재까지 누적된 주문 데이터들 중
--   금일 발생한 주문 내역을 제외하고 나머지를 다른 테이블(TBL_JUMUNBACKUP)로
--   데이터 이관을 수행할 계획
SELECT *
FROM TBL_JUMUN
WHERE 금일 주문이 아닌 것;

SELECT *
FROM TBL_JUMUN
WHERE TO_CHAR(JUDAY,'YYYY-MM-DD') = '2021-09-07';

SELECT *
FROM TBL_JUMUN
WHERE TO_CHAR(JUDAY,'YYYY-MM-DD') = TO_CHAR(SYSDATE,'YYYY-MM-DD');

SELECT *
FROM TBL_JUMUN
WHERE TO_CHAR(JUDAY,'YYYY-MM-DD') != TO_CHAR(SYSDATE,'YYYY-MM-DD');
--==>>
/*
1	홈런볼	20	01/11/01
2	구운파	10	01/11/01
3	빼빼로	30	01/11/02
4	콘칩	10	01/11/02
5	다이제	50	01/11/03
6	홈런볼	50	01/11/04
7	콘칩	20	01/11/06
8	포카칩	40	01/11/13
9	칙촉	30	01/11/15
10	새우깡	20	01/11/16
*/

--○ 위의 조회 결과로 TBL_JUMUNBACKUP 테이블 생성
CREATE TABLE TBL_JUMUNBACKUP
AS
SELECT *
FROM TBL_JUMUN
WHERE TO_CHAR(JUDAY,'YYYY-MM-DD') != TO_CHAR(SYSDATE,'YYYY-MM-DD');
--==>> Table TBL_JUMUNBACKUP이(가) 생성되었습니다.


--○ 확인
SELECT *
FROM TBL_JUMUNBACKUP;
--==>>
/*
1	홈런볼	20	01/11/01
2	구운파	10	01/11/01
3	빼빼로	30	01/11/02
4	콘칩	10	01/11/02
5	다이제	50	01/11/03
6	홈런볼	50	01/11/04
7	콘칩	20	01/11/06
8	포카칩	40	01/11/13
9	칙촉	30	01/11/15
10	새우깡	20	01/11/16
*/
--> TBL_JUMUN 테이블의 데이터들 중
-- 금일 주문내역 이외의 데이터는 모두 TBL_JUMUNBACKUP 테이블에 백업을 마친 상태.

--○ TBL_JUMUN 테이블의 데이터들 중
--   백업을 마친 데이터들 삭세 → 금일 주문이 아닌 데이터들을 제거
DELETE
FROM TBL_JUMUN
WHERE TO_CHAR(JUDAY,'YYYY-MM-DD') != TO_CHAR(SYSDATE,'YYYY-MM-DD');
--==>> 10개 행 이(가) 삭제되었습니다. → 98784 건의 데이터 삭제되었음을 가정...

-- 아직 제품 발송이 완료되지 않은 금일 주문 데이터를 제외하고
-- 이전의 모든 주문 데이터들이 삭제된 상황이므로
-- 테이블은 행(레코드)의 갯수가 줄어들어 매우 가벼워진 상황.

--○ 확인
SELECT *
FROM TBL_JUMUN;
--==>>
/*
98785	홈런볼	10	21/09/07
98786	빼빼로	20	21/09/07
98787	홈런볼	20	21/09/07
98788	새우깡	20	21/09/07
98789	콘칩	10	21/09/07
98790	콘칩	20	21/09/07
98791	꼬북칩	20	21/09/07
98792	뽀빠이	10	21/09/07
98793	홈런볼	30	21/09/07
98794	홈런볼	10	21/09/07
*/

--○ 커밋
COMMIT;
--==>> 커밋 완료.

-- 그런데, 지금까지 주문받은 내역에 대한 정보를
-- 제품별 총 주문량으로 나타내야 할 상황이 발생하게 되었다.
-- 그렇다면... TBL_JUMUNBACKUP 테이블의 레코드(행)와
-- TBL_JUMUN 테이블의 레코드(행)를 합쳐서 하나의 테이블을
-- 조회하는 것과 같은 결과를 확인할 수 있도록 해야 한다.

-- 컬럼과 컬럼의 관계를 고려하여 테이블을 결합하고자 하는 경우
-- JOIN 을 사횽하지만
-- 레코드(행)와 레코드(행)를 결합하고자 하는 경우
-- UNION / UNION ALL 을 사용할 수 있다.

SELECT *
FROM TBL_JUMUNBACKUP;
SELECT*
FROM TBL_JUMUN;

-- UNION 결합하고싶은 테이블 사이에 UNION을 적기만 하면됨!
SELECT *
FROM TBL_JUMUNBACKUP
UNION
SELECT*
FROM TBL_JUMUN;
-- UNION ALL
SELECT *
FROM TBL_JUMUNBACKUP
UNION ALL
SELECT*
FROM TBL_JUMUN;


-- 다른점 인지
-- UNION 
SELECT *
FROM TBL_JUMUN
UNION
SELECT*
FROM TBL_JUMUNBACKUP;
-- UNION ALL
SELECT *
FROM TBL_JUMUN
UNION ALL
SELECT*
FROM TBL_JUMUNBACKUP;

--※ UNION 은 항상 결과물의 첫 번째 컬럼을 기준으로
--   오름차순 정렬을 수행한다.
--   UNION ALL은 결합된 순서대로 조회한 결과를 반환한다.(정렬 없음)
--   이로 인해 정렬 기능을 포함하고 있는 UNION이 부하가 더 크다.
--   또한, UNION 은 결과물에서 중복된 행이 존재할 경우
--   중복을 제거하고 1개 행만 조회된 결과를 반환한다.
-- UNION이 부하가 더 심하다는 뜻! / UNION ALL 은 성능이 더 좋다!

--○ 지금까지 주문받은 모든 데이터를 통해
--   제품별 총 주문량을 조회하는 쿼리문을 구성한다.
/*
-------------------------------
    제품코드    총 주문량
-------------------------------
      ...           XX
      ...           XX

-------------------------------  
*/
SELECT JECODE "제품코드", SUM(JUSU) "총 주문량"
FROM 
(   SELECT JECODE, JUSU
    FROM TBL_JUMUN
    UNION ALL
    SELECT JECODE, JUSU
    FROM TBL_JUMUNBACKUP
)
GROUP BY JECODE
ORDER BY 2;
--==>>
/*
뽀빠이	10
구운파	10
꼬북칩	20
칙촉	30
새우깡	40
포카칩	40
빼빼로	50
다이제	50
콘칩	60
홈런볼	140
*/
-- 전체까지 조회
SELECT CASE WHEN GROUPING(JECODE) = 0 THEN JECODE 
            ELSE '전체'
        END  "제품코드"
     , SUM(JUSU) "총 주문량"
FROM 
(
    SELECT JECODE, JUSU
    FROM TBL_JUMUN
    UNION ALL
    SELECT JECODE, JUSU
    FROM TBL_JUMUNBACKUP
)
GROUP BY ROLLUP(JECODE);
--==>>
/*
구운파	10
꼬북칩	20
다이제	50
빼빼로	50
뽀빠이	10
새우깡	40
칙촉	30
콘칩	60
포카칩	40
홈런볼	140
전체	450
*/

-- 이 문제를 해결하는 과정에서 UNION 을 사용해서는 안된다. 
-- 주문수량과 제품코드가 같은 중복행을 제거하는 상황이 발생하기 때문~!!!
SELECT JECODE "제품코드", SUM(JUSU) "총 주문량"
FROM 
(   SELECT JECODE, JUSU
    FROM TBL_JUMUN
    UNION
    SELECT JECODE, JUSU
    FROM TBL_JUMUNBACKUP
)
GROUP BY JECODE;
--==>>
/*
콘칩	30
꼬북칩	20
구운파	10
새우깡	20
뽀빠이	10
칙촉	30
포카칩	40
다이제	50
빼빼로	50
홈런볼	110
*/

--> 이문제에서 내가 틀림부분
SELECT *
FROM TBL_JUMUN
UNION ALL
SELECT*
FROM TBL_JUMUNBACKUP;
-- 이게 아니라 이거여야함!!!!!!!!! CHECK~!!!
SELECT JECODE, JUSU
FROM TBL_JUMUN
UNION ALL
SELECT JECODE, JUSU
FROM TBL_JUMUNBACKUP;

--○ INTERSECT / MINUS (→ 교집합 / 차집합)
--  TBL_JUMUNBACKUP 테이블과 TBL_JUMUN 테이블에서
--  제품코드와 주문량의 값이 똑같은 행만 추출하고자 한다.
SELECT JECODE, JUSU
FROM TBL_JUMUNBACKUP;
SELECT JECODE, JUSU
FROM TBL_JUMUN;

SELECT JECODE, JUSU
FROM TBL_JUMUNBACKUP
INTERSECT
SELECT JECODE, JUSU
FROM TBL_JUMUN;
--==>>
/*
새우깡	20
콘칩	10
콘칩	20
홈런볼	20
*/

--○ TBL_JUMUNBACKUP 테이블과 TBL_JUMUN 테이블에서
--   제품코드와 주문량의 값이 똑같은 행의 정보를
--   주문번호, 제품코드, 주문수량, 주문일자 항목을 조회한다.
--  (까다로운 문제) 뷰(?), 인라인뷰, 서브쿼리, 인터섹, 유니온올 다쓰임!
SELECT T1.*
FROM
(
    SELECT *
    FROM TBL_JUMUN
    UNION ALL
    SELECT *
    FROM TBL_JUMUNBACKUP    
)T1
,
(
    SELECT JECODE, JUSU
    FROM TBL_JUMUNBACKUP
    INTERSECT
    SELECT JECODE, JUSU
    FROM TBL_JUMUN
)T2
WHERE T1.JECODE = T2.JECODE
  AND T1.JUSU = T2.JUSU;
--==>>
/*
98787	홈런볼	20	21/09/07
98788	새우깡	20	21/09/07
98789	콘칩	10	21/09/07
98790	콘칩	20	21/09/07
1	    홈런볼	20	01/11/01
4	    콘칩	10	01/11/02
7	    콘칩	20	01/11/06
10	    새우깡	20	01/11/16
*/

-- 방법 1.

SELECT JECODE, JUSU
FROM TBL_JUMUNBACKUP
INTERSECT
SELECT JECODE, JUSU
FROM TBL_JUMUN;
-==>>
/*
새우깡	20
콘칩	10
콘칩	20
홈런볼	20
*/

SELECT JUNO,JECODE, JUSU,JUDAY
FROM TBL_JUMUNBACKUP
INTERSECT
SELECT JUNO,JECODE, JUSU,JUDAY
FROM TBL_JUMUN;
--==>> 조회결과 없음


SELECT T2.JUNO "주문번호",T1.JECODE "제품코드",T1.JUSU "주문수량",T2.JUDAY "주문일자"
FROM
(
    SELECT JECODE, JUSU
    FROM TBL_JUMUNBACKUP
    INTERSECT
    SELECT JECODE, JUSU
    FROM TBL_JUMUN
) T1
JOIN
(
    SELECT JUNO,JECODE, JUSU,JUDAY
    FROM TBL_JUMUNBACKUP
    UNION ALL
    SELECT JUNO,JECODE, JUSU,JUDAY
    FROM TBL_JUMUN
) T2
ON T1.JECODE = T2.JECODE
AND T1.JUSU = T2.JUSU;
--==>>
/*
1	    홈런볼	20	2001-11-01 09:00:10
4	    콘칩	10	2001-11-02 15:16:17
7	    콘칩	20	2001-11-06 19:10:10
10	    새우깡	20	2001-11-16 14:20:00
98787	홈런볼	20	2021-09-07 14:26:03
98788	새우깡	20	2021-09-07 14:26:08
98789	콘칩	10	2021-09-07 14:26:12
98790	콘칩	20	2021-09-07 14:26:20
*/

-- 방법 2.
SELECT T.*
FROM
(
    SELECT JUNO,JECODE, JUSU,JUDAY
    FROM TBL_JUMUNBACKUP
    UNION ALL
    SELECT JUNO,JECODE, JUSU,JUDAY
    FROM TBL_JUMUN
) T
--WHERE JECODE IN('홈런볼','콘칩','새우깡')
--  AND JUSU IN(10,20);
--> 이렇게하면 홈런볼, 콘칩, 새우깡인 10, 20이 다나옴

WHERE JECODE || JUSU IN('홈런볼20','콘칩10','콘칩20','새우깡20');
--WHERE CONCAT(JECODE,JUSU) IN('홈런볼20','콘칩10','콘칩20','새우깡20');
--WHERE CONCAT(JECODE,JUSU) =ANY('홈런볼20','콘칩10','콘칩20','새우깡20');
-- 다가능!
--==>>
/*
1	    홈런볼	20	2001-11-01 09:00:10
4	    콘칩	10	2001-11-02 15:16:17
7	    콘칩	20	2001-11-06 19:10:10
10	    새우깡	20	2001-11-16 14:20:00
98787	홈런볼	20	2021-09-07 14:26:03
98788	새우깡	20	2021-09-07 14:26:08
98789	콘칩	10	2021-09-07 14:26:12
98790	콘칩	20	2021-09-07 14:26:20
*/




SELECT JECODE, JUSU
FROM TBL_JUMUNBACKUP
INTERSECT
SELECT JECODE, JUSU
FROM TBL_JUMUN;
--==>>
/*
새우깡	20
콘칩	10
콘칩	20
홈런볼	20
*/

SELECT CONCAT(JECODE, JUSU)
FROM TBL_JUMUNBACKUP
INTERSECT
SELECT CONCAT(JECODE, JUSU)
FROM TBL_JUMUN;
--==>>
/*
새우깡20
콘칩10
콘칩20
홈런볼20
*/

-- '홈런볼20','콘칩10','콘칩20','새우깡20'이거는 위에 코드로 전환
-- 코드 깔끔히 정리
SELECT T.*
FROM
(
    SELECT JUNO,JECODE, JUSU,JUDAY
    FROM TBL_JUMUNBACKUP
    UNION ALL
    SELECT JUNO,JECODE, JUSU,JUDAY
    FROM TBL_JUMUN
) T
WHERE JECODE || JUSU IN(SELECT CONCAT(JECODE, JUSU)
                        FROM TBL_JUMUNBACKUP
                        INTERSECT
                        SELECT CONCAT(JECODE, JUSU)
                        FROM TBL_JUMUN);
--==>>
/*
1	    홈런볼	20	2001-11-01 09:00:10
4	    콘칩	10	2001-11-02 15:16:17
7	    콘칩	20	2001-11-06 19:10:10
10	    새우깡	20	2001-11-16 14:20:00
98787	홈런볼	20	2021-09-07 14:26:03
98788	새우깡	20	2021-09-07 14:26:08
98789	콘칩	10	2021-09-07 14:26:12
98790	콘칩	20	2021-09-07 14:26:20
*/


-- MINUS : 차집함
SELECT JECODE, JUSU
FROM TBL_JUMUNBACKUP
INTERSECT
SELECT JECODE, JUSU
FROM TBL_JUMUN;

SELECT JECODE, JUSU
FROM TBL_JUMUNBACKUP
MINUS
SELECT JECODE, JUSU
FROM TBL_JUMUN;
--==>> 겹치는 부분이 빠지고 나머지가 조회
/*
구운파	10
다이제	50
빼빼로	30
칙촉	30
포카칩	40
홈런볼	50
*/

/*
    A = {10, 20, 30, 40, 50}
    B = {10, 20, 30}
    
    A - B = {40, 50}
*/

-- 어느테이블에 담겨있는지 명시해준것 → 오라클을 배려해준 구문
SELECT D.DEPTNO, D.DNAME, E.ENAME, E.SAL
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

-- CHECK~!!! 이렇게 써도 조회되는 구문이 있음!!!
-- NATURAL JOIN :  테이블들을 자연스럽게 조인
-- 네츄럴조인에서는 이거 어디에 있는거다 명시해주지 않아도 됨!
-- 대신에 그렇게 바람직한 조인은 아님! 이런게 있구나 정도만 알아두자!
-- 급할때 잠깐쓰는용 → 우리편하자고 오라클이 힘든 구문임!
SELECT DEPTNO, DNAME, ENAME, SAL
FROM EMP NATURAL JOIN DEPT;


-- 원래는 이렇게 다 명시해줘야함!
SELECT DEPT.DEPTNO, DNAME, ENAME, SAL
FROM EMP JOIN DEPT
ON EMP.DEPTNO = DEPT.DEPTNO;

-- 그런데!! USGING 으로 어느 테이블쓰라고 명시하면 명시안해도됨!
SELECT DEPTNO, DNAME, ENAME, SAL
FROM EMP JOIN DEPT
USING(DEPTNO);










