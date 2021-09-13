SELECT USER
FROM DUAL;
--==>> SCOTT

--■■■ JOIN(조인) ■■■--
-- 개발자의 입장에서 제일 중요한건 조인!

-- 둘다 알아둬야함!!
-- 1. SQL 1992 CODE
SELECT COUNT(*)
FROM EMP,DEPT;
--> 수학에서 말하는 데카르트곱(Catersian Product)
--  두 테이블을 합친(결합한) 모든 경우의 수 
--  EMP에는 14건 DEPT에는 4건 곱셈된 값
--  이런 조인은 잘 안씀!!!(경우의수가 총 몇개인지 COUNT 할때만 씀)

SELECT COUNT(*)
FROM EMP,DEPT;
--==>> 56

-- Equi Join : 서로 정확히 일치하는 데이터들끼리 연결시키는 결합
SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO;
--==>>
/*
7782	CLARK	MANAGER	    7839	81/06/09	2450		    10	10	ACCOUNTING	NEW YORK
7839	KING	PRESIDENT		    81/11/17	5000		    10	10	ACCOUNTING	NEW YORK
7934	MILLER	CLERK	    7782	82/01/23	1300		    10	10	ACCOUNTING	NEW YORK
7566	JONES	MANAGER	    7839	81/04/02	2975		    20	20	RESEARCH	DALLAS
7902	FORD	ANALYST	    7566	81/12/03	3000		    20	20	RESEARCH	DALLAS
7876	ADAMS	CLERK	    7788	87/07/13	1100		    20	20	RESEARCH	DALLAS
7369	SMITH	CLERK	    7902	80/12/17	800		        20	20	RESEARCH	DALLAS
7788	SCOTT	ANALYST	    7566	87/07/13	3000		    20	20	RESEARCH	DALLAS
7521	WARD	SALESMAN	7698	81/02/22	1250	    500	30	30	SALES	CHICAGO
7844	TURNER	SALESMAN	7698	81/09/08	1500	    0	30	30	SALES	CHICAGO
7499	ALLEN	SALESMAN	7698	81/02/20	1600	    300	30	30	SALES	CHICAGO
7900	JAMES	CLERK	    7698	81/12/03	950		        30	30	SALES	CHICAGO
7698	BLAKE	MANAGER	    7839	81/05/01	2850		    30	30	SALES	CHICAGO
7654	MARTIN	SALESMAN	7698	81/09/28	1250	1400	30	30	SALES	CHICAGO
*/

-- 테이블에 별칭을 붙일수도 있음!
SELECT *
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO;
--==>>
/*
7782	CLARK	MANAGER	    7839	81/06/09	2450		    10	10	ACCOUNTING	NEW YORK
7839	KING	PRESIDENT		    81/11/17	5000		    10	10	ACCOUNTING	NEW YORK
7934	MILLER	CLERK	    7782	82/01/23	1300		    10	10	ACCOUNTING	NEW YORK
7566	JONES	MANAGER	    7839	81/04/02	2975		    20	20	RESEARCH	DALLAS
7902	FORD	ANALYST	    7566	81/12/03	3000		    20	20	RESEARCH	DALLAS
7876	ADAMS	CLERK	    7788	87/07/13	1100		    20	20	RESEARCH	DALLAS
7369	SMITH	CLERK	    7902	80/12/17	800		        20	20	RESEARCH	DALLAS
7788	SCOTT	ANALYST	    7566	87/07/13	3000		    20	20	RESEARCH	DALLAS
7521	WARD	SALESMAN	7698	81/02/22	1250	    500	30	30	SALES	CHICAGO
7844	TURNER	SALESMAN	7698	81/09/08	1500	    0	30	30	SALES	CHICAGO
7499	ALLEN	SALESMAN	7698	81/02/20	1600	    300	30	30	SALES	CHICAGO
7900	JAMES	CLERK	    7698	81/12/03	950		        30	30	SALES	CHICAGO
7698	BLAKE	MANAGER	    7839	81/05/01	2850		    30	30	SALES	CHICAGO
7654	MARTIN	SALESMAN	7698	81/09/28	1250	1400	30	30	SALES	CHICAGO
*/

-- Non Equi Join : 범위 안에 적합한 데이터들끼리 연결시키는 결합
-- 두개 다잡아서 실행하면 질의결과2개떠서 비교하면서 볼수있음!
SELECT *
FROM SALGRADE;
SELECT *
FROM EMP;

-- 이게 Non Equi Join!
SELECT *
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;


-- Equi Join 시 『(+)』 를 활용한 결합 방법
SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO = D.DEPTNO;
--> 총 14건의 데이터가 결합되어 조회된 상황
--  즉, 부서번호를 갖지 못한 사원들(5)은 모두 누락~!!!

SELECT *
FROM TBL_EMP;

SELECT *
FROM TBL_DEPT;

-- + 활용!! (+)가 없는쪽이 주인공!!!)
-- +가없는쪽에 테이블을 메모리에 다올려! 그리고 거기에 + 있는 애들을 결합시켜줘! 
SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO = D.DEPTNO(+);
--> 총 19건의 데이터가 결합되어 조회된 상황
--  즉, 부서번호를 갖지 못한 사원들도 모두 조회된 상황

SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO;
--> 총 16건의 데이터가 결합되어 조회된 상황
--  즉, 부서에 소속된 사원이 아무도 없는 부서도 모두 조회된 상황

--※ (+)가 없는 쪽 테이블의 데이터를 모두 메모리에 적재한 후
--   (+)가 있는 쪽 테이블의 데이터를 하나하나 확인하여 결한시키는 형탤
--   JOIN 이 이루어진다.

SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO(+);
--> 위와같은 이유로... 이러한 형식의 JOIN 구문은 존재하지 않는다.
-- 이건 말이안되는 쿼리문! 먼저 적재할 수 있는 데이터가 없음!주인공이없음!

-----------------여기까지가 1992 CODE-------------------------------------------
-- 2. SQL 1999 CODE → 『JOIN』 키워드 등장 → JOIN 유형 명시
--                      결합 조건은  『WHERE』 대신 『ON』 사용
-- 이게 문법적으로 가장 크게 바뀐 것!

-- CROSS JOIN (앞에92에서 데카르트곱(Catersian Product)하던거 이렇게 부르기로했다!)
SELECT *
FROM EMP CROSS JOIN DEPT;

-- INNER JOIN (Equi 조인/NON Equi 조인 이 바뀐형태지만 완전히 이거다 라고 할순없음)
-- FROM 절에 , 대신 INNERJOIN으로 가고 WHERE 대신 ON
SELECT *
FROM TBL_EMP E INNER JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM EMP E INNER JOIN SALGRADE S
ON E.SAL BETWEEN S.LOSAL AND S.HISAL;

--※ INNER JOIN 시 INNER 는 생략 가능!
SELECT *
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM EMP E JOIN SALGRADE S
ON E.SAL BETWEEN S.LOSAL AND S.HISAL;

-- (+) 위에서 (+)때문에 붙어있는애들이 더 주인공같아서 헷갈려!
-- 그래서 주인공을 방향으로 지시하자! 이게 아우터조인

-- OUTER JOIN
SELECT *
FROM TBL_EMP E LEFT OUTER JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM TBL_EMP E RIGHT OUTER JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO;

--※ 방향이 지정된 쪽 테이블(→ LEFT / RIGHT)의 데이터를 모두 메모리에 적재한 후
--   방향이 지정되지 않은 쪽 테이블의 데이터를 각각 확인하여 결합시키는 형태로
--   JOIN 이 이루어 진다.
SELECT *
FROM TBL_EMP E FULL OUTER JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO;

--> SQL 1992 CODE 에서는 둘다 (+) 하는거 안됬는데 OUTER JOIN 에서는 FULL JOIN 으로 가능!
--※ OUTER JOIN 에서 OUTER는 생략 가능!
--   그러면 INNER도 생량가능한데 어케구분해? -> LEFT / RIGHT 있으면 OUTER!
SELECT *
FROM TBL_EMP E LEFT JOIN TBL_DEPT D      -- OUTER JOIN
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM TBL_EMP E RIGHT JOIN TBL_DEPT D     -- OUTER JOIN
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM TBL_EMP E FULL JOIN TBL_DEPT D      -- OUTER JOIN
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM TBL_EMP E JOIN TBL_DEPT D           -- INNER JOIN
ON E.DEPTNO = D.DEPTNO;

------------------------------------------------------------------------
SELECT *
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
-- 이 결과에서... 직종이 CLERK 인 사원들만 조회...

SELECT *
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
AND JOB = 'CLERK';
-- 이렇게 쿼리문을 구성해도 조회하는 데는 문제가 없다.

SELECT *
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE JOB = 'CLERK';
-- 하지만, 이와 같이 구성하여 조회할 수 있도록 권장한다.


--1992 코드에서는 선택의 여지없이 이코드(AND)뿐이다!
SELECT *
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
  AND JOB = 'CLERK';

------------------------------------------------------------------------


--○ EMP 테이블과 DEPT 테이블을 대상으로
--   직종이 MANAGER와 CLERK 인 사원들만
--   부서번호, 부서명, 사원명, 직종명, 급여 항목을 조회한다. (10:32)
--   -------    ----    -----   ----    ---
--    DEPTNO   DNAME    ENAME   JOB     SAL
--     E,D       D        E      E       E
SELECT DEPTNO "부서번호", DNAME "부서명", ENAME "사원명", JOB "직종명",SAL "급여"
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
--==>> 에러 발생
/*
ORA-00918: column ambiguously defined
00918. 00000 -  "column ambiguously defined"
*Cause:    
*Action:
216행, 8열에서 오류 발생
*/
--> 두 테이블 간 중복되는 컬럼에 대한 소속 테이블을
--  정해줘야(명시해 줘야) 한다.

SELECT DNAME "부서명", ENAME "사원명", JOB "직종명",SAL "급여"
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
--> DEPTNO뺌 두 테이블간 중복되는 컬럼이 존재하지 않은 조회 구문은
--   에러 발생하지 않는다.
--==>>
/*
ACCOUNTING	CLARK	MANAGER	    2450
ACCOUNTING	KING	PRESIDENT	5000
ACCOUNTING	MILLER	CLERK	    1300
RESEARCH	JONES	MANAGER	    2975
RESEARCH	FORD	ANALYST 	3000
RESEARCH	ADAMS	CLERK	    1100
RESEARCH	SMITH	CLERK	    800
RESEARCH	SCOTT	ANALYST	    3000
SALES	    WARD	SALESMAN	1250
SALES	    TURNER	SALESMAN	1500
SALES	    ALLEN	SALESMAN	1600
SALES	    JAMES	CLERK	    950
SALES	    BLAKE	MANAGER	    2850
SALES	    MARTIN	SALESMAN	1250
*/

SELECT E.DEPTNO "부서번호", DNAME "부서명", ENAME "사원명", JOB "직종명",SAL "급여"
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT D.DEPTNO "부서번호", DNAME "부서명", ENAME "사원명", JOB "직종명",SAL "급여"
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

--> 두 테이블 간 중복되는 컬럼에 대해 소속 테이블을 명시하는 경우
--  부서(DEPT), 사원(EMP) 중 어떤 테이블을 지정해도
--   쿼리문 수행에 대한 결과 반환에 문제가 없다.

-- ※ 하지만...
--    두 테이블 간 중복되는 컬럼에 대해 소속 테이블을 명시하는 경우
--    부모 테이블의 컬럼을 참조할 수 있도록 해야 한다.

-- 부모를 찾는법
-- 두 테이블에서 공통된 컬럼을 찾는다!
-- 공통된 컬럼(DEPTNO)에서 10번이 1나밖에없고 20번이 1나밖에없는...
-- 데이터가 중복없이 하나만 들어가있는 테이블이 부모!!
SELECT *
FROM DEPT;  -- 부모 테이블
SELECT *
FROM EMP;   -- 자식 테이블

--※ 부모 자식 테이블 관계를 명확히 정리할 수 있도록 한다.
-- 두 테이블 모두 하나씩 존재한다면, 어느걸 선택해도 상관없다!

--지금은 이게 맞음!
SELECT D.DEPTNO "부서번호", DNAME "부서명", ENAME "사원명", JOB "직종명",SAL "급여"
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

--이렇게 해도 문제가 발생하지 않지만 나머지 컬럼도 명시해준다!
-- 그러면 양쪽다 안둘러보고 조회할 수 있음!
SELECT D.DEPTNO "부서번호", D.DNAME "부서명", E.ENAME "사원명", E.JOB "직종명",E.SAL "급여"
FROM EMP E , DEPT D
WHERE E.DEPTNO = D.DEPTNO;
--> 두 테이블 간 중복된 컬럼(공통 컬럼)이 아니더라도...
--  소속 테이블을 명시할 수 있도록 권장한다.


SELECT D.DEPTNO, D.DNAME, E.ENAME, E.JOB, E.SAL
FROM EMP E LEFT JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT E.DEPTNO, D.DNAME, E.ENAME, E.JOB, E.SAL
FROM EMP E LEFT JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
--> 둘다 조회결과가 같음!

SELECT D.DEPTNO, D.DNAME, E.ENAME, E.JOB, E.SAL
FROM EMP E RIGHT JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
--> 부모꺼 참조했을 때 부서번호가 잘나옴
SELECT E.DEPTNO, D.DNAME, E.ENAME, E.JOB, E.SAL
FROM EMP E RIGHT JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
--> 자식꺼 참조했을 때는 부서번호가 안나옴!
-->> 부모꺼를 참조해야하는 이유!


--○ SELF JOIN(자기 조인)

-- EMP 테이블의 정보를 다음과 같이 조회할 수 있도록 한다.
/*
----------------------------------------------------------------
사원번호    사원명 직종명 관리자번호   관리자명    관리자직종명
 7369       SMITH   CLERK   7902        FORD        ANALYST
                             :
 EMP          EMP   EMP     EMP
 -------------------------------①
                            EMP         EMP         EMP
                            -------------------------------------②

*/
 
 EMPNO  ENAME JOB MGR
                  EMPNO ENAME JOB


SELECT E1.EMPNO"사원번호", E1.ENAME"사원명", E1.JOB"직종명", E2.EMPNO "관리자번호"
     , E2.ENAME "관리자명", E2.JOB "관리자직종명"
FROM EMP E1 JOIN EMP E2
ON E1.MGR = E2.EMPNO;
--==>> 13개임(KING 은 관리자번호 관리자명 관지라 직종명이 없으니까!)
SELECT E1.EMPNO"사원번호", E1.ENAME"사원명", E1.JOB"직종명", E2.EMPNO "관리자번호"
     , E2.ENAME "관리자명", E2.JOB "관리자직종명"
FROM EMP E1 LEFT JOIN EMP E2
ON E1.MGR = E2.EMPNO;
--==>>
/*
7902	FORD	ANALYST	    7566	JONES	MANAGER
7788	SCOTT	ANALYST	    7566	JONES	MANAGER
7900	JAMES	CLERK	    7698	BLAKE	MANAGER
7844	TURNER	SALESMAN	7698	BLAKE	MANAGER
7654	MARTIN	SALESMAN	7698	BLAKE	MANAGER
7521	WARD	SALESMAN	7698	BLAKE	MANAGER
7499	ALLEN	SALESMAN	7698	BLAKE	MANAGER
7934	MILLER	CLERK	    7782	CLARK	MANAGER
7876	ADAMS	CLERK	    7788	SCOTT	ANALYST
7782	CLARK	MANAGER	    7839	KING	PRESIDENT
7698	BLAKE	MANAGER	    7839	KING	PRESIDENT
7566	JONES	MANAGER	    7839	KING	PRESIDENT
7369	SMITH	CLERK	    7902	FORD	ANALYST
7839	KING	PRESIDENT			
*/


