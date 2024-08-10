FROM openjdk:8
COPY /home/ubuntu/jenkins/workspace/Multi-Branch_main/jarstaging/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.1.2.jar /app/waqas-pro-2.1.2.jar
ENTRYPOINT ["java", "-jar", "/app/waqas-pro-2.1.2.jar"]
