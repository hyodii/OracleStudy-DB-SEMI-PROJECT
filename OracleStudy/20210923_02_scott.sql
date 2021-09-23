SELECT USER
FROM DUAL;
--==>> SCOTT

--○ 실습 테이블 생성(TBL_TEST2) → 부모 테이블
CREATE TABLE TBL_TEST2
( CODE NUMBER
, NAME VARCHAR2(40)
, CONSTRAINT TEST1_CODE_PK PRIMARY KEY(CODE)
);
--==>> Table TBL_TEST2이(가) 생성되었습니다.


--○ 실습 테이블 생성(TBL_TEST3) → 자식 테이블
CREATE TABLE TBL_TEST3
( SID   NUMBER
, CODE  NUMBER
, SU    NUMBER
, CONSTRAINT TEST3_SID_PK PRIMARY KEY(SID)
, CONSTRAINT TEST3_CODE_FK FOREIGN KEY(CODE)
             REFERENCES TBL_TEST2(CODE)
);
--==>> Table TBL_TEST3이(가) 생성되었습니다.

--○ 데이터 입력
INSERT INTO TBL_TEST2(CODE,NAME) VALUES(1, '냉장고');
INSERT INTO TBL_TEST2(CODE,NAME) VALUES(2, '세탁기');
INSERT INTO TBL_TEST2(CODE,NAME) VALUES(3, '건조기');
--==>> 1 행 이(가) 삽입되었습니다. * 3

SELECT *
FROM TBL_TEST2;
--==>>
/*
1	냉장고
2	세탁기
3	건조기
*/

COMMIT;
--==>> 커밋 완료.


--○ 데이터 입력
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES (1,1,20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES (2,1,20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES (3,2,30);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES (4,3,40);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES (5,2,20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES (6,2,20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES (7,3,20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES (8,3,20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES (9,2,20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES (10,3,20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES (11,2,20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES (12,2,20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES (13,1,20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES (14,2,20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES (15,3,20);
--==>> 1 행 이(가) 삽입되었습니다. * 15

SELECT *
FROM TBL_TEST3;
--==>>
/*
1	1	20
2	1	20
3	2	30
4	3	40
5	2	20
6	2	20
7	3	20
8	3	20
9	2	20
10	3	20
11	2	20
12	2	20
13	1	20
14	2	20
15	3	20
*/

SELECT C.SID, P.CODE, P.NAME, C.SU
FROM TBL_TEST2 P JOIN TBL_TEST3 C
ON P.CODE = C.CODE;
--==>>
/*
1	1	냉장고	20
2	1	냉장고	20
3	2	세탁기	30
4	3	건조기	40
5	2	세탁기	20
6	2	세탁기	20
7	3	건조기	20
8	3	건조기	20
9	2	세탁기	20
10	3	건조기	20
11	2	세탁기	20
12	2	세탁기	20
13	1	냉장고	20
14	2	세탁기	20
15	3	건조기	20
*/

COMMIT;
--==>> 커밋 완료.

-- 부모 테이블(TBL_TEST2)에서 냉장고 삭제
DELETE
FROM TBL_TEST2
WHERE CODE=1;
--==>> 에러 발생(자식 레코드가 존재)
/*
ORA-02292: integrity constraint (SCOTT.TEST3_CODE_FK) violated - child record found
*/

DELETE
FROM TBL_TEST3
WHERE CODE=1;
--==>> 3개 행 이(가) 삭제되었습니다.

SELECT C.SID, P.CODE, P.NAME, C.SU
FROM TBL_TEST2 P JOIN TBL_TEST3 C
ON P.CODE = C.CODE;
--==>>
/*
3	2	세탁기	30
4	3	건조기	40
5	2	세탁기	20
6	2	세탁기	20
7	3	건조기	20
8	3	건조기	20
9	2	세탁기	20
10	3	건조기	20
11	2	세탁기	20
12	2	세탁기	20
14	2	세탁기	20
15	3	건조기	20
*/
--> 냉장고 데이터 존재하지 않음

COMMIT;
--==>> 커밋 완료.


DELETE
FROM TBL_TEST2
WHERE CODE=1;
--==>> 1 행 이(가) 삭제되었습니다.

SELECT *
FROM TBL_TEST2;
--==>>
/*
2	세탁기
3	건조기
*/

COMMIT;
--==>> 커밋 완료.

SELECT *
FROM TBL_TEST2
WHERE CODE=2;
--==>> 2	세탁기

DELETE
FROM TBL_TEST2
WHERE CODE=2;
--==>> 에러 발생
/*
ORA-02292: integrity constraint (SCOTT.TEST3_CODE_FK) violated - child record found
*/

SELECT *
FROM TBL_TEST2
WHERE CODE=3;
--==>> 3	건조기

DELETE
FROM TBL_TEST2
WHERE CODE=3;
--==>> 에러 발생
/*
ORA-02292: integrity constraint (SCOTT.TEST3_CODE_FK) violated - child record found
*/



--○ 트리거 작성 이후 다시 테스트

DELETE
FROM TBL_TEST2
WHERE CODE=3;
--==>> 1 행 이(가) 삭제되었습니다.
--> 자식을 먼저 지우고 지워진 것!

SELECT *
FROM TBL_TEST2;

SELECT *
FROM TBL_TEST3;

DELETE
FROM TBL_TEST2
WHERE CODE=2;
--==>> 1 행 이(가) 삭제되었습니다.

SELECT *
FROM TBL_TEST2;
--==>> 조회 결과 없음

SELECT *
FROM TBL_TEST3;
--==>> 조회 결과 없음





TRUNCATE TABLE TBL_입고;
--==>> Table TBL_입고이(가) 잘렸습니다.

TRUNCATE TABLE TBL_출고;
--==>> Table TBL_출고이(가) 잘렸습니다.

UPDATE TBL_상품
SET 재고수량 = 0;
--==>> 21개 행 이(가) 업데이트되었습니다.

COMMIT;
--==>> 커밋 완료.

SELECT *
FROM TBL_입고;
--==>> 조회 결과 없음

SELECT *
FROM TBL_출고;
--==>> 조회 결과 없음

SELECT *
FROM TBL_상품;
--==>> 모든 재고 0



INSERT INTO TBL_입고(입고번호, 상품코드,입고일자, 입고수량,입고단가)
VALUES(1,'C001',SYSDATE,100,1800);
--==>> 1 행 이(가) 삽입되었습니다.

SELECT *
FROM TBL_입고;
--==>> 1	C001	2021-09-23	100	1800

SELECT *
FROM TBL_상품;
--==>>
/*
S001	고래밥	1000	0
S002	꼬북칩	1200	0
S003	감자깡	1000	0
S004	콰삭칩	1100	0
S005	포카칩	1600	0
S006	치토스	1500	0
S007	홈런볼	2000	0
C001	초코칩	1800	100
C002	다이제	2200	0
C003	버터링	1400	0
C004	에이스	1200	0
C005	치익촉	1900	0
C006	오레오	2100	0
C007	사브레	1300	0
E001	마이쮸	1000	0
E002	멘토스	1100	0
E003	비틀즈	1200	0
E004	엠엔엠	1300	0
E005	꿈틀이	1400	0
E006	하리보	1500	0
E007	아이셔	1600	0
*/

DELETE
FROM TBL_입고
WHERE 상품코드 = 'C001';
--==>> 1 행 이(가) 삭제되었습니다.

SELECT *
FROM TBL_상품;
--==>>
/*
S001	고래밥	1000	0
S002	꼬북칩	1200	0
S003	감자깡	1000	0
S004	콰삭칩	1100	0
S005	포카칩	1600	0
S006	치토스	1500	0
S007	홈런볼	2000	0
C001	초코칩	1800	0
C002	다이제	2200	0
C003	버터링	1400	0
C004	에이스	1200	0
C005	치익촉	1900	0
C006	오레오	2100	0
C007	사브레	1300	0
E001	마이쮸	1000	0
E002	멘토스	1100	0
E003	비틀즈	1200	0
E004	엠엔엠	1300	0
E005	꿈틀이	1400	0
E006	하리보	1500	0
E007	아이셔	1600	0
*/

INSERT INTO TBL_입고(입고번호, 상품코드,입고일자, 입고수량,입고단가)
VALUES(1,'C001',SYSDATE,100,1800);
--==>> 1 행 이(가) 삽입되었습니다.

SELECT *
FROM TBL_입고;
--==>> 1	C001	2021-09-23	100	1800

SELECT *
FROM TBL_상품;

SELECT *
FROM TBL_출고;
--==>> 조회결과 없음

INSERT INTO TBL_출고(출고번호, 상품코드, 출고일자, 출고수량, 출고단가)
VALUES(1,'C001',SYSDATE,20,2000);

SELECT *
FROM TBL_출고;
--==>> 1	C001	2021-09-23	20	2000

SELECT *
FROM TBL_상품;
/*
S001	고래밥	1000	0
S002	꼬북칩	1200	0
S003	감자깡	1000	0
S004	콰삭칩	1100	0
S005	포카칩	1600	0
S006	치토스	1500	0
S007	홈런볼	2000	0
C001	초코칩	1800	80
C002	다이제	2200	0
C003	버터링	1400	0
C004	에이스	1200	0
C005	치익촉	1900	0
C006	오레오	2100	0
C007	사브레	1300	0
E001	마이쮸	1000	0
E002	멘토스	1100	0
E003	비틀즈	1200	0
E004	엠엔엠	1300	0
E005	꿈틀이	1400	0
E006	하리보	1500	0
E007	아이셔	1600	0
*/

DELETE
FROM TBL_출고
WHERE 상품코드 = 'C001';
--==>> 1 행 이(가) 삭제되었습니다.

SELECT *
FROM TBL_상품;
/*
S001	고래밥	1000	0
S002	꼬북칩	1200	0
S003	감자깡	1000	0
S004	콰삭칩	1100	0
S005	포카칩	1600	0
S006	치토스	1500	0
S007	홈런볼	2000	0
C001	초코칩	1800	100
C002	다이제	2200	0
C003	버터링	1400	0
C004	에이스	1200	0
C005	치익촉	1900	0
C006	오레오	2100	0
C007	사브레	1300	0
E001	마이쮸	1000	0
E002	멘토스	1100	0
E003	비틀즈	1200	0
E004	엠엔엠	1300	0
E005	꿈틀이	1400	0
E006	하리보	1500	0
E007	아이셔	1600	0
*/

-----------------------------------------------------------------
-- 패키지 사용하기!

SELECT INSA_PACK.FN_GENDER('751212-1234567') "RESULT"
FROM DUAL;
--==>> 남자

SELECT NAME, SSN, INSA_PACK.FN_GENDER(SSN)"성별확인"
FROM TBL_INSA;
--==>>
/*
이다영	951027-2234567	여자
박혜진	941013-2234567	여자
홍길동	771212-1022432	남자
이순신	801007-1544236	남자
이순애	770922-2312547	여자
김정훈	790304-1788896	남자
한석봉	811112-1566789	남자
이기자	780505-2978541	여자
장인철	780506-1625148	남자
김영년	821011-2362514	여자
나윤균	810810-1552147	남자
김종서	751010-1122233	남자
유관순	801010-2987897	여자
정한국	760909-1333333	남자
조미숙	790102-2777777	여자
황진이	810707-2574812	여자
이현숙	800606-2954687	여자
이상헌	781010-1666678	남자
엄용수	820507-1452365	남자
이성길	801028-1849534	남자
박문수	780710-1985632	남자
유영희	800304-2741258	여자
홍길남	801010-1111111	남자
이영숙	800501-2312456	여자
김인수	731211-1214576	남자
김말자	830225-2633334	여자
우재옥	801103-1654442	남자
김숙남	810907-2015457	여자
김영길	801216-1898752	남자
이남신	810101-1010101	남자
김말숙	800301-2020202	여자
정정해	790210-2101010	여자
지재환	771115-1687988	남자
심심해	810206-2222222	여자
김미나	780505-2999999	여자
이정석	820505-1325468	남자
정영희	831010-2153252	여자
이재영	701126-2852147	여자
최석규	770129-1456987	남자
손인수	791009-2321456	여자
고순정	800504-2000032	여자
박세열	790509-1635214	남자
문길수	721217-1951357	남자
채정희	810709-2000054	여자
양미옥	830504-2471523	여자
지수환	820305-1475286	남자
홍원신	690906-1985214	남자
허경운	760105-1458752	남자
산마루	780505-1234567	남자
이기상	790604-1415141	남자
이미성	830908-2456548	여자
이미인	810403-2828287	여자
권영미	790303-2155554	여자
권옥경	820406-2000456	여자
김싱식	800715-1313131	남자
정상호	810705-1212141	남자
정한나	820506-2425153	여자
전용재	800605-1456987	남자
이미경	780406-2003214	여자
김신제	800709-1321456	남자
임수봉	810809-2121244	여자
김신애	810809-2111111	여자
*/

