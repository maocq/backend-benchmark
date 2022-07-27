package com.maocq.repository;

import com.maocq.repository.account.data.AccountData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface AccountDataDAO extends JpaRepository<AccountData, Integer> {

    @Query(value = "SELECT a.id, a.user_id, a.account, a.name, a.number, a.balance, a.currency, a.type, a.bank, a.creation_date, a.update_date FROM account AS a WHERE (a.id = 4000)", nativeQuery = true)
    List<AccountData> findOne();

    @Query(value = "select * from account a where a.balance > (select avg(a.balance) + 72700000 from account a)", nativeQuery = true)
    List<AccountData> findTest();
}
