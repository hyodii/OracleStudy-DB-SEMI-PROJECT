SELECT USER
FROM DUAL;
--==>> SCOTT

/*

  파일번호 파일명                                                                                                 
---------- ------------------------------------------
         1 C:\AAA\BBB\CCC\SALES.DOC                                                                            
         2 C:\AAA\PANMAE.XXLS                                                                                  
         3 D:\RESEARCH.PPT                                                                                     
         4 C:\DOCUMENTS\STUDY.HWP                                                                              
         5 C:\DOCUMENTS\TEMP\SQL.TXT                                                                           
         6 D:\SHARE\F\TEST.PNG                                                                                 
         7 C:\USER\GUILDONG\PICTURE\PHOTO\SPRING.JPG                                                           
         8 C:\ORACLESTUDY\20210901_01_SCOTT.SQL    
*/
--○ TBL_FILES 테이블을 대상으로 위와 같이 조회될 수 있도록
--   쿼리문을 구성한다.
SELECT FILENO "파일번호", FILENAME "경로포함 파일명", SUBSTR(FILENAME,16,9) "파일명"
FROM TBL_FILES
WHERE FILENO=1;
--==>> 1	C:\AAA\BBB\CCC\SALES.DOC	SALES.DOC

SELECT FILENO "파일번호", FILENAME "경로포함 파일명", SUBSTR(FILENAME,16,9) "파일명"
FROM TBL_FILES;
--==>>
/*
1	C:\AAA\BBB\CCC\SALES.DOC	SALES.DOC
2	C:\AAA\PANMAE.XXLS	XLS
3	D:\RESEARCH.PPT	
4	C:\DOCUMENTS\STUDY.HWP	UDY.HWP
5	C:\DOCUMENTS\TEMP\SQL.TXT	MP\SQL.TX
6	D:\SHARE\F\TEST.PNG	.PNG
7	C:\USER\GUILDONG\PICTURE\PHOTO\SPRING.JPG	G\PICTURE
8	C:\ORACLESTUDY\20210901_01_SCOTT.SQL	20210901_
*/

SELECT FILENO "파일번호", FILENAME "경로포함파일명", REVERSE(FILENAME) "거꾸로"
FROM TBL_FILES;
/*
COD.SELAS               \CCC\BBB\AAA\:C
SLXX.EAMNAP             \AAA\:C
TPP.HCRAESER            \:D
PWH.YDUTS               \STNEMUCOD\:C
TXT.LQS                 \PMET\STNEMUCOD\:C
GNP.TSET                \F\ERAHS\:D
GPJ.GNIRPS              \OTOHP\ERUTCIP\GNODLIUG\RESU\:C
LQS.TTOCS_10_10901202   \YDUTSELCARO\:C
*/

-- 뒤집에서 동일한 조건으로 자르고 다시 뒤집으면 됨!
SELECT REVERSE(FILENAME) ,INSTR(REVERSE(FILENAME),'\',1,1), SUBSTR(REVERSE(FILENAME),1,INSTR(REVERSE(FILENAME),'\',1,1)-1)
    , REVERSE(SUBSTR(REVERSE(FILENAME),1,INSTR(REVERSE(FILENAME),'\',1,1)-1))
FROM TBL_FILES;
--==>> 풀이중..1
/*
COD.SELAS\CCC\BBB\AAA\:C	                10	COD.SELAS	                SALES.DOC
SLXX.EAMNAP\AAA\:C	                        12	SLXX.EAMNAP	                PANMAE.XXLS
TPP.HCRAESER\:D	                            13	TPP.HCRAESER	            RESEARCH.PPT
PWH.YDUTS\STNEMUCOD\:C	                    10	PWH.YDUTS	                STUDY.HWP
TXT.LQS\PMET\STNEMUCOD\:C	                8	TXT.LQS	                    SQL.TXT
GNP.TSET\F\ERAHS\:D	                        9	GNP.TSET	                TEST.PNG
GPJ.GNIRPS\OTOHP\ERUTCIP\GNODLIUG\RESU\:C	11	GPJ.GNIRPS	                SPRING.JPG
LQS.TTOCS_10_10901202\YDUTSELCARO\:C	    22	LQS.TTOCS_10_10901202	    20210901_01_SCOTT.SQL
*/

SELECT FILENO "파일번호", REVERSE(SUBSTR(REVERSE(FILENAME),1,INSTR(REVERSE(FILENAME),'\',1,1)-1))
FROM TBL_FILES;
--==>> 풀이중..2
/*
1	SALES.DOC
2	PANMAE.XXLS
3	RESEARCH.PPT
4	STUDY.HWP
5	SQL.TXT
6	TEST.PNG
7	SPRING.JPG
8	20210901_01_SCOTT.SQL
*/


SELECT FILENO "파일번호", SUBSTR( FILENAME, INSTR(FILENAME,'\',-1)+1)
FROM TBL_FILES;
--==>> 풀이중..3
/*
1	SALES.DOC
2	PANMAE.XXLS
3	RESEARCH.PPT
4	STUDY.HWP
5	SQL.TXT
6	TEST.PNG
7	SPRING.JPG
8	20210901_01_SCOTT.SQL
*/

SELECT *
FROM TBL_FILES;

------------------------풀이--------------------------
SELECT FILENO "파일번호", FILENAME "경로포함파일명", REVERSE(FILENAME) "거꾸로"
FROM TBL_FILES;
/*
1	C:\AAA\BBB\CCC\SALES.DOC	                COD.SELAS\CCC\BBB\AAA\:C
2	C:\AAA\PANMAE.XXLS	                        SLXX.EAMNAP\AAA\:C
3	D:\RESEARCH.PPT	                            TPP.HCRAESER\:D
4	C:\DOCUMENTS\STUDY.HWP	                    PWH.YDUTS\STNEMUCOD\:C
5	C:\DOCUMENTS\TEMP\SQL.TXT	                TXT.LQS\PMET\STNEMUCOD\:C
6	D:\SHARE\F\TEST.PNG	                        GNP.TSET\F\ERAHS\:D
7	C:\USER\GUILDONG\PICTURE\PHOTO\SPRING.JPG	GPJ.GNIRPS\OTOHP\ERUTCIP\GNODLIUG\RESU\:C
8	C:\ORACLESTUDY\20210901_01_SCOTT.SQL	    LQS.TTOCS_10_10901202\YDUTSELCARO\:C
*/
SELECT FILENO "파일번호", FILENAME "경로포함파일명"
     , SUBSTR(REVERSE(FILENAME), 1, 최초 '\'가 등장하는 위치 -1) "거꾸로된 파일명"
FROM TBL_FILES;

-- 최초 '\'가 등장하는 위치
INSTR(REVERSE(FILENAME),'\',1)      -- 마지막 매개변수 1 생략  
     
SELECT FILENO "파일번호", FILENAME "경로포함파일명"
     , SUBSTR(REVERSE(FILENAME), 1, INSTR(REVERSE(FILENAME),'\',1) -1) "거꾸로된 파일명"
FROM TBL_FILES;     
/*
 파일번호 경로포함파일명                                     거꾸로된 파일명                                                                                            
---------- ------------------------------------------------- ------------------------
         1 C:\AAA\BBB\CCC\SALES.DOC                          COD.SELAS                                                                                           
         2 C:\AAA\PANMAE.XXLS                                SLXX.EAMNAP                                                                                         
         3 D:\RESEARCH.PPT                                   TPP.HCRAESER                                                                                        
         4 C:\DOCUMENTS\STUDY.HWP                            PWH.YDUTS                                                                                           
         5 C:\DOCUMENTS\TEMP\SQL.TXT                         TXT.LQS                                                                                             
         6 D:\SHARE\F\TEST.PNG                               GNP.TSET                                                                                            
         7 C:\USER\GUILDONG\PICTURE\PHOTO\SPRING.JPG         GPJ.GNIRPS                                                                                          
         8 C:\ORACLESTUDY\20210901_01_SCOTT.SQL              LQS.TTOCS_10_10901202    
*/     
SELECT FILENO "파일번호"--, FILENAME "경로포함파일명"
     ,REVERSE(SUBSTR(REVERSE(FILENAME), 1, INSTR(REVERSE(FILENAME),'\',1) -1)) "파일명"
FROM TBL_FILES;      
/*
1	SALES.DOC
2	PANMAE.XXLS
3	RESEARCH.PPT
4	STUDY.HWP
5	SQL.TXT
6	TEST.PNG
7	SPRING.JPG
8	20210901_01_SCOTT.SQL
*/   

     
     
--○ LPAD()     
    --> Byte 공간을 확보하여 왼쪽부터 문자로 채우는 기능을 가진 함수
    -- 이함수를 볼때는 항상 두 번째 파라미터를 먼저 봐라!
SELECT 'ORACLE' "1"
      , LPAD('ORACLE',10,'*') "2"
FROM DUAL;
--==>> ORACLE	****ORACLE
--> 1. 10Byte 공간을 확보한다.                 → 두 번째 파라미터 값에 의해...
--  2. 확보한 공간에 'ORACLE' 문자열을 담는다. → 첫 번째 파라미터 값에 의해...
--  3. 남아있는 Byte 공간을 왼쪽부터 세 번째 파라미터 값으로 채운다.
--  4. 이렇게 구성된 최종 결과값을 반환한다.

SELECT 'ORACLE' "1"
     , LPAD('ORACLE',20,'$') "특수기호"
     , LPAD('ORACLE',20,'A') "영어"
     , LPAD('ORACLE',20,'ㅁ') "한글자음"
     , LPAD('ORACLE',20,'ㅔ') "한글모음"
     , LPAD('ORACLE',20,'오') "한글"
FROM DUAL;
--==>>
/*
ORACLE	
$$$$$$$$$$$$$$ORACLE        -- 특수기호 1BYTE	
AAAAAAAAAAAAAAORACLE        -- 영어     1BYTE		
ㅁㅁㅁㅁㅁㅁㅁORACLE        -- 한글자음 2BYTE		
ㅔㅔㅔㅔㅔㅔㅔORACLE        -- 한글모음 2BYTE		
오오오오오오오ORACLE        -- 한글2    2BYTE	
*/

--○ RPAD()       
--> Byte 공간을 확보하여 오른쪽부터 문자로 채우는 기능을 가진 함수
SELECT 'ORCAL' "1"
      , RPAD('ORACLE',10,'*') "2"
FROM DUAL;
--==>> ORCAL	ORACLE****
--> 1. 10Byte 공간을 확보한다.                 → 두 번째 파라미터 값에 의해...
--  2. 확보한 공간에 'ORACLE' 문자열을 담는다. → 첫 번째 파라미터 값에 의해...
--  3. 남아있는 Byte 공간을 오른쪽부터 세 번째 파라미터 값으로 채운다.
--  4. 이렇게 구성된 최종 결과값을 반환한다.     
     
--○ TRIM() 자바에서의 손톱깎이
-- 오라클에서는 LTRIM() / RTRIM()
--> 가공하고 처리하는걸 버리는 유일한 함수

--○ LTRIM()
SELECT 'ORAORAORACLEORACLE' "1"     -- 오라 오라 오라클 오라클
     , LTRIM('ORAORAORACLEORACLE', 'ORA') "2"
     , LTRIM('AAAORAORAORACLEORACLE', 'ORA') "3"
     , LTRIM('ORAoRAORACLEORACLE', 'ORA') "4"
     , LTRIM('ORA ORAORACLEORACLE', 'ORA') "5"
     , LTRIM('          ORAORAORACLEORACLE', ' ') "6"
     , LTRIM('                      ORACLE') "7"    -- 왼쪽 공백 제거 함수로 활용(두 번째 파라미터 생략)
FROM DUAL;   
--==>> 
/*
ORAORAORACLEORACLE	
CLEORACLE	
CLEORACLE	
oRAORACLEORACLE	
 ORAORACLEORACLE	
ORAORAORACLEORACLE	
ORACLE
*/
--> 첫 번째 파라미터 값에 해당하는 문자열을 대상으로
--  왼쪽부터 연속적으로 두 번째 파라미터 값에서 지정한 글자와 같은 글자가 등장할 경우
--  이를 제거한 결과값을 반환한다.
--  단, 완성형으로 처리되지 않는다.

--ORA 뭉텅이로 자르는거 아님
--하나씩 'ORA' 확인해서 O 하나 R 하나 A 하나 이런식으로 계속 확인해서 손톱깎이처럼 자름
--대소문자 구분한다!
--공백도 일반문자와 똑같이 처리!  중간에 있는 공백은 못없앰!(자바에서도 마찬가지)

SELECT LTRIM('이김신이김신이이신신김이신신이김김김이신박이김신', '이김신') "TEST"
FROM DUAL;
--==>> 박이김신

--○ RTRIM()     
SELECT 'ORAORAORACLEORACLE' "1"     -- 오라 오라 오라클 오라클
     , RTRIM('ORAORAORACLEORACLE', 'ORA') "2"
     , RTRIM('AAAORAORAORACLEORACLE', 'ORA') "3"
     , RTRIM('ORAoRAORACLEORACLE', 'ORA') "4"
     , RTRIM('ORA ORAORACLEORACLE', 'ORA') "5"
     , RTRIM('          ORAORAORACLEORACLE', ' ') "6"
     , RTRIM('ORACLE                      ') "7"    -- 오른쪽 공백 제거 함수로 활용(두 번째 파라미터 생략)
FROM DUAL;      
--==>>
/*
ORAORAORACLEORACLE	
ORAORAORACLEORACLE	
AAAORAORAORACLEORACLE	
ORAoRAORACLEORACLE	
ORA ORAORACLEORACLE
          ORAORAORACLEORACLE
ORACLE
*/
--> 첫 번째 파라미터 값에 해당하는 문자열을 대상으로
--  오른쪽부터 연속적으로 두 번째 파라미터 값에서 지정한 글자와 같은 글자가 등장할 경우
--  이를 제거한 결과값을 반환한다.
--  단, 완성형으로 처리되지 않는다.     
     
--○ TRANSLATE()     
--> 1:1 로 바꾸어 준다.     

SELECT TRANSLATE('MY ORACLE SERVER'
               , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
               , 'abcdefghijklmnopqrstuvwxyz') "RESULT"
FROM DUAL;
--==>> my oracle server

SELECT TRANSLATE('my oracle server'
               , 'abcdefghijklmnopqrstuvwxyz'
               , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') "RESULT"
FROM DUAL;
--==>> MY ORACLE SERVER
     
SELECT TRANSLATE('010-8743-7042'
                ,'0123456789'
                ,'영일이삼사오육칠팔구') "RESULT"
FROM DUAL;    
--==>> 영일영-팔칠사삼-칠영사이     
     
--○ REPLAECE()
SELECT REPLACE('MY ORACLE ORAHOME', 'ORA', '오라')
FROM DUAL;
--==>> MY 오라CLE 오라HOME     

--------------------------------------------------------------------------------
     
--○ ROUND() 반올림을 처리해주는 함수
SELECT 48.678 "1"
     , ROUND(48.678,2) "2"      -- 소수점 이하 둘째자리까지 표현(→ 셋째 자리에서 반올림)
     , ROUND(48.674,2) "3"
     , ROUND(48.674,1) "4"
     , ROUND(48.674,0) "5"      -- 정수로 표현
     , ROUND(48.674) "6"        -- 두 번째 파라미터 값이 0일 경우 생략 가능
     , ROUND(48.674,-1) "7"     -- 10의 자리까지 표현
     , ROUND(48.674,-2) "8"     -- 100의 자리까지 유효하게 표현
     , ROUND(48.674,-3) "9"     -- 1000의 자리까지 유효하게 표현
FROM DUAL;
--==>> 48.678	48.68	48.67	48.7	49	49	50	0	0     
     
--○ TRUNC()  절삭을 처리해주는 함수   
SELECT 48.678 "1"
     , TRUNC(48.678,2) "2"      -- 소수점 이하 둘째자리까지 표현(→ 셋째 자리에서 반올림)
     , TRUNC(48.674,2) "3"
     , TRUNC(48.674,1) "4"
     , TRUNC(48.674,0) "5"      -- 정수로 표현
     , TRUNC(48.674) "6"        -- 두 번째 파라미터 값이 0일 경우 생략 가능
     , TRUNC(48.674,-1) "7"     -- 10의 자리까지 표현
     , TRUNC(48.674,-2) "8"     -- 100의 자리까지 유효하게 표현
     , TRUNC(48.674,-3) "9"     -- 1000의 자리까지 유효하게 표현
FROM DUAL;     
--==>> 48.678	48.67	48.67	48.6	48	48	40	0	0     

--○ MOD() 나머지를 반환하는 함수 %      
SELECT MOD(5,2) "RESULT"
FROM DUAL;     
--==>> 1
--> 5를 2로 나눈 나머지 결과값 반환

--○ POWER() 제곱의 결과를 반환하는 함수.
SELECT POWER(5,3) "RESULT"
FROM DUAL;
--==>> 125
--> 5의 3승을 결과값으로 반환

--○ SQRT() 루트 결과를 반환하는 함수
SELECT SQRT(2)
FROM DUAL;
--==>> 1.41421356237309504880168872420969807857
--> 루트 2에 대한 결과괎 반환

--○ LOG 로그 함수
--  (※ 오라클은 상용로그만 지원하는 반면, MSSQL은 상용로그, 자연로그 모두 지원한다.)
SELECT LOG(10,100), LOG(10,20)
FROM DUAL;
--==>> 2	1.30102999566398119521373889472449302677

--○ 삼각함수
--  싸인, 코싸인, 탄젠트 결과값을 반환한다.
SELECT SIN(1), COS(1), TAN(1)
FROM DUAL;
--==>>
/*
0.8414709848078965066525023216302989996233	
0.5403023058681397174009366074429766037354	
1.55740772465490223050697480745836017308
*/

--○ 삼각함수의 역함수 (범위 : -1 ~ 1)
--   어싸인, 어코싸인, 어탄젠트 결과값을 반환한다.
SELECT ASIN(0.5), ACOS(0.5), ATAN(0.5)
FROM DUAL;
--==>> 
/*
0.52359877559829887307710723054658381405	
1.04719755119659774615421446109316762805	
0.4636476090008061162142562314612144020295
*/

-- 연산관련은 DB에서 쓰는일 별로없지만
-- 이건 종종씀
--○ SIGN()      서명, 부호, 특징
--> 연산 결과값이 양수이면 1, 0이면 0, 음수이면 -1을 반환한다.
SELECT SIGN(5-2), SIGN(5-5), SIGN(5-8)
FROM DUAL;
--==>> 1	0	-1
--> 매출이나 수지와 관련하여 적자 및 흑자의 개념을 나타낼 때 주로 사용한다.

--○ ASCII(), CHR()  → 서로 상응하는 개념의 함수
SELECT ASCII('A') "RESULT1", CHR(65) "RESULT2"
FROM DUAL;
--==>> 65	A
--> ASCII() : 매개변수로 넘겨받은 문자의 아스키코드 값을 반환한다.
--  CHR()   : 매개변수로 넘겨받은 숫자를 아스키코드 값으로 취하는 문자를 반환한다.


-- 숫자 관련 타입
--------------------------------------------------------------------------------
-- 날짜관련 타입

--※ 날짜 관련 세션 설정 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
--==>> Session이(가) 변경되었습니다.

--※ 날짜연산의 기본 단위는 DAY(일수)이다~!!! CHECK~!!!
SELECT SYSDATE "1"
     , SYSDATE + 1 "2"
     , SYSDATE - 2 "3"
     , SYSDATE + 3 "4"
FROM DUAL;
--==>> 
/*
2021-09-02 10:35:54	        -- 현재
2021-09-03 10:35:54	        -- 1일 후
2021-08-31 10:35:54	        -- 2일 전
2021-09-05 10:35:54         -- 3일 후
*/

--○ 시간 단위 연산
SELECT SYSDATE "1", SYSDATE + 1/24 "2", SYSDATE - 2/24 "3"
FROM DUAL;
-==>>
/*
2021-09-02 10:38:09	        -- 현재	
2021-09-02 11:38:09	        -- 한시간 후	
2021-09-02 08:38:09	        -- 2시간 전
*/

--○ 현재 시간과... 현재 시간 기준 1일 2시간 3분 4초 후를 조회한다.

/*
---------------------------------------------------------------
        현재시간                연산 후 시간
---------------------------------------------------------------
    2021-09-02 10:40:13      2021-09-03 12:43:17
---------------------------------------------------------------
*/
-- 나의 풀이 땡~!
--> 시간은 나누는게 맞는데 분, 초는 곱해야함!!!!
SELECT SYSDATE "현재시간", SYSDATE +1 +2/24 + 3/24/60 + 4/24/60/3600 "연산 후 시간"
FROM DUAL;
--==>>
/*
현재시간                연산 후 시간            
------------------- -------------------
2021-09-04 20:15:07 2021-09-05 22:18:07
*/

-- 방법1. (일단위 계산)
SELECT SYSDATE "현재시간"
     , SYSDATE + 1 + (2/24) + (3/(24*60)) + (4/(24*60*60)) "연산 후 시간"
FROM DUAL;
--==>>
/*
2021-09-02 11:04:11	
2021-09-03 13:07:15
*/

-- 방법2. (초단위 계산)
SELECT SYSDATE "현재시간"
     , SYSDATE + ((24*60*60) + (2*60*60 ) + (3*60) + 4) / (24*60*60) "연산 후 시간"
     --              1일         2시간        3분    4초     
FROM DUAL;
--==>>
/*
2021-09-02 11:07:13	
2021-09-03 13:10:17
*/
--> 방법1,2 둘다 할 줄 알아야함!

--방법 1 일단위 계산 연습
SELECT SYSDATE "현재시간"
     , SYSDATE +1 + 2/24 + (3/(24*60)) + (4/(24*60*60)) "1일 2시간 3분 4초 후"
FROM DUAL;
--==>>
/*
2021-09-04 20:22:33	
2021-09-05 22:25:37
*/

--방법2 초단위 계산연습
SELECT SYSDATE
     , SYSDATE + ((24*60*60) + (2*60*60) + (3*60) + 4) / (24*60*60)
FROM DUAL; 
--==>>
/*
2021-09-04 20:27:38	
2021-09-05 22:30:42
*/
-->시간 2*60*60   (2*24*60 아님!!!)

--○ 날짜 - 날짜 = 일수 
-- ex) (2021-12-28) - (2021-09-02)
--         수료일          현재일
SELECT TO_DATE('2021-12-28','YYYY-MM-DD') - TO_DATE('2021-09-02','YYYY-MM-DD') "RESULT"
FROM DUAL;
--==>> 117

SELECT SYSDATE
     , TRUNC(TO_DATE('2021-12-28','YYYY-MM-DD') - SYSDATE) "RESULT"
FROM DUAL;
--==>> 
/*
2021-09-04 20:33:06	
114
*/


--○ 데이터 타입의 변환
SELECT TO_DATE('2021-09-02','YYYY-MM-DD') "결과"      -- 날짜 형식으로 변환
FROM DUAL;
--==>> 2021-09-02 00:00:00

SELECT TO_DATE('2021-13-02','YYYY-MM-DD') "결과"
FROM DUAL;
--==>> 에러 발생
/*
ORA-01843: not a valid month
01843. 00000 -  "not a valid month"
*Cause:    
*Action:
*/

SELECT TO_DATE('2021-09-31','YYYY-MM-DD') "결과"
FROM DUAL;
--==>> 에러 발생
/*
ORA-01839: date not valid for month specified
01839. 00000 -  "date not valid for month specified"
*Cause:    
*Action:
*/
SELECT TO_DATE('2021-02-29','YYYY-MM-DD') "결과"
FROM DUAL;
--==>> 에러 발생
/*
ORA-01839: date not valid for month specified
01839. 00000 -  "date not valid for month specified"
*Cause:    
*Action:
*/
SELECT TO_DATE('2020-02-29','YYYY-MM-DD') "결과"
FROM DUAL;
--==>> 2020-02-29 00:00:00

SELECT TO_DATE('1994-12-32','YYYY-MM-DD') "결과"
FROM DUAL;
--==>> 에러 발생
/*
ORA-01847: day of month must be between 1 and last day of month
01847. 00000 -  "day of month must be between 1 and last day of month"
*Cause:    
*Action:
*/

--※ TO_DATE() 함수를 통해 문자 타입을 날짜 타입으로 변환을 진행할 때
--   내부적으로 해당 날짜에 대한 유효성 검사가 이루어진다~!!!


--○ ADD MONTHS() 개월 수를 더해주는 함수
SELECT SYSDATE "1"
     , ADD_MONTHS(SYSDATE,2) "2"
     , ADD_MONTHS(SYSDATE,3) "3"
     , ADD_MONTHS(SYSDATE,-2) "4"
     , ADD_MONTHS(SYSDATE,-3) "5"
FROM DUAL;
--==>>
/*
2021-09-02 11:18:44	 → 현재
2021-11-02 11:18:44	 → 2개월 후
2021-12-02 11:18:44	 → 3개월 후
2021-07-02 11:18:44	 → 2개월 전
2021-06-02 11:18:44	 → 3개월 전
*/
--> 월을 더하고 빼기


--○ 날짜에 대한 세션 설정 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.


--○ MONTHS_BETWEEN()
--   첫 번째 인자값에서 두 번째 인자값을 뺀 개월 수를 반환
SELECT MONTHS_BETWEEN(SYSDATE, TO_DATE('2002-05-31','YYYY-MM-DD')) "결과확인"
FROM DUAL;
--==>> 231.079820788530465949820788530465949821
-- 시간이 흐르고 있으니까 조회할때마다 소수점 값이 바뀜

--> 개월 수의 차이를 반환하는 함수
--※ 결과값의 부호가 『-』로 반환되었을 경우에는
--   첫 번째 인자값에 해당하는 날짜보다
--   두 번째 인자값에 해당하는 날짜가 『미래』라는 의미로 확인 할 수 있다.
SELECT MONTHS_BETWEEN(SYSDATE, TO_DATE('2021-12-28','YYYY-MM-DD')) "결과확인"
FROM DUAL;
--==>> -3.82334528076463560334528076463560334528
--> 수료일이 현재일보다 미래

--○ NEXT_DAY()
--   첫 번째 인자값을 기준으로 날짜로 돌아오는 가장 빠른 요일 반환
SELECT NEXT_DAY(SYSDATE, '토') "결과1", NEXT_DAY(SYSDATE,'월') "결과2"
FROM DUAL;
--==>> 2021-09-04	2021-09-06


-- 추가++ 실무에서 NEXT_DAY로 했는데 에러난다!? 세션이 영어로 되어있을 가능성 높음!
--○ 추가 세션 설정 변경
ALTER SESSION SET NLS_DATE_LANGUAGE = 'ENGLISH';
--==>> Session이(가) 변경되었습니다.

--○ 세션 설정을 변경한 후 위의 쿼리문을 다시 한 번 조회
SELECT NEXT_DAY(SYSDATE, '토') "결과1", NEXT_DAY(SYSDATE,'월') "결과2"
FROM DUAL;
--==>> 에러발생
/*
ORA-01846: not a valid day of the week
01846. 00000 -  "not a valid day of the week"
*Cause:    
*Action:
*/

SELECT NEXT_DAY(SYSDATE, 'SAT') "결과1", NEXT_DAY(SYSDATE,'MON') "결과2"
FROM DUAL;
--==>> 2021-09-04	2021-09-06

--○ 추가 세션 설정 다시 변경
ALTER SESSION SET NLS_DATE_LANGUAGE = 'KOREAN';
--==>> Session이(가) 변경되었습니다.

--○ LAST_DAY()
-- 해당 날짜가 포함되어 있는 그 달의 마지막 날을 반환한다.
SELECT LAST_DAY(SYSDATE) "결과확인"
FROM DUAL;
--==>> 2021-09-30

SELECT LAST_DAY(TO_DATE('2020-02-05','YYYY-MM-DD')) "결과 확인"
FROM DUAL;
--==>> 2020-02-29

SELECT LAST_DAY(TO_DATE('2021-02-05','YYYY-MM-DD')) "결과 확인"
FROM DUAL;
--==>> 2021-02-28

SELECT LAST_DAY(SYSDATE + 45) "결과확인"
FROM DUAL;
--==>> 2021-10-31


--○ 오늘부로... 이중호 님... 군대에 또 끌려(?)간다.
--   복무 기가은 22개월로 한다.

--  1. 전역 일자를 구한다.
--  2. 하루 꼬박꼬박 3끼 식사를 해야한다고 가정한다면
--     중호가 몇 끼를 먹어야 집에 보내줄까.

SELECT SYSDATE "현재 날짜"
     , ADD_MONTHS(SYSDATE,22) "22개월 후 전역일"
     , (ADD_MONTHS(SYSDATE,22) - SYSDATE)* 3 "TO_DATE 안사용"
     , 3 * ( TO_DATE(ADD_MONTHS(SYSDATE,22),'YYYY-MM-DD') - TO_DATE(SYSDATE,'YYYY-MM-DD') ) "몇 끼?" 
FROM DUAL;
--==>> 2021-09-02	2023-07-02	2004	2004
/*
현재 날짜   22개월 후 전역일  TO_DATE 안사용  몇 끼?
---------- ------------------ --------------  ------
2021-09-02 2023-07-02                  2004    2004
*/


--○ 현재 날짜 및 시각으로부터... 수료일(2021-12-28 18:00:00) 까지
--   남은 기간을... 다음과 같은 형태로 조회할 수 있도록 한다.
/*
--------------------------------------------------------------------------------
현재시간               | 수료일               | 일  | 시간 | 분 |  초
--------------------------------------------------------------------------------
2021-09-02 12:08:23    | 2021-12-28 18:00:00 | 116 | 15   |  2 |  37  
--------------------------------------------------------------------------------
*/

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
--==>> Session이(가) 변경되었습니다.

-- 내가 푼 풀이1
SELECT SYSDATE "현재시간"
     , TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') "수료일"
     , TRUNC(TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE) "일" 
     , TRUNC(MOD((TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE) *24,24)) "시간"
     , TRUNC(MOD(((TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE) *24*60),60)) "분"
     , TRUNC(MOD((TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE) * (24*60*60),60)) "초"
FROM DUAL;
--==>> 2021-09-02 14:57:55	2021-12-28 18:00:00	117	3	2	4

SELECT 114*24
,MOD(2736,24)
FROM DUAL;

-- 내가 푼 풀이2

-- 시간 구하자
SELECT TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE
FROM DUAL;
--==>> 117.133344907407407407407407407407407407
SELECT TRUNC(TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE)
FROM DUAL;
--==>> 117
SELECT TRUNC((TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE
     - TRUNC(TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE)) *24) "시간"
FROM DUAL;
--==>> 3

-- 분 구하자
SELECT (TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE
     - TRUNC(TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE)) *24 * 60
FROM DUAL;



SELECT SYSDATE "현재시간"
     , TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') "수료일"
     , TRUNC(TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE) "일"
     , TRUNC((TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE
     - TRUNC(TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE))*24) "시간"
FROM DUAL;



-- 함께 푼 풀이
-- 『1일 2시간 3분 4초』를 『초』로 환산하면...
SELECT (1일) + (2시간) + (3분) + (4초)
FROM DUAL;

SELECT (1*24*60*60) + (2*60*60) + (3*60) + (4)
FROM DUAL;
--==>> 93784

-- 61초 → 1분 1초
-- 초구하기 나눠서 떨어지는애들은 올라가고 아닌애들이 초!
SELECT MOD(61,60)
FROM DUAL;
--==>> 1

-- 『93784』초를 다시 일, 시간, 분, 초로 환산하면...
SELECT TRUNC(TRUNC(TRUNC(93784/60)/60)/24)
     , MOD(TRUNC(TRUNC(93784/60)/60),24)
     , MOD(TRUNC(93784/60),60)
     , MOD(93784,60)
FROM DUAL;
--==>> 1	2	3	4

--==>> 3분      3초
--==>> 1563분	4초

-- 584267초 환산 테스트 → 일, 시간, 분, 초 로 환산하시오.
SELECT TRUNC(TRUNC(TRUNC(584267/60)/60)/24) "일"
     , MOD(TRUNC(TRUNC(584267/60)/60),24)"시간"
     , MOD(TRUNC(584267/60),60)"분"
     , MOD(584267,60)"초"
FROM DUAL;
--==>> 6	18	17	47

-- 수료일까지 남은 기간 확인(날짜 기준) → 단위 : 일수
SELECT 수료일자 - 현재일자 "남은기간"
FROM DUAL;

-- 수료일자
SELECT TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS')
FROM DUAL;
--==>> 2021-12-28 18:00:00 → 날짜 형식

-- 현재일자
SELECT SYSDATE
FROM DUAL;
--==>> 2021-09-02 15:19:45 → 날짜 형식

SELECT TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE "남은기간"
FROM DUAL;
--==>> 117.110277777777777777777777777777777778 → 단위 : 일수 → 숫자 형식
--> 수료일까지 남은 일수

-- 수료일까지 남은 기간 확인(날짜 기준) → 단위 : 초
SELECT TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE * (하루를 구성하는 전체 초)
FROM DUAL;


SELECT ((TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE) * (24*60*60))
FROM DUAL;
--==>> 10118160.99999999999999999999999999999996    → 단위 : 초→ 숫자 형식
--> 수료일까지 남은 초

-- 93784 대신 ((TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE) * (24*60*60))이거 붙여넣기
SELECT TRUNC(TRUNC(TRUNC(93784/60)/60)/24)
     , MOD(TRUNC(TRUNC(93784/60)/60),24)
     , MOD(TRUNC(93784/60),60)
     , MOD(93784,60)
FROM DUAL;

SELECT TRUNC(TRUNC(TRUNC(((TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE) * (24*60*60))/60)/60)/24) "일"
     , MOD(TRUNC(TRUNC(((TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE) * (24*60*60))/60)/60),24) "시간"
     , MOD(TRUNC(((TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE) * (24*60*60))/60),60) "분"
     , TRUNC(MOD(((TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE) * (24*60*60)),60)) "초"
FROM DUAL;

-- 완성
SELECT SYSDATE "현재시각"
     , TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') "수료일자"
     , TRUNC(TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE) "남은기간"
     , TRUNC(TRUNC(TRUNC(((TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE) * (24*60*60))/60)/60)/24) "일"
     , MOD(TRUNC(TRUNC(((TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE) * (24*60*60))/60)/60),24) "시간"
     , MOD(TRUNC(((TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE) * (24*60*60))/60),60) "분"
     , TRUNC(MOD(((TO_DATE('2021-12-28 18:00:00','YYYY-MM-DD HH24:MI:SS') - SYSDATE) * (24*60*60)),60)) "초"
FROM DUAL;
--==>>
/*
현재시각                수료일자         남은기간          일      시간          분          초
------------------- ------------------- ---------- ---------- ---------- ---------- ----------
2021-09-02 15:32:28 2021-12-28 18:00:00        117        117          2         27         32
*/

--○ 문제
-- 본인이 태어나서 현재까지...
-- 얼마만큼의 일, 시간, 분, 초를 살았는지...(살고있는지...)
-- 조회하는 쿼리문을 구성한다.
/*
-------------------------------------------------------------------
현재 시각           | 태어난 시각         |  일  |  시간 | 분 | 초
-------------------------------------------------------------------
2021-09-02 15:33:20 | 1994-12-31 14:08:00 | XXXX|      XX| XX | XX
-------------------------------------------------------------------
*/
-- 태어난 날부터 얼마나 살았는지 확인(날짜 기준) → 단위 : 초
SELECT ((SYSDATE - TO_DATE('1994-12-31 14:08:00','YYYY-MM-DD HH24:MI:SS')) * (24*60*60))
FROM DUAL;

SELECT TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE('1994-12-31 14:08:00','YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) "일"
     , MOD(TRUNC(TRUNC(((SYSDATE - TO_DATE('1994-12-31 14:08:00','YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60),24) "시"
     , MOD(TRUNC(((SYSDATE - TO_DATE('1994-12-31 14:08:00','YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60),60) "분"
     , MOD(((SYSDATE - TO_DATE('1994-12-31 14:08:00','YYYY-MM-DD HH24:MI:SS')) * (24*60*60)),60) "초"
FROM DUAL;

SELECT SYSDATE "현재 시각"
     , TO_DATE('1994-12-31 14:08:00','YYYY-MM-DD HH24:MI:SS') "태어난 시각"
     , TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE('1994-12-31 14:08:00','YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) "일"
     , MOD(TRUNC(TRUNC(((SYSDATE - TO_DATE('1994-12-31 14:08:00','YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60),24) "시"
     , MOD(TRUNC(((SYSDATE - TO_DATE('1994-12-31 14:08:00','YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60),60) "분"
     , MOD(((SYSDATE - TO_DATE('1994-12-31 14:08:00','YYYY-MM-DD HH24:MI:SS')) * (24*60*60)),60) "초"
FROM DUAL;
--==>>
/*
현재 시각               태어난 시각           일          시          분          초
------------------- ------------------- ---------- ---------- ---------- ----------
2021-09-02 15:40:56 1994-12-31 14:03:00       9742          1         37         56
*/

/*
현재 시각               태어난 시각             일        시          분          초
------------------- ------------------- ---------- ---------- ---------- ----------
2021-09-05 02:07:53 1994-12-31 14:08:00       9744         11         59         53
*/



ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

--※ 날짜 데이터를 대상으로 반올림, 절삭을 수행할 수 있다.

--○ 날짜 반올림
SELECT SYSDATE "1"                  -- 2021-09-02  → 기본 현재 날짜
     , ROUND(SYSDATE, 'YEAR') "2"   -- 2022-01-01  → 년도까지 유효한 데이터(상반기, 하반기 기분) 지금 하반기니까 올림!
     , ROUND(SYSDATE, 'MONTH') "3"  -- 2021-09-01  → 월까지 유효한 데이터(15일 기준)    2일이니까 내림!
     , ROUND(SYSDATE, 'DD') "4"     -- 2021-09-03  → 날짜까지 유효한 데이터(정오 기준) 12이후니까 3으로 올림!
     , ROUND(SYSDATE, 'DAY') "5"    -- 2021-09-05  → 날짜까지 유효한 데이터(수요일 기준) 목요일이니까 다음 일요일 수요일이전이면 이전 일요일
FROM DUAL;

--○ 날짜 절삭(올림이 절대로 발생하지 않음!)
SELECT SYSDATE "1"                  -- 2021-09-02  → 기본 현재 날짜
     , TRUNC(SYSDATE, 'YEAR') "2"   -- 2021-01-01  → 년도까지 유효한 데이터 뒤는 다 털어내서 절삭
     , TRUNC(SYSDATE, 'MONTH') "3"  -- 2021-09-01  → 월까지 유효한 데이터 뒤는 다 털어내서 절삭
     , TRUNC(SYSDATE, 'DD') "4"     -- 2021-09-02  → 날짜까지 유효한 데이터
     , TRUNC(SYSDATE, 'DAY') "5"    -- 2021-08-29  → 날짜까지 유효한 데이터(절삭이니까 무조건 그전 주 일요일)
FROM DUAL;

--------------------------------------------------------------------------------

-- ■■■ 변환 함수 ■■■--

-- TO_CHAR()    : 숫자나 날짜 데이터를 문자 타입으로 변환시켜주는 함수 
-- TO_DATE()    : 문자데이터(날짜 형식)를 날짜 타입으로 변환시켜주는 함수
-- TO_NUMBER    : 문자데이터(숫자 형식)를 숫자 타입으로 변환시켜주는 함수

--※ 날짜나 통화 형식이 맞지 않을 경우
--   세션 설정값을 통해 설정을 변경할 수 있다.

ALTER SESSION SET NLS_DATE_LANGUAGE = 'KOREAN';
--==>> Session이(가) 변경되었습니다.

ALTER SESSION SET NLS_LANGUAGE = 'KOREAN';
--==>> Session이(가) 변경되었습니다.

-- CURRENCY : 통화, 화폐
ALTER SESSION SET NLS_CURRENCY = '\';   --원(￦)
--==>> Session이(가) 변경되었습니다.

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

-- 날짜를 문자로 바꾸는 중
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD')    -- 2021-09-02           날짜처럼 보여지지만 얘는 문자 타입
     , TO_CHAR(SYSDATE,'YYYY')          -- 2021                 숫자가 아니라 이공이일
     , TO_CHAR(SYSDATE,'YEAR')          -- TWENTY TWENTY-ONE	
     , TO_CHAR(SYSDATE,'MONTH')         -- 09	                
     , TO_CHAR(SYSDATE,'MM')            -- 9월 	                
     , TO_CHAR(SYSDATE,'MON')           -- 9월 	                
     , TO_CHAR(SYSDATE,'DD')            -- 02	                DD는  날짜         
     , TO_CHAR(SYSDATE,'DAY')           -- 목요일	            DAY는 요일   
     , TO_CHAR(SYSDATE,'DY')            -- 목	                
     , TO_CHAR(SYSDATE,'HH24')          -- 16	                    
     , TO_CHAR(SYSDATE,'HH')            -- 04	                
     , TO_CHAR(SYSDATE,'HH AM')         -- 04 오후	            AM을 쓰든 PM 을 쓰든 오후로 나옴    
     , TO_CHAR(SYSDATE,'HH PM')         -- 04 오후	                
     , TO_CHAR(SYSDATE,'MI')            -- 23	                    
     , TO_CHAR(SYSDATE,'SS')            -- 12	                        
     , TO_CHAR(SYSDATE,'SSSSS')         -- 58992	            → 금일 흘러온 전체 초(지금 시간을 초로)            
     , TO_CHAR(SYSDATE,'Q')             -- 3                    → 분기(쿼터)  123 / 456 / 789 / 101112                        
     
FROM DUAL;
--> 전부 좌측 정렬 → 문자라는 뜻!


--숫자는 우측정렬 문자는 좌측정렬
SELECT 2021 "1", '2021' "2"
FROM DUAL;
/* 
        1  2   
---------- ----
      2021 2021
*/

SELECT TO_DATE('2021-08-03','YYYY-MM-DD') "날짜"
FROM DUAL;
--==>> 
/*
날짜        
--------------------
2021-08-03
*/

SELECT '23' "1", TO_NUMBER('23') "2"
FROM DUAL;
/*
1              2
----- ----------
23            23
*/

--○ EXTRACT()
-- SYSDATE자리에는 날짜타입이기만 하면됨!
SELECT TO_CHAR(SYSDATE,'YYYY') "1"      --2021      → 연도를 추출하여 문자 타입으로...
     , TO_CHAR(SYSDATE, 'MM') "2"       --09        → 월을 추출하여 문자 타입으로... 
     , TO_CHAR(SYSDATE, 'D') "3"        --5         → 일을 추출하여 문자 타입으로...
     , EXTRACT(YEAR FROM SYSDATE) "4"   --2021      → 연도를 추출하여 숫자 타입으로...
     , EXTRACT(MONTH FROM SYSDATE) "5"  --9	        → 월을 추출하여 숫자 타입으로...
     , EXTRACT(DAY FROM SYSDATE) "6"    --2         → 일을 추출하여 숫자 타입으로...
FROM DUAL;
--> 연, 월, 일 이하 다른 것은 불가(시, 분, 초)

--○ TO_CHAR() 활용 → 형식 맟춤 표기 결과값 반환
SELECT 60000 "1"
     , TO_CHAR(60000) "2"
     , TO_CHAR(60000,'99,999') "3"
     , TO_CHAR(60000,'$99,999') "4"
     , TO_CHAR(60000, 'L99,999') "5"
     , LTRIM(TO_CHAR(60000, 'L99,999')) "6"
FROM DUAL;
/*
--숫자는 우측정렬 문자는 좌측정렬
        1 2     3       4        5                
---------- ----- ------- -------- ------------------------
     60000 60000  60,000  $60,000           \60,000         ← ￦(여러가지 통화기호 때문에 공백생겨서 LTRIM()과 함께 쓰인다!
*/

--○ 날짜 세션 설정 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
--==>> Session이(가) 변경되었습니다.



--○ 현재 시간을 기준으로 1일 2시간 3분 4초후를 조회한다.

SELECT SYSDATE "현재 시간"
     , SYSDATE + 1 + (2/24) + (3/(24*60)) + (4/(24*60*60)) "1일2시간3분4초 후"
FROM DUAL;
--==>>
/*
2021-09-02 17:02:27
2021-09-03 19:05:31
*/

--○ 현재 시간을 기준으로 1년 2개월 3일 4시간 5분 6초 후를 조회한다.
--   TO_YMINTERVAL(), TO_DSINTERVAL()
--      년월            데이 초
SELECT SYSDATE "현재 시간"
     , SYSDATE + TO_YMINTERVAL('01-02') + TO_DSINTERVAL('003 04:05:06') "연산결과"
FROM DUAL;
--==>> '문자열'의 형태로 넘겨줘야하고 - YM은 있고 DS는 없음!
/*
2021-09-02 17:05:44	
2022-11-05 21:10:50
*/

SELECT SYSDATE,SYSDATE + TO_YMINTERVAL('2-2'), SYSDATE + TO_DSINTERVAL('3 4:5:6')
FROM DUAL;

-------------------------------------------------------------------------------

--○ CASE 구문(조건문, 분기문)
/*
CASE
WHEN
THEN
ELSE
END
케이스 왠 댄 엘스 엔드 구문으로 암기!
*/
SELECT CASE 5+2 WHEN 7 THEN '5+2=7' ELSE '5+2는 몰라요' END "결과확인"
FROM DUAL;
--==>> 5+2=7

SELECT CASE 5+2 WHEN 9 THEN '5+2=7' ELSE '5+2는 몰라요' END "결과확인"
FROM DUAL;
--==>> 5+2는 몰라요


SELECT CASE 1+1 WHEN 2 THEN '1+1=2'
                WHEN 3 THEN '1+1=3'
                WHEN 4 THEN '1+1=3'
                ELSE '몰라요'
                END "결과 확인"
FROM DUAL;
--==>> 1+1=2


--○ DECODE()
-- DECODE(컬럼, 조건1, 결과1, 조건2, 결과2, 조건3, 결과3..........) 
SELECT DECODE(5-2,1,'5-2=1',2, '5-2=2',3,'5-2=3','5-2는 몰라요')"결과 확인"
FROM DUAL;
--==>> 5-2=3

SELECT CASE WHEN 5<2 THEN '5<2'
            WHEN 5>2 THEN '5>2'
            ELSE '비교불가'
            END "결과 확인"
FROM DUAL;
--==>> 5>2

SELECT CASE WHEN 5<2 OR 3>1 THEN '범석만세'
            WHEN 5>2 OR 2=3 THEN '지윤만세'
            ELSE '현정만세'
            END "결과 확인"
FROM DUAL;
--==>> 범석만세
/*
SELECT CASE WHEN F OR T THEN '범석만세'
            WHEN 5>2 OR 2=3 THEN '지윤만세'
            ELSE '현정만세'
            END "결과 확인"
FROM DUAL;

IF, ELSE IF 처럼... 첫번째 WHEN이 TRUE 면 ... 두 번째 WHEN 은 실행되지 않는다!
결과가 나오면 뒤에는 연산함!
*/

SELECT CASE WHEN 3<1 AND 5<2 OR 3>1 AND 2=2 THEN '해덕만세'
           WHEN 5<2 AND 2=3 THEN '지영만세'
           ELSE '진하만세' 
           END "결과 확인"
FROM DUAL;
--==>> 해덕만세
/*
                F        F      T       T
SELCT CASE WHEN 3<1 AND 5<2 OR 3>1 AND 2=2 THEN '해덕만세'      --TRUE
           WHEN 5<2 AND 2=3 THEN '지영만세'
           ELSE '진하만세' 
           END "결과 확인"
FROM DUAL;
*/


SELECT CASE WHEN 3<1 AND (5<2 OR 3>1) AND 2=2 THEN '해덕만세'
           WHEN 5<2 AND 2=3 THEN '지영만세'
           ELSE '진하만세' 
           END "결과 확인"
FROM DUAL;
--==>> 진하만세
/*
                                F
                        F                T                        
                             T
                 F         F     T
SELECT CASE WHEN 3<1 AND (5<2 OR 3>1) AND 2=2 THEN '해덕만세'
           WHEN 5<2 AND 2=3 THEN '지영만세'
           ELSE '진하만세' 
           END "결과 확인"
FROM DUAL;
*/
--> 괄호에 영향 있음!
--구문상 주의 !! ELSE다음에는 THEN 이 안붙음!!!

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

SELECT *
FROM TBL_SAWON;

DESC TBL_SAWON;

--○ 문제
--   TBL_SAWON 테이블을 활용하여 다음과 같은 항목들을 조회한다.
--   사원번호, 사원명, 주민번호, 성별, 현재나이, 입사일
--  , 정년퇴직일, 근무일수, 남은일수, 급여, 보너스

--  단, 현재나이는 한국나이 계산법에 따라 연산을 수행한다.
--  또한, 정년퇴직일은 해당 직원의 나이가 한국나이로 60세가 되는 해(연도)의
--  그 직원의 입사 월, 일로 연산을 수행한다.
--  그리고, 보너스는 1000일 이상 2000일 미만 근무한 사원은
--  그 사원의 원래 급여 기준 30% 지급,
--  2000일 이상 근무한 사원은
--  그 사원의 원래 급여 기준 50% 지급을 할 수 있도록 처리한다.

--내가 푼 풀이
SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
     , CASE SUBSTR(JUBUN,7,1) WHEN '2' THEN '여'
                              WHEN '4' THEN '여'
            ELSE '남' 
            END "성별"
     , EXTRACT(YEAR FROM SYSDATE) - (DECODE(SUBSTR(JUBUN,7,1),'1','19','2','19','20') || SUBSTR(JUBUN,1,2)) + 1 "현재나이"
     , HIREDATE "입사일"
     , ADD_MONTHS(SYSDATE,(60 - (EXTRACT(YEAR FROM SYSDATE) - (DECODE(SUBSTR(JUBUN,7,1),'1','19','2','19','20') || SUBSTR(JUBUN,1,2)) + 1))*12) "정년퇴직일"
     , TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) "근무일수"
     , ADD_MONTHS(SYSDATE,(60 - (EXTRACT(YEAR FROM SYSDATE) - (DECODE(SUBSTR(JUBUN,7,1),'1','19','2','19','20') || SUBSTR(JUBUN,1,2)) + 1))*12) - SYSDATE "남은일수"
     ,SAL "급여"
     , CASE WHEN TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) >=2000 THEN SAL * 0.5 
              WHEN TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) >=1000 THEN SAL * 0.3 
              WHEN TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) <2000 THEN SAL * 0.3 
              ELSE SAL * 0
              END "보너스"
FROM TBL_SAWON;
--??정년퇴직일에서 월 일을 처리 못함


--성별
SELECT CASE SUBSTR(JUBUN,7,1) WHEN '2' THEN '여'
                              WHEN '4' THEN '여'
            ELSE '남' 
            END "성별"
FROM TBL_SAWON;

--나이
SELECT TO_CHAR(JUBUN,'YY-MM-DD')
FROM TBL_SAWON;

-- 흠....아닌거같고..
SELECT (TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE('1994-12-31','YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24))/365 + 1 "일"
FROM DUAL;

--==>> 27.69315068493150684931506849315068493151

--흠.....모르겟..
SELECT TO_DATE(SUBSTR(JUBUN,1,6),'YYMMDD')
FROM TBL_SAWON;
--==>> 2093-07-30


SELECT EXTRACT(YEAR FROM SYSDATE)
FROM TBL_SAWON;
--==>> 2021

SELECT DECODE(SUBSTR(JUBUN,7,1),'1','19','2','19','20') || SUBSTR(JUBUN,1,2)
FROM TBL_SAWON;
--==>>
/*
1993
1995
2009
1994
2004
2002
1980
1981
1972
1970
1990
1980
1982
1992
2002
*/

-- 나이 구하기 완성
SELECT EXTRACT(YEAR FROM SYSDATE) - (DECODE(SUBSTR(JUBUN,7,1),'1','19','2','19','20') || SUBSTR(JUBUN,1,2)) + 1
FROM TBL_SAWON;
/*
29
27
13
28
18
20
42
41
50
52
32
42
40
30
20
*/
--○ DECODE()
-- DECODE(컬럼, 조건1, 결과1, 조건2, 결과2, 조건3, 결과3..........) 
SELECT DECODE(5-2,1,'5-2=1',2, '5-2=2',3,'5-2=3','5-2는 몰라요')"결과 확인"
FROM DUAL;
--==>> 5-2=3

--○ EXTRACT()
-- SYSDATE자리에는 날짜타입이기만 하면됨!
SELECT TO_CHAR(SYSDATE,'YYYY') "1"      --2021      → 연도를 추출하여 문자 타입으로...
     , TO_CHAR(SYSDATE, 'MM') "2"       --09        → 월을 추출하여 문자 타입으로... 
     , TO_CHAR(SYSDATE, 'D') "3"        --5         → 일을 추출하여 문자 타입으로...
     , EXTRACT(YEAR FROM SYSDATE) "4"   --2021      → 연도를 추출하여 숫자 타입으로...
     , EXTRACT(MONTH FROM SYSDATE) "5"  --9	        → 월을 추출하여 숫자 타입으로...
     , EXTRACT(DAY FROM SYSDATE) "6"    --2         → 일을 추출하여 숫자 타입으로...
FROM DUAL;
--> 연, 월, 일 이하 다른 것은 불가(시, 분, 초)

-- 근무일수 완성
SELECT TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) "근무일수"
FROM TBL_SAWON;

--정년퇴직일 구하자
--  또한, 정년퇴직일은 해당 직원의 나이가 한국나이로 60세가 되는 해(연도)의
--  그 직원의 입사 월, 일로 연산을 수행한다.
SELECT 60 - 직원의 나이
FROM TBL_SAWON;

SELECT 60-(EXTRACT(YEAR FROM SYSDATE) - (DECODE(SUBSTR(JUBUN,7,1),'1','19','2','19','20') || SUBSTR(JUBUN,1,2)) + 1)
FROM TBL_SAWON;

--정년퇴직일 완성
SELECT ADD_MONTHS(SYSDATE,(60 - (EXTRACT(YEAR FROM SYSDATE) - (DECODE(SUBSTR(JUBUN,7,1),'1','19','2','19','20') || SUBSTR(JUBUN,1,2)) + 1))*12)
FROM TBL_SAWON;

--퇴직까지 남은 일수 완성
SELECT ADD_MONTHS(SYSDATE,(60 - (EXTRACT(YEAR FROM SYSDATE) - (DECODE(SUBSTR(JUBUN,7,1),'1','19','2','19','20') || SUBSTR(JUBUN,1,2)) + 1))*12) - SYSDATE
FROM TBL_SAWON;

--  그리고, 보너스는 1000일 이상 2000일 미만 근무한 사원은
--  그 사원의 원래 급여 기준 30% 지급,
--  2000일 이상 근무한 사원은
--  그 사원의 원래 급여 기준 50% 지급을 할 수 있도록 처리한다.

-- 보너스 완성
SELECT TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) "근무일수"
       , SAL
       , CASE WHEN TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) >=2000 THEN SAL * 0.5 
              WHEN TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) >=1000 THEN SAL * 0.3 
              WHEN TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) <2000 THEN SAL * 0.3 
              ELSE SAL * 0
              END "보너스"
FROM TBL_SAWON;

--왜안대징..?
SELECT DECODE(TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24)
            ,(TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24 )>= 1000 AND TRUNC(TRUNC(TRUNC(((SYSDATE - TO_DATE(HIREDATE,'YYYY-MM-DD HH24:MI:SS')) * (24*60*60))/60)/60)/24) < 2000)
            ,SAL*0.3,SAL*0.5)
FROM TBL_SAWON;
