# ARG VERSION="1.0-SNAPSHOT"

FROM maven:3.8.3-openjdk-17 as builder
WORKDIR /usr/src/app
COPY ./pom.xml pom.xml
COPY ./src src
# RUN mvn -B -ntp versions:set -DnewVersion=${VERSION}
RUN mvn -B -V -ntp clean package  -DskipTests

FROM provectuslabs/kafka-ui:v0.6.1
COPY --from=builder  /usr/src/app/target/kafkaui-glue-serde-1.0-SNAPSHOT-jar-with-dependencies.jar /var/lib/glue-serde/
CMD ["/bin/sh", "-c", "java --add-opens java.rmi/javax.rmi.ssl=ALL-UNNAMED  $JAVA_OPTS -jar kafka-ui-api.jar"]