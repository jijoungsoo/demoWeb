@echo off


@rem  서버실행하기  http://www.nextree.co.kr/p5584/ 
@rem java ch.qos.logback.classic.net.SimpleSocketServer {port} {로그설정 xml 파일 경로}
@rem  클래스패스 지정하기 https://jaesu.tistory.com/entry/java-command-%EC%B0%BD%EC%97%90%EC%84%9C-classpath%EC%B6%94%EA%B0%80-%EC%8B%A4%ED%96%89%ED%95%98%EA%B8%B0
@rem java -cp:logback-classic.jar;logback-core.jar;slf4j-api.jar ch.qos.logback.classic.net.SimpleSocketServer 8092 C:\Users\jijsx\git\demoWeb\demoWeb\src\main\resources\remote-logback.xml


@rem 
set LOG_CP_PATH=C:\Users\jijsx\.gradle\caches\modules-2\files-2.1\ch.qos.logback\logback-classic\1.2.3\7c4f3c474fb2c041d8028740440937705ebb473a\logback-classic-1.2.3.jar
set LOG_CP_PATH=%LOG_CP_PATH%;C:\Users\jijsx\.gradle\caches\modules-2\files-2.1\ch.qos.logback\logback-core\1.2.3\864344400c3d4d92dfeb0a305dc87d953677c03c\logback-core-1.2.3.jar
set LOG_CP_PATH=%LOG_CP_PATH%;C:\Users\jijsx\.gradle\caches\modules-2\files-2.1\org.slf4j\slf4j-api\1.7.30\b5a4b6d16ab13e34a88fae84c35cd5d68cac922c\slf4j-api-1.7.30.jar
echo %LOG_CP_PATH%   

set ENV_XML_PATH=C:\Users\jijsx\git\demoWeb\demoWeb\src\main\resources\remote-logback.xml
java -cp %LOG_CP_PATH% ch.qos.logback.classic.net.SimpleSocketServer 8092 %ENV_XML_PATH%
