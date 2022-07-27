package com.maocq.usecase.gethello;

import com.maocq.model.hello.gateways.HelloRepository;
import lombok.RequiredArgsConstructor;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@RequiredArgsConstructor
public class GetHelloUseCase {

    private final ExecutorService executor = Executors.newCachedThreadPool();
    private final HelloRepository helloRepository;

    public String hello(int latency) {
        return helloRepository.hello(latency);
    }

    public CompletableFuture<String> helloFuture() {
        return CompletableFuture.supplyAsync(() -> helloRepository.hello(50), executor);
    }

    public String multipleHello() {
        var a = helloRepository.hello(50);
        var b = helloRepository.hello(50);
        var c = helloRepository.hello(50);
        var d = helloRepository.hello(50);
        return helloRepository.hello(50);
    }

    public CompletableFuture<String> multipleHelloFutures() {
        var one = CompletableFuture.supplyAsync(() -> helloRepository.hello(50), executor);
        var two = CompletableFuture.supplyAsync(() -> helloRepository.hello(50), executor);
        var three = CompletableFuture.supplyAsync(() -> helloRepository.hello(50), executor);
        var four = CompletableFuture.supplyAsync(() -> helloRepository.hello(50), executor);
        var five = CompletableFuture.supplyAsync(() -> helloRepository.hello(50), executor);

        return one
            .thenCompose(x -> two)
            .thenCompose(x -> three)
            .thenCompose(x -> four)
            .thenCompose(x -> five);
    }
}
