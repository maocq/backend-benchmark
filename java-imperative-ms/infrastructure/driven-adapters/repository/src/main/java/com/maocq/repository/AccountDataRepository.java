package com.maocq.repository;

import com.maocq.model.account.Account;
import com.maocq.model.account.gateways.AccountRepository;
import com.maocq.repository.account.data.AccountData;
import lombok.RequiredArgsConstructor;
import org.reactivecommons.utils.ObjectMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ForkJoinPool;
import java.util.stream.Collectors;

@Repository
@RequiredArgsConstructor
public class AccountDataRepository implements AccountRepository {

    private static ExecutorService fixedExecutor = Executors.newFixedThreadPool(10);
    private static ExecutorService cachedExecutor = Executors.newCachedThreadPool();

    private final AccountDataDAO accountDataDAO;
    private final ObjectMapper mapper;

    public Optional<Account> findById(Integer id) {
        return accountDataDAO.findById(id)
          .map(this::toEntity);
    }

    public List<Account> findOne() {
        return accountDataDAO.findOne().stream()
          .map(this::toEntity).collect(Collectors.toList());
    }

    public CompletableFuture<List<Account>> findOneFixedExecutor() {
        return CompletableFuture
            .supplyAsync(accountDataDAO::findOne, fixedExecutor)
            .thenApplyAsync(list -> list.stream().map(this::toEntity).collect(Collectors.toList()), ForkJoinPool.commonPool());
    }

    public CompletableFuture<List<Account>> findOneCachedExecutor() {
        return CompletableFuture
            .supplyAsync(accountDataDAO::findOne, cachedExecutor)
            .thenApplyAsync(list -> list.stream().map(this::toEntity).collect(Collectors.toList()), ForkJoinPool.commonPool());
    }

    public List<Account> findTest() {
        return accountDataDAO.findTest().stream()
          .map(this::toEntity).collect(Collectors.toList());
    }

    public Account update(Account account) {
        var data = accountDataDAO.save(toData(account));
        return toEntity(data);
    }

    public CompletableFuture<Account> updateFixedExecutor(Account account) {
        return CompletableFuture.supplyAsync(() -> accountDataDAO.save(toData(account)), fixedExecutor)
            .thenApplyAsync(this::toEntity);
    }

    private Account toEntity(AccountData data) {
        return mapper.map(data, Account.class);
    }
    private AccountData toData(Account data) {
        return mapper.map(data, AccountData.class);
    }
}
