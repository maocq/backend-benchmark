package gateways

import model "maocq/go-ms/domain/model/account"

type AccountRepository interface {
	FindById(id int) *model.Account
	FindOne() []*model.Account
	Update(account *model.Account) *model.Account
}
