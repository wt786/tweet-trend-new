FROM openjdk:8
COPY /home/ubuntu/jenkins/workspace/Multi-Branch_main/jarstaging/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.1.2.jar was-pro.jar
ENTRYPOINT ["java", "-jar", "was-pro.jar"]
