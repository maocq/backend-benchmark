package config

import (
	"fmt"
	"net/http"
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func InitDB() *gorm.DB {
	ip := GetEnvOrDefault("DATABASE_IP", "db")
	url := fmt.Sprintf("postgres://compose-postgres:compose-postgres@%s:5432/compose-postgres", ip)
	db, err := gorm.Open(postgres.Open(url), &gorm.Config{})
	if err != nil {
		panic(err)
	}

	dbConfig, err := db.DB()
	if err != nil {
		panic(err)
	}
	dbConfig.SetMaxIdleConns(10)
	dbConfig.SetMaxOpenConns(10)

	return db
}

func GetHttpClient() *http.Client {
	t := http.DefaultTransport.(*http.Transport).Clone()
	t.MaxIdleConns = 500
	t.MaxConnsPerHost = 500
	t.MaxIdleConnsPerHost = 500

	return &http.Client{
		Transport: t,
	}
}

func GetUrlService() string {
	return fmt.Sprintf("http://%s:8080", GetEnvOrDefault("EXTERNAL_SERVICE_IP", "node-latency"))
}

func GetEnvOrDefault(key string, defaultV string) string {
	if varEnv := os.Getenv(key); varEnv == "" {
		return defaultV
	} else {
		return varEnv
	}
}
