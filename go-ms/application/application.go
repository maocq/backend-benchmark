package application

import (
	"maocq/go-ms/application/config"
	"maocq/go-ms/domain/usecase"
	repository "maocq/go-ms/infrastructure/driven-adapters/db/account"
	"maocq/go-ms/infrastructure/driven-adapters/httpclient"
	"maocq/go-ms/infrastructure/entry-points/rest"
)

func Start() {
	db := config.InitDB()
	httpClient := config.GetHttpClient()

	accountRepository := repository.AccountDataRepository{DB: db}
	helloRepository := httpclient.HelloHttpRepository{Client: httpClient, Url: config.GetUrlService()}

	cases := usecase.CasesUseCase{AccountRepository: &accountRepository, HelloRepository: &helloRepository}
	hello := usecase.HelloUseCase{HelloRepository: &helloRepository}
	primes := usecase.GetPrimesUseCase{}

	rest.Start(&hello, &cases, &primes)
}
