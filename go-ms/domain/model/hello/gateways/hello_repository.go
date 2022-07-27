package gateways

type HelloRepository interface {
	Hello(latency string) (string, error)
}
