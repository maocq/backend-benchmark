package com.maocq.config;

import org.reactivecommons.utils.ObjectMapper;
import org.reactivecommons.utils.ObjectMapperImp;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ObjectMapperConfig {
    @Bean
    public ObjectMapper objectMapper() {
        return new ObjectMapperImp();
    }

    /*
    @Bean
    public WebClient.Builder webClientBuilder() {
        String connectionProviderName = "myConnectionProvider";
        int maxConnections = 10000;
        HttpClient httpClient = HttpClient.create(ConnectionProvider
            .create(connectionProviderName, maxConnections));
        return WebClient.builder()
            .clientConnector(new ReactorClientHttpConnector(httpClient));
    }
     */
}
