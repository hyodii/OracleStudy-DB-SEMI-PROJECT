SELECT USER
FROM DUAL;
--==>> SCOTT

SELECT DEPTNO "부서번호", SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
10	     8750       -- 부서번호가 10번인 사원들의 급여합
20	    10875       -- 부서번호가 20번인 사원들의 급여합
30	     9400       -- 부서번호가 30번인 사원들의 급여합
(NULL)	 8000       -- 부서번호가 존재하지 않는 사원들(NULL)의 급여합
(NULL)  37025       -- 모든 부서의 사원들의 급여합
*/


--○ 위에서 조회한 내용을
/*
10	       8750       -- 부서번호가 10번인 사원들의 급여합
20	      10875       -- 부서번호가 20번인 사원들의 급여합
30	       9400       -- 부서번호가 30번인 사원들의 급여합
인턴	   8000       -- 부서번호가 존재하지 않는 사원들(NULL)의 급여합
모든부서  37025       -- 모든 부서의 사원들의 급여합
*/
-- 이와같이 조회하고자 한다.

SELECT CASE DEPTNO WHEN NULL 
                    THEN '인턴' 
                    ELSE  DEPTNO
        END "부서번호"
FROM TBL_EMP;
--==>> 에러 발생(자료형이 안맞아서)
/*
ORA-00932: inconsistent datatypes: expected CHAR got NUMBER
00932. 00000 -  "inconsistent datatypes: expected %s got %s"
*Cause:    
*Action:
30행, 31열에서 오류 발생
*/

SELECT CASE DEPTNO WHEN NULL 
                   THEN '인턴' 
                   ELSE TO_CHAR(DEPTNO)
        END "부서번호"
FROM TBL_EMP;
--==>> 아직 인턴이라고 바뀌지않음 산술적인 처리만 들어가서!
/*
20
30
30
20
30
30
10
20
10
30
20
30
20
10
(NULL)
(NULL)
(NULL)
(NULL)
(NULL)
*/

SELECT CASE WHEN DEPTNO IS NULL 
            THEN '인턴' 
            ELSE TO_CHAR(DEPTNO)
        END "부서번호"
FROM TBL_EMP;
--==>> IS NULL 사용으로 논리적연산 수행!
/*
20
30
30
20
30
30
10
20
10
30
20
30
20
10
인턴
인턴
인턴
인턴
인턴
*/

SELECT CASE WHEN DEPTNO IS NULL 
            THEN '인턴' 
            ELSE TO_CHAR(DEPTNO)
        END "부서번호"
      , SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>> 둘다 인턴이 되버림
/*
10	     8750
20	    10875
30	     9400
인턴	 8000
인턴	37025
*/

--※ GROUPING()
SELECT DEPTNO "부서번호", SUM(SAL)"급여합", GROUPING(DEPTNO)
FROM TBL_EMP
GROUP BY DEPTNO;
--==>>
/*
30	     9400	0
(NULL)	 8000	0
20	    10875	0
10	     8750	0
*/

SELECT DEPTNO "부서번호", SUM(SAL)"급여합", GROUPING(DEPTNO)
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
10	     8750	0
20	    10875	0
30	     9400	0
(NULL)	 8000	0
(NULL)	37025	1
*/
-- GROUPING 수행한 함수는 1나옴!!(그림참고)


/*
10	       8750       -- 부서번호가 10번인 사원들의 급여합
20	      10875       -- 부서번호가 20번인 사원들의 급여합
30	       9400       -- 부서번호가 30번인 사원들의 급여합
인턴	   8000       -- 부서번호가 존재하지 않는 사원들(NULL)의 급여합
모든부서  37025       -- 모든 부서의 사원들의 급여합
*/
-- 이게 나오게 하려면!
-- 내가 푼 풀이--------------------------------------------------------
SELECT CASE WHEN (DEPTNO IS NULL) AND (GROUPING(DEPTNO) = 0)
            THEN '인턴' 
            WHEN GROUPING(DEPTNO) = 1
            THEN '모든부서'
            ELSE TO_CHAR(DEPTNO)
        END "부서번호"
      , SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
10	         8750
20	        10875
30	         9400
인턴	     8000
모든부서	37025
*/

--함께 푼 풀이----------------------------------------------------------
SELECT CASE GROUPING(DEPTNO) WHEN 0 THEN TO_CHAR(DEPTNO)
            ELSE '모든부서'
        END "부서번호"
      , SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
/*
10	        8750
20	        10875
30	        9400
(NULL)	    8000
모든부서	37025
*/
SELECT CASE GROUPING(DEPTNO) WHEN 0 THEN NVL(TO_CHAR(DEPTNO),'인턴')
            ELSE '모든부서'
        END "부서번호"
      , SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
10	        8750
20	        10875
30	        9400
인턴	    8000
모든
부서	37025
*/

--○ TBL_SAWON 테이블을 다음과 같이 조회할 수 있도록
--   쿼리문을 구성한다.
/*
-----------------------------------
    성별      급여합
-----------------------------------
    남         XXXX
    여         XXXX
    모든사원  XXXXX
-----------------------------------
*/
--내가 푼 풀이-------------------------------------------------
SELECT CASE GROUPING(T.성별) WHEN 0 THEN T.성별
            ELSE '모든사원'
        END "성별"
        , SUM(T.급여)
FROM
(
SELECT CASE SUBSTR(JUBUN,7,1) WHEN '1'THEN '남' 
                              WHEN '3'THEN '남'
                              WHEN '2'THEN '여'
                              WHEN '4'THEN '여'
                              ELSE '성별 확인 불가'
        END "성별"
     ,  SAL "급여"
FROM TBL_SAWON
) T
GROUP BY ROLLUP(T.성별);
--==>>
/*
남	        17000
여	        24000
모든사원	41000
*/

---풀이---------------------------------------------------------------
SELECT CASE GROUPING(T.성별) WHEN 0 THEN T.성별
            ELSE '모든사원'
        END "성별"
     , SUM(T.급여) "급여합"
FROM
(
    SELECT CASE WHEN SUBSTR(JUBUN,7,1) IN('1','3') THEN '남'
                WHEN SUBSTR(JUBUN,7,1) IN('2','4') THEN '여'
                ELSE '성별 확인 불가'
            END "성별"
         , SAL "급여"
    FROM TBL_SAWON
) T
GROUP BY ROLLUP(T.성별);
--==>>
/*
남	        17000
여	        24000
모든사원	41000
*/

--○ TBL_SAWON 테이블을 다음과 같이 연령대별 인원수 형태로
--   조회할 수 있도록 쿼리문을 구성한다.
/*
--------------------------------------------
    연령대         인원수
--------------------------------------------
      10               X
      20               X            
      30               X
      40               X
      50               X
     전체             XX
--------------------------------------------
*/

--나의 풀이------------------------------------------------
SELECT CASE GROUPING(T1.연령대) WHEN 0 THEN T1.연령대
            ELSE '전체'
        END "연령대"
     , COUNT(T1.연령대) "인원수"
FROM
(
    SELECT CASE SUBSTR(T.현재나이,1,1) WHEN '1'  THEN '10'
                                        WHEN '2' THEN '20'
                                        WHEN '3' THEN '30'
                                        WHEN '4' THEN '40'
                                        WHEN '5' THEN '50'
                                        ELSE '0'
            END "연령대"
            --, COUNT();
    FROM
    (
        SELECT CASE WHEN SUBSTR(JUBUN,7,1) IN('1','2') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899)
                    WHEN SUBSTR(JUBUN,7,1) IN('3','4') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999) 
                    ELSE -1 
                END "현재나이"
        FROM TBL_SAWON
    )T
)T1
GROUP BY ROLLUP(T1.연령대);
--==>>
/*
연령        인원수
------  ----------
10              2
20              5
30              2
40              4
50              2
전체           15
*/

-- DECODE 사용
SELECT CASE GROUPING(T1.연령대) WHEN 0 THEN T1.연령대
            ELSE '전체'
        END "연령대"
     , COUNT(T1.연령대) "인원수"
FROM
(
    SELECT DECODE(SUBSTR(T.현재나이,1,1),'1','10','2','20','3','30','4','40','5','50','0') "연령대"
            --, COUNT();
    FROM
    (
        SELECT CASE WHEN SUBSTR(JUBUN,7,1) IN('1','2') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899)
                    WHEN SUBSTR(JUBUN,7,1) IN('3','4') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999) 
                    ELSE -1 
                END "현재나이"
        FROM TBL_SAWON
    )T
)T1
GROUP BY ROLLUP(T1.연령대);

--한번만 쓰는 법 궁금
--함께 푼 풀이--------------------------------------------------------------

--방법 1.(INLINE VIEW 를 두 번 중첩~!!!)
--"연령 대" 조회하는거 궁금해서 해줌 원래는 연령대
SELECT CASE GROUPING(Q."연령 대") WHEN 0 THEN TO_CHAR(Q."연령 대")
            ELSE '전체'
        END "연령 대"
     , COUNT(Q."연령 대") "인원수"
FROM
(
    SELECT CASE WHEN T.나이 >= 50 THEN 50
                WHEN T.나이 >= 40 THEN 40
                WHEN T.나이 >= 30 THEN 30
                WHEN T.나이 >= 20 THEN 20
                WHEN T.나이 >= 10 THEN 10
                ELSE 0
            END "연령 대"
            --, COUNT();
    FROM
    (
        -- 나이
        SELECT CASE WHEN SUBSTR(JUBUN,7,1) IN('1','2') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899) --(1900 - 1)
                    WHEN SUBSTR(JUBUN,7,1) IN('3','4') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999) --(2000 - 1) 
                    ELSE 0 
                END "나이"
        FROM TBL_SAWON
    )T
)Q
GROUP BY ROLLUP(Q."연령 대");
--==>>
/*
10	     2
20	     5
30	     2
40	     4
50	     2
전체	15
*/


--방법 2.(INLINE VIEW 를 한 번만 중첩~!!!)

SELECT CASE GROUPING(TRUNC(나이,-1)) WHEN 0 THEN TO_CHAR(TRUNC(나이,-1))
            ELSE '전체' 
        END  "연령대"

CASE WHEN SUBSTR(JUBUN,7,1) IN('1','2') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899) --(1900 - 1)
                    WHEN SUBSTR(JUBUN,7,1) IN('3','4') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999) --(2000 - 1) 
                    ELSE 0 END 
FROM TBL_SAWON;



-------->나이에 케이스문 넣기!

-- 이거 이용해서 COUNT해서 구해보기!!...ING
SELECT CASE GROUPING(TRUNC(CASE WHEN SUBSTR(JUBUN,7,1) IN('1','2') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899) --(1900 - 1)
                    WHEN SUBSTR(JUBUN,7,1) IN('3','4') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999) --(2000 - 1) 
                    ELSE 0 END ,-1)) WHEN 0 THEN TO_CHAR(TRUNC(CASE WHEN SUBSTR(JUBUN,7,1) IN('1','2') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899) --(1900 - 1)
                    WHEN SUBSTR(JUBUN,7,1) IN('3','4') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999) --(2000 - 1) 
                    ELSE 0 END ,-1))
            ELSE '전체' 
        END  "연령대"
    , COUNT(TRUNC(CASE WHEN SUBSTR(JUBUN,7,1) IN('1','2') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899) --(1900 - 1)
                    WHEN SUBSTR(JUBUN,7,1) IN('3','4') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999) --(2000 - 1) 
                    ELSE 0 END,-1)) "인원수"
FROM TBL_SAWON
GROUP BY ROLLUP(TRUNC(CASE WHEN SUBSTR(JUBUN,7,1) IN('1','2') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1899) --(1900 - 1)
                    WHEN SUBSTR(JUBUN,7,1) IN('3','4') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2)) + 1999) --(2000 - 1) 
                    ELSE 0 END,-1));

--==>>
/*
10	     2
20	     5
30	     2
40	     4
50	     2
전체	15
*/


--○ ROLLUP 활용 및 CUBE
SELECT DEPTNO, JOB, SUM(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB)
ORDER BY 1,2;
--==>>
/*
10	    CLERK	     1300   -- 10번 부서안에서 CLERK끼리 묶은것
10	    MANAGER	     2450
10	    PRESIDENT	 5000
10	    (NULL)	     8750   -- 10번 부서 모든 직종의 급여합
20	    ANALYST	     6000
20	    CLERK	     1900
20	    MANAGER	     2975
20	    (NULL)	    10875   -- 20번 부서 모든 직종의 급여합
30	    CLERK	      950
30	    MANAGER	     2850
30	    SALESMAN	 5600
30	    (NULL)	     9400   -- 30번 부서 모든 직종의 급여합
(NULL)	(NULL)	    29025   -- 모든 부서 모든 직종의 급여합
*/


--○ CUBE() → ROLLUP() 보다 자세한 결과를  반환받을 수 있다.   
SELECT DEPTNO, JOB, SUM(SAL)
FROM EMP
GROUP BY CUBE(DEPTNO, JOB)
ORDER BY 1,2;
--==>>
/*
10	    CLERK	    1300
10	    MANAGER	    2450
10	    PRESIDENT	5000
10	    (NULL)	    8750   -- 10번 부서 모든 직종의 급여합
20	    ANALYST	    6000
20	    CLERK	    1900
20	    MANAGER	    2975
20	    (NULL)	   10875   -- 20번 부서 모든 직종의 급여합
30	    CLERK	     950
30	    MANAGER	    2850
30	    SALESMAN	5600
30	    (NULL)	    9400   -- 30번 부서 모든 직종의 급여합
(NULL)	ANALYST	    6000   -- 모든 부서 ANALYST 직종의 급여합
(NULL)	CLERK	    4150   -- 모든 부서 CLERK 직종의 급여합
(NULL)	MANAGER	    8275   -- 모든 부서 MANAGER 직종의 급여합
(NULL)	PRESIDENT	5000   -- 모든 부서 PRESIDENT 직종의 급여합
(NULL)	SALESMAN	5600   -- 모든 부서 SALESMAN 직종의 급여합
(NULL)	(NULL)	   29025   -- 모든 부서 모든 직종의 급여합
*/

--※ ROLLUP() 과 CUBE() 는
--   그룹을 묶어주는 방식이 다르다.

-- ROLLUP(A, B, C)
-- → (A, B, C) / (A, B) / (A) / ()

-- CUBE(A, B, C)
-- → (A, B, C) / (A, B) / (A, C) / (B, C) / (A) / (B) / (C) / ()

--==>> 위의 처리 내용은 너무 많은 결과물이 출력되기 때문에
--     다음의 쿼리 형태를 더 많이 사용한다.
--     다음 작성하는 쿼리는 조회하고자 하는 그룹만 『GROUPING SETS』를
--     이용하여 묶어주는 방법이다.
SELECT CASE GROUPING(DEPTNO) WHEN 0 THEN NVL(TO_CHAR(DEPTNO), '인턴')
            ELSE '전체부서' 
        END "부서번호"
     , CASE GROUPING(JOB) WHEN 0 THEN JOB 
            ELSE '전체직종' 
        END "직종"
     , SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO,JOB)
ORDER BY 1,2;
--==>>
/*
10	        CLERK	    1300
10	        MANAGER	    2450
10	        PRESIDENT	5000
10	        전체직종	8750
20	        ANALYST	    6000
20	        CLERK	    1900
20	        MANAGER	    2975
20	        전체직종	10875
30	        CLERK	    950
30	        MANAGER	    2850
30	        SALESMAN	5600
30	        전체직종	9400
인턴	    CLERK	    2500
인턴	    SALESMAN	5500
인턴	    전체직종	8000
전체부서	전체직종	37025
*/
SELECT *
FROM TBL_EMP;

SELECT CASE GROUPING(DEPTNO) WHEN 0 THEN NVL(TO_CHAR(DEPTNO), '인턴')
            ELSE '전체부서' 
        END "부서번호"
     , CASE GROUPING(JOB) WHEN 0 THEN JOB 
            ELSE '전체직종' 
        END "직종"
     , SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY CUBE(DEPTNO,JOB)
ORDER BY 1,2;
--==>>
/*
10	        CLERK	    1300
10	        MANAGER	    2450
10	        PRESIDENT	5000
10	        전체직종	8750
20	        ANALYST	    6000
20	        CLERK	    1900
20	        MANAGER	    2975
20	        전체직종	10875
30	        CLERK	    950
30	        MANAGER	    2850
30	        SALESMAN	5600
30	        전체직종	9400
인턴	    CLERK	    2500
인턴	    SALESMAN	5500
인턴	    전체직종	8000
전체부서	ANALYST	    6000
전체부서	CLERK	    6650
전체부서	MANAGER	    8275
전체부서	PRESIDENT	5000
전체부서	SALESMAN	11100
전체부서	전체직종	37025
*/

SELECT CASE GROUPING(DEPTNO) WHEN 0 THEN NVL(TO_CHAR(DEPTNO), '인턴')
            ELSE '전체부서' 
        END "부서번호"
     , CASE GROUPING(JOB) WHEN 0 THEN JOB 
            ELSE '전체직종' 
        END "직종"
     , SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY GROUPING SETS((DEPTNO,JOB), (DEPTNO),())     -- ROLLUP() 과 같은 결과
ORDER BY 1,2;
/*
10	        CLERK	    1300
10	        MANAGER	    2450
10	        PRESIDENT	5000
10	        전체직종	8750
20	        ANALYST	    6000
20	        CLERK	    1900
20	        MANAGER	    2975
20	        전체직종	10875
30	        CLERK	    950
30	        MANAGER	    2850
30	        SALESMAN	5600
30	        전체직종	9400
인턴	    CLERK	    2500
인턴	    SALESMAN	5500
인턴	    전체직종	8000
전체부서	전체직종	37025
*/

SELECT CASE GROUPING(DEPTNO) WHEN 0 THEN NVL(TO_CHAR(DEPTNO), '인턴')
            ELSE '전체부서' 
        END "부서번호"
     , CASE GROUPING(JOB) WHEN 0 THEN JOB 
            ELSE '전체직종' 
        END "직종"
     , SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY GROUPING SETS((DEPTNO,JOB), (DEPTNO),(JOB),())     -- CUBE() 과 같은 결과
ORDER BY 1,2;
--==>>
/*
10	        CLERK	    1300
10	        MANAGER	    2450
10	        PRESIDENT	5000
10	        전체직종	8750
20	        ANALYST	    6000
20	        CLERK	    1900
20	        MANAGER	    2975
20	        전체직종	10875
30	        CLERK	    950
30	        MANAGER	    2850
30	        SALESMAN	5600
30	        전체직종	9400
인턴	    CLERK	    2500
인턴	    SALESMAN	5500
인턴	    전체직종	8000
전체부서	ANALYST	    6000
전체부서	CLERK	    6650
전체부서	MANAGER	    8275
전체부서	PRESIDENT	5000
전체부서	SALESMAN	11100
전체부서	전체직종	37025
*/


--○ TBL_EMP 테이블에서 입사년도별 인원수를 조회한다.
SELECT *
FROM TBL_EMP
ORDER BY HIREDATE;
/*
--------------------------
    입사년도    인원수
--------------------------
      1980          1
      1981         10
      1982          1
      1987          2
      2021          5
      전체         19
--------------------------      
*/
---------------나의 풀이----------------------------------------------
SELECT CASE GROUPING(EXTRACT(YEAR FROM HIREDATE)) WHEN 0 THEN TO_CHAR(EXTRACT(YEAR FROM HIREDATE))
            ELSE '전체' 
        END "입사년도" 
     , COUNT(HIREDATE)
FROM TBL_EMP
GROUP BY ROLLUP(EXTRACT(YEAR FROM HIREDATE))
ORDER BY 1;
--==>>
/*
입사년도       COUNT(HIREDATE)
-------------- ---------------
1980                         1
1981                        10
1982                         1
1987                         2
2021                         5
전체                        19
*/
SELECT CASE GROUPING(EXTRACT(YEAR FROM HIREDATE)) WHEN 0 THEN TO_CHAR(EXTRACT(YEAR FROM HIREDATE))
            ELSE '전체' 
        END "입사년도" 
     , COUNT(HIREDATE)
FROM TBL_EMP
GROUP BY CUBE(EXTRACT(YEAR FROM HIREDATE))
ORDER BY 1;
--==>>
/*
입사년도       COUNT(HIREDATE)
-------------- ---------------
1980                         1
1981                        10
1982                         1
1987                         2
2021                         5
전체                        19
*/
SELECT CASE GROUPING(EXTRACT(YEAR FROM HIREDATE)) WHEN 0 THEN TO_CHAR(EXTRACT(YEAR FROM HIREDATE))
            ELSE '전체' 
        END "입사년도" 
     , COUNT(HIREDATE)
FROM TBL_EMP
GROUP BY GROUPING SETS(EXTRACT(YEAR FROM HIREDATE),())
ORDER BY 1;
--==>>
/*
입사년도       COUNT(HIREDATE)
-------------- ---------------
1980                         1
1981                        10
1982                         1
1987                         2
2021                         5
*/
-- GROUPING SETS ()뒤에 넣어줌
/*
입사년도       COUNT(HIREDATE)
-------------- ---------------
1980                         1
1981                        10
1982                         1
1987                         2
2021                         5
전체                        19
*/


---------------함께 푼 풀이----------------------------------------------
SELECT EXTRACT(YEAR FROM HIREDATE) "입사년도"
     , COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY ROLLUP(EXTRACT(YEAR FROM HIREDATE))
ORDER BY 1;
--==>>
/*
1980	 1
1981	10
1982	 1
1987	 2
2021	 5
(NULL)	19
*/

SELECT EXTRACT(YEAR FROM HIREDATE) "입사년도"
     , COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY CUBE(EXTRACT(YEAR FROM HIREDATE))
ORDER BY 1;
--==>>
/*
1980	 1
1981	10
1982	 1
1987	 2
2021	 5
(NULL)	19
*/

SELECT EXTRACT(YEAR FROM HIREDATE) "입사년도"
     , COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY GROUPING SETS(EXTRACT(YEAR FROM HIREDATE),())
ORDER BY 1;
/*
1980	 1
1981	10
1982	 1
1987	 2
2021	 5
(NULL)	19
*/


SELECT EXTRACT(YEAR FROM HIREDATE) "입사년도"
     , COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY ROLLUP(TO_CHAR(HIREDATE,'YYYY'))       -- '1980' '1981' '1982'...
ORDER BY 1;
--==>> 에러 발생
/*
ORA-00979: not a GROUP BY expression
00979. 00000 -  "not a GROUP BY expression"
*Cause:    
*Action:
711행, 26열에서 오류 발생
*/

SELECT EXTRACT(YEAR FROM HIREDATE) "입사년도"
     , COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY CUBE(TO_CHAR(HIREDATE,'YYYY'))       -- '1980' '1981' '1982'...
ORDER BY 1;
--==>> 에러 발생
/*
ORA-00979: not a GROUP BY expression
00979. 00000 -  "not a GROUP BY expression"
*Cause:    
*Action:
725행, 26열에서 오류 발생
*/

SELECT EXTRACT(YEAR FROM HIREDATE) "입사년도"
     , COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY GROUPING SETS(TO_CHAR(HIREDATE,'YYYY'),())       -- '1980' '1981' '1982'...
ORDER BY 1;
--==>> 에러발생
/*
ORA-00979: not a GROUP BY expression
00979. 00000 -  "not a GROUP BY expression"
*Cause:    
*Action:
739행, 26열에서 오류 발생
*/

SELECT EXTRACT(YEAR FROM HIREDATE) "입사년도"
     , COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY TO_CHAR(HIREDATE,'YYYY')      -- '1980' '1981' '1982'...
ORDER BY 1;
--==>> 에러발생
/*
ORA-00979: not a GROUP BY expression
00979. 00000 -  "not a GROUP BY expression"
*Cause:    
*Action:
754행, 26열에서 오류 발생
*/

-- 그룹바이로 묶어준 것이랑 SELECT 조회해준 것이랑 데이터타입이 달라서 그렇다!
SELECT TO_CHAR(HIREDATE,'YYYY') "입사년도"
     , COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY TO_CHAR(HIREDATE,'YYYY')      -- '1980' '1981' '1982'...
ORDER BY 1;
--==>>
/*
1980	 1
1981	10
1982	 1
1987	 2
2021	 5
*/

SELECT EXTRACT(YEAR FROM HIREDATE) "입사년도"
     , COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY TO_NUMBER(TO_CHAR(HIREDATE,'YYYY'))     -- '1980' '1981' '1982'...
ORDER BY 1;
--==>> 에러 발생
/*
ORA-00979: not a GROUP BY expression
00979. 00000 -  "not a GROUP BY expression"
*Cause:    
*Action:
782행, 26열에서 오류 발생
*/
-- TO_CHAR(HIREDATE,'YYYY')이거를 TO_NUMBER로 바꿔서 데이터 타입을 SELECT와 맞춰도 안됨!
-- SELECT 와 그룹바이의 형식이 맞아야함!
-- 파싱순서가 GROUP BY 된걸 SELECT해주기 때문에 형식도 똑같이 올려줘야함!!

SELECT TO_NUMBER(TO_CHAR(HIREDATE,'YYYY')) "입사년도"
     , COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY TO_NUMBER(TO_CHAR(HIREDATE,'YYYY'))     -- '1980' '1981' '1982'...
ORDER BY 1;
--==>>
/*
1980	 1
1981	10
1982	 1
1987	 2
2021	 5
*/

--------------------------------------------------------------------------------

--■■■ HAVING ■■■--
/*
SELECT 컬럼명          --5
FROM 테이블명          --1
WHERE 조건절           --2
GROUP BY 절            --3
HAVING 조건절          --4
ORDER BY 절            --6
*/
-- HAVING 만 조건절!!!!!!!!!
-- GROUP 에 대한 조건!

--○ EMP 테이블에서 부서번호가 20, 30인 부서를 대상으로
--   부서의 총 급여가 10000 보다 적을 경우만 부서별 총 급여를 조회한다.
-- (HAVING 을 사용하지 않으면 어떤 문제가 발생하는지 봐라!)
SELECT DEPTNO "부서번호"
     , SUM(SAL) "총급여"
FROM EMP
WHERE DEPTNO IN(20,30)
GROUP BY DEPTNO;
--==>>
/*
30	 9400
20	10875
*/

SELECT DEPTNO "부서번호"
     , SUM(SAL) "총급여"
FROM EMP
WHERE DEPTNO IN(20,30)
  AND SUM(SAL)<10000
GROUP BY DEPTNO;
--==>> 이렇게  AND SUM(SAL)<10000 조건을 조회하려고 하니까 에러 발생!
/*
ORA-00934: group function is not allowed here
00934. 00000 -  "group function is not allowed here"
*Cause:    
*Action:
839행, 20열에서 오류 발생
*/

SELECT DEPTNO "부서번호"
     , SUM(SAL) "총급여"
FROM EMP
WHERE DEPTNO IN(20,30)
GROUP BY DEPTNO
HAVING SUM(SAL)<10000;
--==>>
/*
30	9400
*/

SELECT DEPTNO "부서번호"
     , SUM(SAL) "총급여"
FROM EMP
GROUP BY DEPTNO
HAVING DEPTNO IN(20,30)
   AND SUM(SAL)<10000;
--==>> 이렇게 해도 처리가 되지만, 뒤에 WHERE있는 절을 더 권장! 
--> 셀렉트문의 파싱순서에서 WHERE가 있는 것만 올려놓고 밑에를 처리하는 것이 모두 올려놓고 처리하는것 보다 리소스 소모가 적다!
/*
30	9400
*/

--------------------------------------------------------------------------------

--■■■ 중첩 그룹함수 / 분석함수 ■■■--
-- 함수에서 함수 중첩할때는 아래 코드정도까지만 가능!!
-- 그룹 함수 2 LEVEL 까지 중첩해서 사용할 수 있다.
-- 이마저도...MSSQL 은 불가능하다.
SELECT SUM(SAL) 
FROM EMP
GROUP BY DEPTNO;
--==>>
/*
 9400
10875
 8750
*/

SELECT MAX(SUM(SAL)) 
FROM EMP
GROUP BY DEPTNO;
--==>> 10875

-- RANK()
-- DENSE_RANK()
--> ORACLE 9i 부터 적용... MSSQL 2005 부터 적용...

--※ 하위 버전에서는 RANK() 나 DENSE_RANK() 를 사용할 수 없기 때문에
--   이를 대체하여 연산을 수행할 수 있는 방법을 강구해야 한다.

-- 예를 들어, 급여의 순위를 구하고자 한다면...
-- 해당 사원의 급여보다 더 큰 값이 몇 개인지 확인한 후
-- 확인한 숫자에 +1 을 추가 연산해주면 그것이 곧 등수가 된다.

-- 50을 기준으로 보면
-- 80 90 10 50   →  2 + 1 → 3
--          --

SELECT ENAME, SAL,1
FROM EMP;

SELECT COUNT(*) + 1
FROM EMP
WHERE SAL>800;
--==>> 14 → SMITH 의 급여 등수

SELECT COUNT(*) + 1
FROM EMP
WHERE SAL>1600;
--==>> 7 → ALLER 의 급여 등수

SELECT ENAME, SAL, RANK() OVER(ORDER BY SAL DESC)
FROM EMP;
--> 이렇게 나오도록 하기 위해!


--※ 서브 상관 쿼리(상관 서브 쿼리)
--   메인 쿼리에 있는 테이블의 컬럼이
--   서브 쿼리의 조건절(WHERE절, HAVING절)에 사용되는 경우
--   우리는 이 쿼리문을 서브 상관 쿼리 라고 부른다.

SELECT ENAME "사원명", SAL "급여", 1 "급여등수"
FROM EMP;

SELECT ENAME "사원명", SAL "급여", (SELECT COUNT(*) +1
                                    FROM EMP 
                                    WHERE SAL>800) "급여등수"
FROM EMP ;
--> 쿼리를 FROM 절에서 사용하는 것이아니라 컬럼명에 사용할 수 도있다!
--  아직 서브 상관 쿼리가 아니다

-- 서브 상관 쿼리!
SELECT ENAME "사원명", SAL "급여", 1 "급여등수"
FROM EMP;

SELECT E1.ENAME "사원명", E1.SAL "급여", (SELECT COUNT(*) +1
                                    FROM EMP E2
                                    WHERE E2.SAL>E1.SAL) "급여등수"
FROM EMP E1;
--==>>
/*
SMITH	 800	14
ALLEN	1600	 7
WARD	1250	10
JONES	2975	 4
MARTIN	1250	10
BLAKE	2850	 5
CLARK	2450	 6
SCOTT	3000	 2
KING	5000	 1
TURNER	1500	 8
ADAMS	1100	12
JAMES	 950	13
FORD	3000	 2
MILLER	1300	 9
*/

--○ EMP 테이블을 대상으로
--   사원명, 급여, 부서번호, 부서내급여등수, 전체급여등수 항목을 조회한다.
--   단, RANK() 함수를 사용하지 않고, 상관 서브 쿼리를 활용할 수 있도록 한다.

SELECT E1.ENAME "사원명", E1.SAL "급여", E1.DEPTNO "부서번호"
     , (SELECT COUNT(*) + 1 
        FROM EMP E2
        WHERE E2.SAL>E1.SAL AND E2.DEPTNO = E1.DEPTNO) "부서내급여등수"
     , (SELECT COUNT(*) + 1 
        FROM EMP E2
        WHERE E2.SAL>E1.SAL) "전체급여등수"
FROM EMP E1
ORDER BY E1.DEPTNO, E1.SAL DESC;
--==>>
/*
KING	5000	10	1	1
CLARK	2450	10	2	6
MILLER	1300	10	3	9
SCOTT	3000	20	1	2
FORD	3000	20	1	2
JONES	2975	20	3	4
ADAMS	1100	20	4	12
SMITH	 800	20	5	14
BLAKE	2850	30	1	5
ALLEN	1600	30	2	7
TURNER	1500	30	3	8
MARTIN	1250	30	4	10
WARD	1250	30	4	10
JAMES	 950	30	6	13
*/


SELECT COUNT(*) + 1 
FROM EMP 
WHERE SAL> 1600 AND DEPTNO = 30
ORDER BY DEPTNO;

SELECT ENAME, SAL, DEPTNO
FROM EMP
ORDER BY DEPTNO;


--○ EMP 테이블을 대상으로 다음과 같이 조회할 수 있도록 쿼리문을 구성한다.
/*
----------------------------------------------------------------------
    사원명 부서번호    입사일     급여      부서내입사별급여누적
----------------------------------------------------------------------
    CLERK   10       1981-06-09   2450          2450
    KING    10       1981-11-17   5000          7450
    MILLER  10       1982-01-23   1300          8750
    SMITH   20       1980-12-17    800           800
                            :
                            :
----------------------------------------------------------------------
*/
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

SELECT *
FROM EMP;

SELECT E1.ENAME "사원명", E1.DEPTNO "부서번호", E1.HIREDATE "입사일", E1.SAL "급여"
     , (SELECT SUM(SAL)
        FROM EMP E2
        WHERE E2.DEPTNO = E1.DEPTNO
          AND E2.HIREDATE <= E1.HIREDATE) "부서내입사별급여누적"
FROM EMP E1
ORDER BY DEPTNO,HIREDATE;
--==>>
/*
CLARK	10	1981-06-09	2450	2450
KING	10	1981-11-17	5000	7450
MILLER	10	1982-01-23	1300	8750
SMITH	20	1980-12-17	 800	800
JONES	20	1981-04-02	2975	3775
FORD	20	1981-12-03	3000	6775
SCOTT	20	1987-07-13	3000	10875   -- 입사일이 같기 때문에
ADAMS	20	1987-07-13	1100	10875   -- 두개가 합쳐진 4100이 합쳐져서 계산됨!
ALLEN	30	1981-02-20	1600	1600
WARD	30	1981-02-22	1250	2850
BLAKE	30	1981-05-01	2850	5700
TURNER	30	1981-09-08	1500	7200
MARTIN	30	1981-09-28	1250	8450
JAMES	30	1981-12-03	 950	9400
*/

-- +전체급여누적 구하기
SELECT E1.ENAME "사원명", E1.DEPTNO "부서번호", E1.HIREDATE "입사일", E1.SAL "급여"
     , (SELECT SUM(SAL)
        FROM EMP E2
        WHERE E2.HIREDATE <= E1.HIREDATE) "전체급여누적"
FROM EMP E1
ORDER BY HIREDATE;
/*
SMITH	20	1980-12-17	 800	800
ALLEN	30	1981-02-20	1600	2400
WARD	30	1981-02-22	1250	3650
JONES	20	1981-04-02	2975	6625
BLAKE	30	1981-05-01	2850	9475
CLARK	10	1981-06-09	2450	11925
TURNER	30	1981-09-08	1500	13425
MARTIN	30	1981-09-28	1250	14675
KING	10	1981-11-17	5000	19675
JAMES	30	1981-12-03	 950	23625
FORD	20	1981-12-03	3000	23625
MILLER	10	1982-01-23	1300	24925
SCOTT	20	1987-07-13	3000	29025
ADAMS	20	1987-07-13	1100	29025
*/


--○ TBL_EMP 테이블에서 입사한 사원의 수가 제일 많았을 때의
--   입사년월과 인원수를 조회할 수 있는 쿼리문을 구성한다.
/*
----------------------------------------
    입사년월        인원수
----------------------------------------
    2021-09            5
----------------------------------------
*/

-- 나의 풀이--------------------------------------------
SELECT E1.HIREDATE
     , (SELECT COUNT(*) 
        FROM TBL_EMP E2
        WHERE MAX(EXTRACT(HIREDATE,'YYYY-MM'))
FROM TBL_EMP E1
ORDER BY HIREDATE;

-- 풀이--------------------------------------------------
SELECT TO_CHAR(HIREDATE,'YYYY-MM') "입사년월"
     , COUNT(*) "인원수"
FROM TBL_EMP 
GROUP BY TO_CHAR(HIREDATE,'YYYY-MM')
HAVING COUNT(*) = (5);
--==>> 2021-09	5
/*
-- HAVING 조건절 넣기 전
2021-09	5
1981-05	1
1981-12	2
1982-01	1
1981-09	2
1981-02	2
1981-11	1
1980-12	1
1981-04	1
1987-07	2
1981-06	1
*/

-- 입사년월별 인원수가 가장 큰 수
SELECT MAX(COUNT(*))
FROM TBL_EMP
GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM');


-- (5) 에 위에 구한거 복붙해주면 끝!
SELECT TO_CHAR(HIREDATE,'YYYY-MM') "입사년월"
     , COUNT(*) "인원수"
FROM TBL_EMP 
GROUP BY TO_CHAR(HIREDATE,'YYYY-MM')
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                    FROM TBL_EMP
                    GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM'));
--==>> 2021-09	5

--------------------------------------------------------------------------------

--■■■ ROW_NUBER() ■■■--
-- 행번호처럼 붙게끔 나오는 것
SELECT ENAME "사원명", SAL "급여", HIREDATE "입사일"
FROM EMP;

SELECT ROW_NUMBER() OVER(ORDER BY SAL DESC) "테스트"
    , ENAME "사원명", SAL "급여", HIREDATE "입사일"
FROM EMP;
--==>>
/*
테스트 사원명 급여 입사일       
--- ------- ------- ---------- 
1	KING	5000	1981-11-17
2	FORD	3000	1981-12-03
3	SCOTT	3000	1987-07-13
4	JONES	2975	1981-04-02
5	BLAKE	2850	1981-05-01
6	CLARK	2450	1981-06-09
7	ALLEN	1600	1981-02-20
8	TURNER	1500	1981-09-08
9	MILLER	1300	1982-01-23
10	WARD	1250	1981-02-22
11	MARTIN	1250	1981-09-28
12	ADAMS	1100	1987-07-13
13	JAMES	 950	1981-12-03
14	SMITH	 800	1980-12-17
*/

--※ 게시판의 게시물 번호는 SEQUENCE 나 IDENTITY 를 사용하게 되면
--   게시물을 삭제했을 경우, 삭제한 게시물의 자리에 다음 번호를 가진
--   게시물이 등록되는 상황이 발생하게 된다.
--   이는 보안 측면에서나... 미관적인 측면에서나... 바람직하지 않은 상황일 수 있기 때문에
--   ROW_NUMBER() 의 사용을 고려해 볼 수 있다.
--   관리의 목적으로 사용할 때에는 SEQUENCE 나 IDENTITY 를 사용하지만
--   단순히 게시물을 목록화하여 사용자에게 리스트 형식으로 보여줄 때에는
--   사용하지 않는 것이 좋다.

-->(캡쳐그림) 시퀀스 아이덴티 설명 비디오
-- 관리의 목적으로 SEQUENCE 사용!



--○ 관찰
CREATE TABLE TBL_AAA
(NO         NUMBER  
,NAME       VARCHAR2(30)
,GRADE      CHAR(10)
);
--==>> Table TBL_AAA이(가) 생성되었습니다.

INSERT INTO TBL_AAA(NO, NAME, GRADE) VALUES(1,'손범석', 'A');
INSERT INTO TBL_AAA(NO, NAME, GRADE) VALUES(2,'송해덕', 'B');
INSERT INTO TBL_AAA(NO, NAME, GRADE) VALUES(3,'김진령', 'A');
INSERT INTO TBL_AAA(NO, NAME, GRADE) VALUES(4,'최수지', 'D');
INSERT INTO TBL_AAA(NO, NAME, GRADE) VALUES(5,'서승균', 'A');
INSERT INTO TBL_AAA(NO, NAME, GRADE) VALUES(6,'정미화', 'A');
INSERT INTO TBL_AAA(NO, NAME, GRADE) VALUES(7,'손범석', 'A');
--==>> 1 행 이(가) 삽입되었습니다. * 7

SELECT *
FROM TBL_AAA;
--==>>
/*
1	손범석	A         
2	송해덕	B         
3	김진령	A         
4	최수지	D         
5	서승균	A         
6	정미화	A         
7	손범석	A         
*/

COMMIT;
--==>> 커밋 완료.

UPDATE TBL_AAA
SET GRADE='A'
WHERE NAME = '최수지';
--==>> 1 행 이(가) 업데이트되었습니다.
SELECT *
FROM TBL_AAA;
--==>>
/*
1	손범석	A         
2	송해덕	B         
3	김진령	A         
4	최수지	A         
5	서승균	A         
6	정미화	A         
7	손범석	A         
*/


UPDATE TBL_AAA
SET NAME = '송해덕'
WHERE GRADE = 'A';


UPDATE TBL_AAA
SET GRADE = 'A'
WHERE NAME = '손범석';

-- 위에 두개를 하려고 하면 할수없기때문에 앞에 NO가 있어야함!!그게바로 시퀀스

--○ SEQUENCE(시뭔스 : 주문번호) 생성
--   → 사전적인 의미 : 1.(일련의) 연속적인 사건들 2.(사건, 행동 등의) 순서

CREATE SEQUENCE SEQ_BOARD   -- 시뭔스 생성 기본 구문(MSSQL 의 IDENTITY 와 동일한 개념)
START WITH 1                -- 시작값(시퀀스는 1번부터 시작값을 잡겟따)
INCREMENT BY 1              -- 증가값(1씩증가하게 하겠다)
NOMAXVALUE                  -- 최대값 제한 없음
NOCACHE;                    -- 캐시 사용 안함(없음)
--==>> Sequence SEQ_BOARD이(가) 생성되었습니다.
-- 1부터 시작해서 최대값 제한 없고 캐시 사용하지 않고 하나씩 증가하는 시퀀스를 만들어줌

-- 마지막 캐시를 사용안하는건 어떤의미?
--> 은행에서 줄서서 번호표 뽑는데 번호표를 10장씩 뽑아놓고 나눠주는 사람 == 캐시
-- 접속자수와 트래픽이 많아졌을때 유용하지만, 버려지는 시퀀스들이 많아짐

--○ 테이블 생성(TBL_BOARD)
CREATE TABLE TBL_BOARD                  -- TBL_BOARD 이름의 테이블 생성 → 게시판
( NO            NUMBER                  -- 게시물 번호       -- X(내가작성 안함)
, TITLE         VARCHAR2(50)            -- 게시물 제목       -- O
, CONTENTS      VARCHAR2(2000)          -- 게시물 내용       -- O
, NAME          VARCHAR2(20)            -- 게시물 작성자     -- △(만드는거에 따라 다름)
, PW            VARCHAR2(20)            -- 게시물 패스워드   -- △(만드는거에 따라 다름)
, CREATED       DATE DEFAULT SYSDATE    -- 게시물 작성일     -- X
);
--==>> Table TBL_BOARD이(가) 생성되었습니다.

--○ 데이터 입력 → 게시판에 게시물 작성
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '앗싸~1등', '내가 1등이지롱','이찬호','JAVA006$',SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '건강관리', '다들 건강 챙깁시다','이윤서','JAVA006$',SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '오늘은', '저녁 뭘 먹지','손다정','JAVA006$',SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '오늘은', '갑자기 비가 오네','윤유동','JAVA006$',SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '공부하고싶은데', '자꾸 졸려요','정효진','JAVA006$',SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '질문', '배고프면 어덯게 하나요','박혜진','JAVA006$',SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '질문', '어려우면 어떡하죠','박효빈','JAVA006$',SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.

SELECT *
FROM TBL_BOARD;
--==>>
/*
1	앗싸~1등	    내가 1등이지롱	        이찬호	JAVA006$	2021-09-06
2	건강관리	    다들 건강 챙깁시다	    이윤서	JAVA006$	2021-09-06
3	오늘은	        저녁 뭘 먹지	        손다정	JAVA006$	2021-09-06
4	오늘은	        갑자기 비가 오네	    윤유동	JAVA006$	2021-09-06
5	공부하고싶은데	자꾸 졸려요	            정효진	JAVA006$	2021-09-06
6	질문	        배고프면 어덯게 하나요	박혜진	JAVA006$	2021-09-06
7	질문	        어려우면 어떡하죠	    박효빈	JAVA006$	2021-09-06
*/


COMMIT;
--==>> 커밋 완료.

--○ 게시물 삭제
DELETE
FROM TBL_BOARD
WHERE NO=5;
--==>> 1 행 이(가) 삭제되었습니다.

--○ 게시물 작성
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '졸려요', '전 그냥 잘래요','김진희','JAVA006$',SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.

--○ 게시물 삭제
DELETE
FROM TBL_BOARD
WHERE NO=2;
--==>> 1 행 이(가) 삭제되었습니다.

--○ 확인
SELECT *
FROM TBL_BOARD;
/*
1	앗싸~1등	내가 1등이지롱	        이찬호	JAVA006$	2021-09-06
3	오늘은	    저녁 뭘 먹지	        손다정	JAVA006$	2021-09-06
4	오늘은	    갑자기 비가 오네	    윤유동	JAVA006$	2021-09-06
6	질문	    배고프면 어덯게 하나요	박혜진	JAVA006$	2021-09-06
7	질문	    어려우면 어떡하죠	    박효빈	JAVA006$	2021-09-06
8	졸려요	    전 그냥 잘래요	        김진희	JAVA006$	2021-09-06
*/
--○ 게시물 삭제
DELETE
FROM TBL_BOARD
WHERE NO=7;
--==>> 1 행 이(가) 삭제되었습니다.

--○ 게시물 삭제
DELETE
FROM TBL_BOARD
WHERE NO=8;
--==>> 1 행 이(가) 삭제되었습니다.

--○ 확인
SELECT *
FROM TBL_BOARD;
--==>>
/*
1	앗싸~1등	내가 1등이지롱	        이찬호	JAVA006$	2021-09-06
3	오늘은	    저녁 뭘 먹지	        손다정	JAVA006$	2021-09-06
4	오늘은	    갑자기 비가 오네	    윤유동	JAVA006$	2021-09-06
6	질문	    배고프면 어덯게 하나요	박혜진	JAVA006$	2021-09-06
*/

--○ 게시물 작성
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '저는요', '잘 지내고 있어요','정가연','JAVA006$',SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.

-- 어덯게 오타 어떻게로 고침
UPDATE TBL_BOARD
SET CONTENTS = '배고프면 어떻게 하나요'
WHERE NAME = '박혜진';
--==>> 1 행 이(가) 업데이트되었습니다.

COMMIT;
--==>> 커밋 완료.


--○ 확인
SELECT *
FROM TBL_BOARD;
--==>>
/*
1	앗싸~1등	내가 1등이지롱	    이찬호	JAVA006$	2021-09-06
3	오늘은	저녁 뭘 먹지	        손다정	JAVA006$	2021-09-06
4	오늘은	갑자기 비가 오네	    윤유동	JAVA006$	2021-09-06
6	질문	배고프면 어떻게 하나요	박혜진	JAVA006$	2021-09-06
9	저는요	잘 지내고 있어요	    정가연	JAVA006$	2021-09-06
*/

-- 이러면 게시물 번호가 연동이 안됨! 그래서 ROW_NUMBER()를 사용!!

SELECT ROW_NUMBER() OVER(ORDER BY CREATED) "글번호"
     , TITLE "제목", NAME "작성자", CREATED "작성일"
FROM TBL_BOARD
ORDER BY 4 DESC;
--==>>
/*
5	저는요	    정가연	2021-09-06
4	질문	    박혜진	2021-09-06
3	오늘은	    윤유동	2021-09-06
2	오늘은	    손다정	2021-09-06
1	앗싸~1등	이찬호	2021-09-06
*/

--○ 게시물 작성
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '멋지죠', '멋져 멋져','이중호','JAVA006$',SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.

COMMIT;
--==>> 커밋 완료.

SELECT ROW_NUMBER() OVER(ORDER BY CREATED) "글번호"
     , TITLE "제목", NAME "작성자", CREATED "작성일"
FROM TBL_BOARD
ORDER BY 4 DESC;
--==>>
/*
6	멋지죠	이중호	2021-09-06
5	저는요	정가연	2021-09-06
4	질문	박혜진	2021-09-06
3	오늘은	윤유동	2021-09-06
2	오늘은	손다정	2021-09-06
1	앗싸~1등	이찬호	2021-09-06
*/

DELETE
FROM TBL_BOARD
WHERE NO=3;
--==>> 1 행 이(가) 삭제되었습니다.

COMMIT;
--==>> 커밋 완료.

SELECT ROW_NUMBER() OVER(ORDER BY CREATED) "글번호"
     , TITLE "제목", NAME "작성자", CREATED "작성일"
FROM TBL_BOARD
ORDER BY 4 DESC;
--==>>
/*
5	멋지죠	    이중호	2021-09-06
4	저는요	    정가연	2021-09-06
3	질문	    박혜진	2021-09-06
2	오늘은	    윤유동	2021-09-06
1	앗싸~1등	이찬호	2021-09-06
*/

