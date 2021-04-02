FROM openjdk:11.0.10-jre
VOLUME /tmp
#ARG JAR_FILE=demoWeb/build/libs/*.war
COPY demoWeb/build/libs/*.war app.war
EXPOSE 8090
# 외부에 노출할 포트 지정
ENTRYPOINT ["java","-jar","/app.war"]