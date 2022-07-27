package com.maocq.model.account;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.ZonedDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder(toBuilder = true)
public class Account {
    private Integer id;
    private String userId;
    private String account;
    private String name;
    private String number;
    private BigDecimal balance;
    private String currency;
    private String type;
    private String bank;
    private ZonedDateTime creationDate;
    private ZonedDateTime updateDate;
}