package rest

import (
	"github.com/gin-gonic/gin"
	"maocq/go-ms/domain/usecase"
	"net/http"
)

func Start(hello *usecase.HelloUseCase, cases *usecase.CasesUseCase, primes *usecase.GetPrimesUseCase) {
	router := gin.Default()
	router.GET("/api/hello", func(c *gin.Context) { c.String(http.StatusOK, "Hello") })

	router.GET("/api/get-hello", func(c *gin.Context) {
		latency := c.DefaultQuery("latency", "0")

		if body, err := hello.Hello(latency); err != nil {
			c.String(http.StatusInternalServerError, err.Error())
		} else {
			c.String(http.StatusOK, body)
		}
	})

	router.GET("/api/case-one", func(c *gin.Context) {
		latency := c.DefaultQuery("latency", "0")

		if result, err := cases.CaseOne(latency); err != nil {
			c.String(http.StatusInternalServerError, err.Error())
		} else {
			c.JSON(http.StatusOK, result)
		}
	})

	router.GET("/api/case-two", func(c *gin.Context) {
		latency := c.DefaultQuery("latency", "0")

		if result, err := cases.CaseTwo(latency); err != nil {
			c.String(http.StatusInternalServerError, err.Error())
		} else {
			c.JSON(http.StatusOK, result)
		}
	})

	router.GET("/api/case-three", func(c *gin.Context) {
		result := cases.CaseThree()
		c.JSON(http.StatusOK, result)
	})

	router.GET("/api/primes", func(c *gin.Context) {
		result := primes.Primes(1000)
		c.String(http.StatusOK, result)
	})

	router.Run("0.0.0.0:8080")
}
