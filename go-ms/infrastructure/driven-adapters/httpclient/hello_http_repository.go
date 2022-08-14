package httpclient

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

type HelloHttpRepository struct {
	Client *http.Client
	Url    string
}

func (h *HelloHttpRepository) Hello(latency string) (string, error) {
	urlComplete := fmt.Sprintf("%s/%s", h.Url, latency)
	request, err := http.NewRequest("GET", urlComplete, nil)
	if err != nil {
		return "", err
	}

	response, err := h.Client.Do(request)
	if err != nil {
		return "", err
	}

	defer response.Body.Close()
	body, err := ioutil.ReadAll(response.Body)
	return string(body), err
}
