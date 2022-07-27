package com.maocq.model.hello.gateways;

import reactor.core.publisher.Mono;

public interface HelloRepository {

    Mono<String> hello(int latency);
}
