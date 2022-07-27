package com.maocq.consumer;

import com.maocq.model.hello.gateways.HelloRepository;
import lombok.RequiredArgsConstructor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RestConsumer implements HelloRepository {

    @Value("${adapter.restconsumer.url}")
    private String url;
    private final OkHttpClient client;


    public String hello(int latency) {

        Request request = new Request.Builder()
            .url(url + "/" + latency)
            .get()
            .build();

        try {
            return client.newCall(request).execute().body().string();
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }
}