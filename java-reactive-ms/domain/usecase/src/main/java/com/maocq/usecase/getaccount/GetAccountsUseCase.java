package com.maocq.usecase.getaccount;

import com.maocq.model.account.Account;
import com.maocq.model.account.gateways.AccountRepository;
import lombok.RequiredArgsConstructor;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.util.function.Tuple2;

@RequiredArgsConstructor
public class GetAccountsUseCase {

    private final AccountRepository accountRepository;

    public Mono<Account> findById(Integer id) {
        return accountRepository.findById(id);
    }

    public Flux<Account> findOne() {
        return accountRepository.findOne();
    }

    public Flux<Account> findMultipleOne() {
        return accountRepository.findOne()
          .flatMap(x -> accountRepository.findOne())
          .flatMap(x -> accountRepository.findOne())
          .flatMap(x -> accountRepository.findOne())
          .flatMap(x -> accountRepository.findOne());
    }

    public Flux<Account> findMultipleOneZip() {
        return Flux.zip(accountRepository.findOne(),
            accountRepository.findOne(),
            accountRepository.findOne(),
            accountRepository.findOne(),
            accountRepository.findOne()).map(Tuple2::getT1);
    }

    public Flux<Account> findTest() {
        return accountRepository.findTest();
    }

    public Flux<Account> findMultipleTest() {
        return Flux.zip(accountRepository.findTest(),
          accountRepository.findTest(),
          accountRepository.findTest(),
          accountRepository.findTest(),
          accountRepository.findTest()).map(Tuple2::getT1);

    }

    public Flux<Account> findAll() {
        return accountRepository.findAll();
    }

    public Flux<Account> findAllWithLock() {
        return accountRepository.findAllWithLock();
    }

    public Mono<Account> update(Account account) {
        return accountRepository.update(account);
    }
}
