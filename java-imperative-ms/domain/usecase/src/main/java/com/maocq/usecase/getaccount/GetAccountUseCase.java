package com.maocq.usecase.getaccount;

import com.maocq.model.account.Account;
import com.maocq.model.account.gateways.AccountRepository;
import lombok.RequiredArgsConstructor;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;

@RequiredArgsConstructor
public class GetAccountUseCase {

    private final AccountRepository accountRepository;

    public Optional<Account> findById(Integer id) {
        return accountRepository.findById(id);
    }

    public List<Account> findOne() {
        return accountRepository.findOne();
    }
    public List<Account> findMultipleOne() {
        var a = accountRepository.findOne();
        var b = accountRepository.findOne();
        var c = accountRepository.findOne();
        var d = accountRepository.findOne();
        return accountRepository.findOne();
    }

    public CompletableFuture<List<Account>> findOneMultipleFixedExecutor() {
        var one = accountRepository.findOneFixedExecutor();
        var two = accountRepository.findOneFixedExecutor();
        var three = accountRepository.findOneFixedExecutor();
        var four = accountRepository.findOneFixedExecutor();
        var five = accountRepository.findOneFixedExecutor();

        return one
            .thenCompose(x -> two)
            .thenCompose(x -> three)
            .thenCompose(x -> four)
            .thenCompose(x -> five);
    }

    public CompletableFuture<List<Account>> findOneMultipleCachedExecutor() {
        var one = accountRepository.findOneCachedExecutor();
        var two = accountRepository.findOneCachedExecutor();
        var three = accountRepository.findOneCachedExecutor();
        var four = accountRepository.findOneCachedExecutor();
        var five = accountRepository.findOneCachedExecutor();

        return one
            .thenCompose(x -> two)
            .thenCompose(x -> three)
            .thenCompose(x -> four)
            .thenCompose(x -> five);
    }

    public List<Account> findTest() {
        return accountRepository.findTest();
    }

    public List<Account> findMultipleTest() {
        var a = accountRepository.findTest();
        var b = accountRepository.findTest();
        var c = accountRepository.findTest();
        var d = accountRepository.findTest();
        return accountRepository.findTest();
    }

    public Account update(Account account) {
        return accountRepository.update(account);
    }

    public Account updateMultiple(Account account) {
        accountRepository.update(account);
        accountRepository.update(account);
        accountRepository.update(account);
        accountRepository.update(account);
        return accountRepository.update(account);
    }

    public CompletableFuture<Account> updateMultipleFixedExecutor(Account account) {
        var one = accountRepository.updateFixedExecutor(account);
        var two = accountRepository.updateFixedExecutor(account);
        var three = accountRepository.updateFixedExecutor(account);
        var four = accountRepository.updateFixedExecutor(account);
        var five = accountRepository.updateFixedExecutor(account);

        return one
            .thenCompose(x -> two)
            .thenCompose(x -> three)
            .thenCompose(x -> four)
            .thenCompose(x -> five);
    }
}
