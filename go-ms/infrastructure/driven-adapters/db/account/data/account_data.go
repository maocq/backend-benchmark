package data

import "time"

type AccountData struct {
	Id           int `gorm:"primaryKey"`
	UserId       string
	Account      string
	Name         string
	Number       string
	Balance      float64
	Currency     string
	Type         string
	Bank         string
	CreationDate time.Time
	UpdateDate   time.Time
}

func (*AccountData) TableName() string {
	return "account"
}
