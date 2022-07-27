package model

import "time"

type Account struct {
	Id           int
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
