package com.maocq.api;
import com.maocq.model.account.Account;
import com.maocq.usecase.cases.CasesUseCase;
import com.maocq.usecase.getaccount.GetAccountUseCase;
import com.maocq.usecase.gethello.GetHelloUseCase;
import com.maocq.usecase.getprimes.GetPrimesUseCase;
import lombok.AllArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@RestController
@RequestMapping(value = "/api", produces = MediaType.APPLICATION_JSON_VALUE)
@AllArgsConstructor
public class ApiRest {

    private final CasesUseCase casesUseCase;
    private final ExecutorService cpuExecutor = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());
    private final GetAccountUseCase getAccountUseCase;
    private final GetHelloUseCase helloUseCase;
    private final GetPrimesUseCase getPrimesUseCase;

    @GetMapping(path = "/hello")
    public String hello() {
        return "Hello";
    }

    @GetMapping(path = "/case-one")
    public Account caseOne(@RequestParam(required = false) Integer latency) {
        var latencyValue = latency == null ? 0 : latency;
        return casesUseCase.caseOne(latencyValue);
    }

    @GetMapping(path = "/case-two")
    public List<Account> caseTwo(@RequestParam(required = false) Integer latency) {
        var latencyValue = latency == null ? 0 : latency;
        return casesUseCase.caseTwo(latencyValue);
    }

    @GetMapping(path = "/case-three")
    public Optional<Account> caseThree() {
        return casesUseCase.caseThree();
    }

    @GetMapping(path = "/find-by-id")
    public Optional<Account> findById() {
        return getAccountUseCase.findById(4000);
    }

    @GetMapping(path = "/find-one")
    public List<Account> findOne() {
        return getAccountUseCase.findOne();
    }

    @GetMapping(path = "/find-multiple-one")
    public List<Account> findMultipleOne() {
        return getAccountUseCase.findMultipleOne();
    }

    @GetMapping(path = "/find-multiple-one-fixed-executor")
    public CompletableFuture<List<Account>> findOneMultipleFixedExecutor() {
        return getAccountUseCase.findOneMultipleFixedExecutor();
    }

    @GetMapping(path = "/find-multiple-one-cached-executor")
    public CompletableFuture<List<Account>> findOneMultipleCachedExecutor() {
        return getAccountUseCase.findOneMultipleCachedExecutor();
    }

    @GetMapping(path = "/find-test")
    public List<Account> findTest() {
        return getAccountUseCase.findTest();
    }

    @GetMapping(path = "/find-multiple-test")
    public List<Account> findMultipleTest() {
        return getAccountUseCase.findMultipleTest();
    }

    @GetMapping(path = "/update")
    public Account update() {
        var account = Account.builder()
          .id(4000).userId("CC123454000").account("4000").name("Debit").number("D16344").balance(new BigDecimal("8002543.00"))
          .currency("COP").type("4000").bank("4000").creationDate(ZonedDateTime.now()).updateDate(ZonedDateTime.now()).build();
        return getAccountUseCase.update(account);
    }

    @GetMapping(path = "/update-multiple")
    public Account updateMultiple() {
        var account = Account.builder()
            .id(4000).userId("CC123454000").account("4000").name("Debit").number("D16344").balance(new BigDecimal("8002543.00"))
            .currency("COP").type("4000").bank("4000").creationDate(ZonedDateTime.now()).updateDate(ZonedDateTime.now()).build();
        return getAccountUseCase.updateMultiple(account);
    }

    @GetMapping(path = "/update-multiple-fixed-executor")
    public CompletableFuture<Account> updateMultipleFixedExecutor() {
        var account = Account.builder()
            .id(4000).userId("CC123454000").account("4000").name("Debit").number("D16344").balance(new BigDecimal("8002543.00"))
            .currency("COP").type("4000").bank("4000").creationDate(ZonedDateTime.now()).updateDate(ZonedDateTime.now()).build();
        return getAccountUseCase.updateMultipleFixedExecutor(account);
    }

    @GetMapping(path = "/primes")
    public String getPrimes() {
        return getPrimesUseCase.primes(1000);
    }

    @GetMapping(path = "/primes-future")
    public CompletableFuture<String> getPrimesFuture() {
        return CompletableFuture.supplyAsync(() -> getPrimesUseCase.primes(1000), cpuExecutor);
    }

    @GetMapping(path = "/get-hello")
    public String getHello(@RequestParam(required = false) Integer latency) {
        var latencyValue = latency == null ? 0 : latency;
        return helloUseCase.hello(latencyValue);
    }

    @GetMapping(path = "/get-hello-future")
    public CompletableFuture<String> getHelloFuture() {
        return helloUseCase.helloFuture();
    }

    @GetMapping(path = "/get-multiple-hello")
    public String getMultipleHello() {
        return helloUseCase.multipleHello();
    }

    @GetMapping(path = "/get-multiple-hello-futures")
    public CompletableFuture<String> getMultipleHelloFutures() {
        return helloUseCase.multipleHelloFutures();
    }
}
