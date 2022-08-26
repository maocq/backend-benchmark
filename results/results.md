# Backend benchmark (Java - Elixir - Go)

## (t2.micro)

### Health check
![Health check](t2.micro/health-check.png)

### Case one
(Latency 50ms)
![Case one 50](t2.micro/case-one-latency-50.png)
(Latency 200ms)
![Case one 200](t2.micro/case-one-latency-200.png)

### Case two
(Latency 100ms)
![Case two 100](t2.micro/case-two-latency-100.png)

### Case one + Case two (Together)
(Latency 80ms)
![Case one Case two](t2.micro/case-one-case-two-latency-80.png)

### Case three
(Database query only)

![Case three](t2.micro/case-three.png)

### Primes
Calculation of the first 1000 prime numbers

![Primes](t2.micro/primes.png)

### Only External service
(Latency 80ms)

![External service](t2.micro/get-hello-latency-80.png)

### Cpu and memory (Results with t2.micro)

![Metrics Java reactive](t2.micro/metrics-java-reactive.png)
![Metrics Java imperative](t2.micro/metrics-java-imperative.png)
![Metrics go](t2.micro/metrics-go.png)
![Metrics elixir](t2.micro/metrics-elixir.png)


## (c5.large)

### Health check
![Health check](c5.large/health-check.png)

### Case one
(Latency 50ms)
![Case one 50](c5.large/case-one-latency-50.png)
(Latency 200ms)
![Case one 200](c5.large/case-one-latency-200.png)

### Case two
(Latency 100ms)
![Case two 100](c5.large/case-two-latency-100.png)

### Case one + Case two (Together)
(Latency 80ms)
![Case one Case two](c5.large/case-one-case-two-latency-80.png)

### Case three
(Database query only)

![Case three](c5.large/case-three.png)

### Primes
Calculation of the first 1000 prime numbers

![Primes](c5.large/primes.png)

### Only External service
(Latency 80ms)

![External service](c5.large/get-hello-latency-80.png)
