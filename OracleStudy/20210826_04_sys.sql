--○ 접속된 사용자 조회
SELECT USER
FROM DUAL;
--==>> SYS

--○ 오라클 사용자 계정 생성(SCOTT)
CREATE USER scott
IDENTIFIED BY tiger;        --패스워드는 대소문자 구분!!
--==>> User SCOTT이(가) 생성되었습니다.


--○ 생성된 오라클 사용자 계정(SCOTT)에 권한 부여
GRANT CONNECT,RESOURCE,UNLIMITED TABLESPACE TO SCOTT;
--==>> Grant을(를) 성공했습니다.

--○ 생성된 오라클 사용자 계정(SCOTT)에 기본 테이블스페이스 설정
ALTER USER SCOTT DEFAULT TABLESPACE USERS;  --이 테이블 스페이스는 기본적으로 프로그램에 있는 것!
--==>> User SCOTT이(가) 변경되었습니다.

--○ 생성된 오라클 사용자 계정(SCOTT)에 임시 테이블스페이스 설정
ALTER USER SCOTT TEMPORARY TABLESPACE TEMP;
--==>> User SCOTT이(가) 변경되었습니다.









