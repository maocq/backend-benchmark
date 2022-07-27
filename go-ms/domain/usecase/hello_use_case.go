package usecase

import hello "maocq/go-ms/domain/model/hello/gateways"

type HelloUseCase struct {
	HelloRepository hello.HelloRepository
}

func (h *HelloUseCase) Hello(latency string) (string, error) {
	return h.HelloRepository.Hello(latency)
}
