package com.maocq.api;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.ServerResponse;

import static org.springframework.web.reactive.function.server.RouterFunctions.route;
import static org.springframework.web.reactive.function.server.RequestPredicates.*;


@Configuration
public class RouterRest {
@Bean
public RouterFunction<ServerResponse> routerFunction(Handler handler) {

    return route(GET("/api/case-one"), handler::caseOne)
      .andRoute(GET("/api/case-two"), handler::caseTwo)
      .andRoute(GET("/api/case-three"), handler::caseThree)
      .andRoute(GET("/api/find-by-id"), handler::listenFinById)
      .andRoute(GET("/api/find-one"), handler::listenFindOne)
      .andRoute(GET("/api/find-multiple-one"), handler::listenFindMultipleOne)
      .andRoute(GET("/api/find-multiple-one-zip"), handler::listenFindMultipleOneZip)
      .andRoute(GET("/api/find-test"), handler::listenFindTest)
      .andRoute(GET("/api/find-multiple-test"), handler::listenFindMultipleTest)
      .andRoute(GET("/api/findall"), handler::listenFindAll)
      .andRoute(GET("/api/update"), handler::update)
      .andRoute(GET("/api/get-hello"), handler::listenGETHello)
      .andRoute(GET("/api/get-multiple-hello"), handler::listenGETMultipleHello)
      .andRoute(GET("/api/get-multiple-hello-zip"), handler::listenGETMultipleHelloZip)
      .andRoute(GET("/api/primes"), handler::listenGETPrimes)
      .andRoute(POST("/api/otherpath"), handler::listenPOSTUseCase)
      .and(route(GET("/api/hello"), handler::listenGETOtherUseCase));
    }
}
