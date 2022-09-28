FROM gradle:jdk11-alpine
WORKDIR /app
COPY . .
RUN gradle bootJar


FROM adoptopenjdk/openjdk11-openj9:alpine-slim
WORKDIR /app
COPY --from=0 /app/applications/app-service/build/libs/app-service.jar /app/app-service.jar
ADD "https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar" ./

ENV JAVA_OPTS="-javaagent:./opentelemetry-javaagent.jar \
                -Dotel.service.name=JavaReactiveMs \
                -XX:+UseContainerSupport"
ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar app-service.jar"]