FROM openjdk:8
ADD /home/ubuntu/jenkins/workspace/Multi-Branch_main/jarstaging/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.1.2.jar waseem.jar
ENTRYPOINT ["java", "-jar", "waseem.jar"]