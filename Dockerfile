FROM openjdk:8
COPY jarstaging/com/valaxy/demo-workshop/2.1.2.jar was-pro.jar
ENTRYPOINT [ "java","jar","was-pro.jar" ]
