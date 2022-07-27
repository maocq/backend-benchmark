package com.maocq.model.account.gateways;

import com.maocq.model.account.Account;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface AccountRepository {

    Mono<Account> findById(Integer id);
    Flux<Account> findOne();
    Flux<Account> findTest();
    Flux<Account> findAll();
    Flux<Account> findAllWithLock();
    Mono<Account> update(Account account);
}
