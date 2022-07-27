package usecase

import (
	model "maocq/go-ms/domain/model/account"
	account "maocq/go-ms/domain/model/account/gateways"
	hello "maocq/go-ms/domain/model/hello/gateways"
	"time"
)

type CasesUseCase struct {
	AccountRepository account.AccountRepository
	HelloRepository   hello.HelloRepository
}

func (c *CasesUseCase) CaseOne(latency string) (*model.Account, error) {
	if _, err := c.HelloRepository.Hello(latency); err != nil {
		return nil, err
	}
	if _, err := c.HelloRepository.Hello(latency); err != nil {
		return nil, err
	}
	account := c.AccountRepository.FindById(4000)
	if _, err := c.HelloRepository.Hello(latency); err != nil {
		return nil, err
	}
	account.UpdateDate = time.Now()
	return c.AccountRepository.Update(account), nil
}

func (c *CasesUseCase) CaseTwo(latency string) ([]*model.Account, error) {
	accounts := c.AccountRepository.FindOne()
	if _, err := c.HelloRepository.Hello(latency); err != nil {
		return nil, err
	}
	return accounts, nil
}

func (c *CasesUseCase) CaseThree() *model.Account {
	return c.AccountRepository.FindById(4000)
}
