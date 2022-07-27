package com.maocq.model.account.gateways;

import com.maocq.model.account.Account;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;

public interface AccountRepository {

    Optional<Account> findById(Integer id);
    List<Account> findOne();
    CompletableFuture<List<Account>> findOneFixedExecutor();
    CompletableFuture<List<Account>> findOneCachedExecutor();
    List<Account> findTest();
    Account update(Account account);
    CompletableFuture<Account> updateFixedExecutor(Account account);
}
