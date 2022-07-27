package data

import (
	"fmt"
	model "maocq/go-ms/domain/model/account"
	data "maocq/go-ms/infrastructure/driven-adapters/db/account/data"

	"gorm.io/gorm"
)

type AccountDataRepository struct {
	DB *gorm.DB
}

func (r *AccountDataRepository) FindById(id int) *model.Account {
	var accountData data.AccountData
	if result := r.DB.First(&accountData, id); result.Error != nil {
		fmt.Println("Error", result.Error)
	}

	return toEntity(&accountData)
}

func (r *AccountDataRepository) FindOne() []*model.Account {
	var accountsData []data.AccountData
	if result := r.DB.Where("id = ?", 4000).Find(&accountsData); result.Error != nil {
		fmt.Println("Error", result.Error)
	}
	var accounts []*model.Account
	for _, account := range accountsData {
		accounts = append(accounts, toEntity(&account))
	}

	return accounts
}

func (r *AccountDataRepository) Update(account *model.Account) *model.Account {
	data := toData(account)
	if result := r.DB.Save(data); result.Error != nil {
		fmt.Println("Error", result.Error)
	}
	return toEntity(data)
}

func toEntity(data *data.AccountData) *model.Account {
	return &model.Account{Id: data.Id, UserId: data.UserId, Account: data.Account, Name: data.Name,
		Number: data.Number, Balance: data.Balance, Currency: data.Currency, Type: data.Type,
		Bank: data.Bank, CreationDate: data.CreationDate, UpdateDate: data.UpdateDate}
}

func toData(model *model.Account) *data.AccountData {
	return &data.AccountData{Id: model.Id, UserId: model.UserId, Account: model.Account,
		Name: model.Name, Number: model.Number, Balance: model.Balance, Currency: model.Currency,
		Type: model.Type, Bank: model.Bank, CreationDate: model.CreationDate, UpdateDate: model.UpdateDate}
}
