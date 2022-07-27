package com.maocq.usecase.gethello;

import com.maocq.model.hello.gateways.HelloRepository;
import lombok.RequiredArgsConstructor;
import reactor.core.publisher.Mono;
import reactor.util.function.Tuple2;

@RequiredArgsConstructor
public class GetHelloUseCase {

    private final HelloRepository helloRepository;

    public Mono<String> hello(int latency) {
        return helloRepository.hello(latency);
    }

    public Mono<String> multipleHello() {
        return helloRepository.hello(50)
          .flatMap(x -> helloRepository.hello(50))
          .flatMap(x -> helloRepository.hello(50))
          .flatMap(x -> helloRepository.hello(50))
          .flatMap(x -> helloRepository.hello(50));
    }

    public Mono<String> multipleHelloZip() {
        return Mono.zip(helloRepository.hello(50),
            helloRepository.hello(50),
            helloRepository.hello(50),
            helloRepository.hello(50),
            helloRepository.hello(50)).map(Tuple2::getT1);
    }
}
