package com.maocq.usecase.cases;

import com.maocq.model.account.Account;
import com.maocq.model.account.gateways.AccountRepository;
import com.maocq.model.hello.gateways.HelloRepository;
import lombok.RequiredArgsConstructor;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.ZonedDateTime;

@RequiredArgsConstructor
public class CasesUseCase {

  private final AccountRepository accountRepository;
  private final HelloRepository helloRepository;

  public Mono<Account> caseOne(int latency) {
    return helloRepository.hello(latency)
        .flatMap(x -> helloRepository.hello(latency))
        .flatMap(x -> accountRepository.findById(4000)
        .flatMap(account -> helloRepository.hello(latency)
        .flatMap(y -> {
          account.setUpdateDate(ZonedDateTime.now());
          return accountRepository.update(account);
        })));
  }

  public Flux<Account> caseTwo(int latency) {
    return accountRepository.findOne()
        .flatMap(account -> helloRepository.hello(latency)
          .map(x -> account));
  }

  public Mono<Account> caseThree() {
    return accountRepository.findById(4000);
  }
}
