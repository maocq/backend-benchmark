package com.maocq.api;

import com.maocq.model.account.Account;
import com.maocq.usecase.cases.CasesUseCase;
import com.maocq.usecase.getaccount.GetAccountsUseCase;
import com.maocq.usecase.gethello.GetHelloUseCase;
import com.maocq.usecase.getprimes.GetPrimesUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.server.ServerResponse;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Component
@RequiredArgsConstructor
public class Handler {
    private final CasesUseCase casesUseCase;
    private final GetAccountsUseCase getAccountsUseCase;
    private final GetHelloUseCase getHelloUseCase;
    private final GetPrimesUseCase getPrimesUseCase;

    private final ExecutorService cpuExecutor = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());

    public Mono<ServerResponse> caseOne(ServerRequest serverRequest) {
        var latency = serverRequest.queryParam("latency").map(Integer::valueOf).orElse(0);
        return ServerResponse.ok().body(casesUseCase.caseOne(latency), Account.class);
    }

    public Mono<ServerResponse> caseTwo(ServerRequest serverRequest) {
        var latency = serverRequest.queryParam("latency").map(Integer::valueOf).orElse(0);
        return ServerResponse.ok().body(casesUseCase.caseTwo(latency), Account.class);
    }

    public Mono<ServerResponse> caseThree(ServerRequest serverRequest) {
        return ServerResponse.ok().body(casesUseCase.caseThree(), Account.class);
    }

    public Mono<ServerResponse> listenFinById(ServerRequest serverRequest) {
        return ServerResponse.ok().body(getAccountsUseCase.findById(4000), Account.class);
    }

    public Mono<ServerResponse> listenFindOne(ServerRequest serverRequest) {
        return ServerResponse.ok().body(getAccountsUseCase.findOne(), Account.class);
    }

    public Mono<ServerResponse> listenFindMultipleOne(ServerRequest serverRequest) {
        return ServerResponse.ok().body(getAccountsUseCase.findMultipleOne(), Account.class);
    }

    public Mono<ServerResponse> listenFindMultipleOneZip(ServerRequest serverRequest) {
        return ServerResponse.ok().body(getAccountsUseCase.findMultipleOneZip(), Account.class);
    }

    public Mono<ServerResponse> listenFindTest(ServerRequest serverRequest) {
        return ServerResponse.ok().body(getAccountsUseCase.findTest(), Account.class);
    }

    public Mono<ServerResponse> listenFindMultipleTest(ServerRequest serverRequest) {
        return ServerResponse.ok().body(getAccountsUseCase.findMultipleTest(), Account.class);
    }

    public Mono<ServerResponse> listenFindAll(ServerRequest serverRequest) {
        return ServerResponse.ok().body(getAccountsUseCase.findAll(), Account.class);
    }

    public Mono<ServerResponse> update(ServerRequest serverRequest) {
        /*
        var result = getAccountsUseCase.findById(4000)
          .flatMap(account -> {
              account.setUpdateDate(ZonedDateTime.now());
              return getAccountsUseCase.update(account);
          });
         */

        var account = Account.builder()
          .id(4000).userId("CC123454000").account("4000").name("Debit").number("D16344").balance(new BigDecimal("8002543.00"))
          .currency("COP").type("4000").bank("4000").creationDate(ZonedDateTime.now()).updateDate(ZonedDateTime.now()).build();
        var result = getAccountsUseCase.update(account);

        return ServerResponse.ok().body(result, Account.class);
    }

    public Mono<ServerResponse> listenGETAccountsWithLock(ServerRequest serverRequest) {
        return ServerResponse.ok().body(getAccountsUseCase.findAllWithLock(), Account.class);
    }


    public Mono<ServerResponse> listenGETHello(ServerRequest serverRequest) {
        var latency = serverRequest.queryParam("latency").map(Integer::valueOf).orElse(0);
        return ServerResponse.ok().body(getHelloUseCase.hello(latency), String.class);
    }

    public Mono<ServerResponse> listenGETMultipleHello(ServerRequest serverRequest) {
        return ServerResponse.ok().body(getHelloUseCase.multipleHello(), String.class);
    }

    public Mono<ServerResponse> listenGETMultipleHelloZip(ServerRequest serverRequest) {
        return ServerResponse.ok().body(getHelloUseCase.multipleHelloZip(), String.class);
    }

    public Mono<ServerResponse> listenGETPrimes(ServerRequest serverRequest) {
        var response = Mono.defer(() -> Mono.just(getPrimesUseCase.primes(1000)))
          .subscribeOn(Schedulers.fromExecutor(cpuExecutor));

        return ServerResponse.ok().body(response, String.class);
    }

    public Mono<ServerResponse> listenGETOtherUseCase(ServerRequest serverRequest) {
        return ServerResponse.ok().bodyValue("Hello");
    }

    public Mono<ServerResponse> listenPOSTUseCase(ServerRequest serverRequest) {
        // usecase.logic();
        return ServerResponse.ok().bodyValue("");
    }
}
