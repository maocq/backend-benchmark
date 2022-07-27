package com.maocq.repository.account;

import com.maocq.model.account.Account;
import com.maocq.model.account.gateways.AccountRepository;
import com.maocq.repository.account.data.AccountData;
import lombok.RequiredArgsConstructor;
import org.reactivecommons.utils.ObjectMapper;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
@RequiredArgsConstructor
public class AccountDataRepository implements AccountRepository {

    private final AccountDataDAO accountDataDAO;
    private final ObjectMapper mapper;

    public Mono<Account> findById(Integer id) {
        return accountDataDAO.findById(id)
          .map(this::toEntity);
    }

    public Flux<Account> findOne() {
        return accountDataDAO.findOne()
          .map(this::toEntity);
    }

    public Flux<Account> findTest() {
        return accountDataDAO.findTest()
          .map(this::toEntity);
    }

    public Flux<Account> findAll() {
        return accountDataDAO.findAll()
          .map(this::toEntity);
    }

    public Flux<Account> findAllWithLock() {
        return accountDataDAO.findAllWithLock()
          .map(this::toEntity);
    }

    public Mono<Account> update(Account account) {
        return accountDataDAO.save(toData(account))
          .map(this::toEntity);
    }

   private Account toEntity(AccountData data) {
        return mapper.map(data, Account.class);
    }
   private AccountData toData(Account data) {
        return mapper.map(data, AccountData.class);
    }
}
