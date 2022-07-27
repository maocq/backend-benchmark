package com.maocq.repository.account;

import com.maocq.repository.account.data.AccountData;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;

public interface AccountDataDAO extends ReactiveCrudRepository<AccountData, Integer> {

    @Query("SELECT * FROM account FOR UPDATE")
    Flux<AccountData> findAllWithLock();

    @Query("SELECT a.id, a.user_id, a.account, a.name, a.number, a.balance, a.currency, a.type, a.bank, a.creation_date, a.update_date FROM account AS a WHERE (a.id = 4000)")
    Flux<AccountData> findOne();

    @Query("select * from account a where a.balance > (select avg(a.balance) + 72700000 from account a)")
    Flux<AccountData> findTest();
}
