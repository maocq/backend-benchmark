package com.maocq.usecase.cases;

import com.maocq.model.account.Account;
import com.maocq.model.account.gateways.AccountRepository;
import com.maocq.model.hello.gateways.HelloRepository;
import lombok.RequiredArgsConstructor;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
public class CasesUseCase {

  private final AccountRepository accountRepository;
  private final HelloRepository helloRepository;

  public Account caseOne(int latency) {
     var x = helloRepository.hello(latency);
     var y = helloRepository.hello(latency);
     var account = accountRepository.findById(4000)
         .orElseThrow(() -> new IllegalStateException("Account not found"));
     var z = helloRepository.hello(latency);
     account.setUpdateDate(ZonedDateTime.now());
     return accountRepository.update(account);
  }

  public List<Account> caseTwo(int latency) {
    var account = accountRepository.findOne();
    var x = helloRepository.hello(latency);
    return account;
  }

  public Optional<Account> caseThree() {
    return accountRepository.findById(4000);
  }
}
