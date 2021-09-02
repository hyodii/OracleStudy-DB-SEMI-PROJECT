SELECT USER
FROM DUAL;
--==>> SCOTT

SELECT *
FROM TBL_EMP;

--○ TBL_EMP 테이블에서 입사일이 1981년 9월 28일 입사한 직원의
--   사원명, 직종명, 입사일 항목을 조회한다.

SELECT ENAME "사원명", JOB "직종명", HIREDATE "입사일"
FROM TBL_EMP
WHERE HIREDATE = '1981-09-28';
--==>> 조회결과가 나오는데 이건 틀린 구문!
--     이거는 지금 1981-09-28 문자열을 조회한 것! 오라클이 자동형변화해줘서 날짜로 들어간 것!
--     하지만 오라클의 형변환은 믿으면 안됨!

--○ TO_DATE()
SELECT ENAME "사원명", JOB "직종명", HIREDATE "입사일"
FROM TBL_EMP
WHERE HIREDATE = TO_DATE('1981-09-28','YYYY-MM-DD');
--==>> MARTIN	SALESMAN	81/09/28

--○ ※ 날짜 형식에 대한 세션 설정 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>>Session이(가) 변경되었습니다.

SELECT ENAME "사원명", JOB "직종명", HIREDATE "입사일"
FROM TBL_EMP
WHERE HIREDATE = TO_DATE('1981-09-28','YYYY-MM-DD');
--==>> MARTIN	SALESMAN	1981-09-28

--○ TBL_EMP 테이블에서 입사일이 1981년 9월 28일 이후(해당일 포함)로 입사한 직원의
--   사원명, 직종명, 입사일 항목을 조회한다.
SELECT ENAME"사원명", JOB"직종명", HIREDATE"입사일"
FROM TBL_EMP
WHERE HIREDATE >= TO_DATE('1981-09-28','YYYY-MM-DD');
--==>>
/*
MARTIN	SALESMAN	1981-09-28
SCOTT	ANALYST	    1987-07-13
KING	PRESIDENT	1981-11-17
ADAMS	CLERK	    1987-07-13
JAMES	CLERK	    1981-12-03
FORD	ANALYST	    1981-12-03
MILLER	CLERK	    1982-01-23
*/

--※ 오라클에서는 날짜 데이터의 크기 비교가 가능하다.
--   오라클에서 날짜 데이터에 대한 크기 비교 시
--   과거보다 미래를 더 큰 값으로 간주하여 처리하게 된다.


--○ TBL_EMP 테이블에서 입사일이 1981년 4월 2일 부터
--   1981년 9월 28일 사이에 입사한 직원들의
--   사원명, 직종명, 입사일 항목을 조회한다. 해당일 포함)
SELECT ENAME"사원명", JOB"직종명", HIREDATE"입사일"
FROM TBL_EMP
WHERE HIREDATE >= TO_DATE('1981-04-02','YYYY-MM-DD') AND HIREDATE <= TO_DATE('1981-09-28','YYYY-MM-DD');
--==>>
/*
JONES	MANAGER	    1981-04-02
MARTIN	SALESMAN	1981-09-28
BLAKE	MANAGER	    1981-05-01
CLARK	MANAGER	    1981-06-09
TURNER	SALESMAN	1981-09-08
*/

SELECT *
FROM TBL_EMP;









































































































