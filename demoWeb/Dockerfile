FROM openjdk:11.0.10-jre
VOLUME /tmp
RUN chmod +x /var/jenkins_home/workspace/demoWeb/demoWeb/gradlew
RUN /var/jenkins_home/workspace/demoWeb/demoWeb/gradlew build
#ARG JAR_FILE=demoWeb/build/libs/*.war
COPY /var/jenkins_home/workspace/demoWeb/demoWeb/build/libs/*.war app.war
EXPOSE 8090
# 외부에 노출할 포트 지정
ENTRYPOINT ["java","-jar","/app.war"]