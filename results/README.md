# Backend benchmark (Java - Elixir - Go)

### Prerequisites
To run this project you need:

- `aws-cli`
- `jq`

## Stacks 
- Java imperative - Spring boot `java-imperative-ms`
- Java Reactive - Spring webflux `java-reactive-ms`
- Elixir - Cowboy `elixir-ms`
- Go - Gin `go-ms`


Each stack generates a separate environment as follows

![Environment](results/environment.png)

(c5.large)

### Health check

![Health check](results/c5.large/health-check.png)

Most of the benchmarks only present this scenario, although it is an important scenario, it does not represent the closest cases to reality.

### Case one

The following scenario tries to simulate an example closer to reality in the following way

![Case one](results/case-one.png)

(Latency 50ms)
![Case one 50](results/c5.large/case-one-latency-50.png)
(Latency 200ms)
![Case one 200](results/c5.large/case-one-latency-200.png)

Although the latency increases almost 4 times more, the non-blocking alternatives continue to behave the same, unlike the blocking alternative, which is affected in the same proportion

### Case two

![Case two](results/case-two.png)
![Case two 100](results/c5.large/case-two-latency-100.png)

### Case one + Case two (Together)

![Case one Case two](results/c5.large/case-one-case-two-latency-80.png)

### Case three
(Database query only)

![Case three](results/c5.large/case-three.png)

### Primes
Calculation of the first 1000 prime numbers

![Primes](results/c5.large/primes.png)

Since in webflux we can easily use a dedicated thread pool, we can separate CPU bound tasks into a thread pool with a fixed number of threads equal to the number of available processors. The above generates a better performance by avoiding context switching as much as possible.

### Only External service
(Latency 80ms)

![External service](results/c5.large/get-hello-latency-80.png)

In contexts with low concurrency and very low internal latencies, we can easily choose blocking alternatives without major inconveniences. On the other hand, if we need to support a higher number of concurrency, the choice should be a non-blocking alternative.

Using non-blocking alternatives allows us to make more efficient use of all resources.

In conclusion, in non-blocking stacks we can see very similar behaviors.

In Java stacks, the performance when starting the test is not the most optimal due to the warming up of the jvm. With spring native it is expected to solve the previous problem.


### Cpu and memory (Results with t2.micro)

![Metrics Java reactive](results/t2.micro/metrics-java-reactive.png)
![Metrics Java imperative](results/t2.micro/metrics-java-imperative.png)
![Metrics go](results/t2.micro/metrics-go.png)
![Metrics elixir](results/t2.micro/metrics-elixir.png)

In go we can see a lower use of resources, both memory and cpu.


## Usage

```shell
cd sh

# ./aws_start.sh <stack>
./aws_start.sh go-ms
```

```shell
./test_jmeter.sh go-ms
```

### Results with t2.micro


#### Health check

![Health check](results/t2.micro/health-check.png)

#### Case one

(Latency 50ms)
![Case one 50](results/t2.micro/case-one-latency-50.png)
(Latency 200ms)
![Case one 200](results/t2.micro/case-one-latency-200.png)

#### Case two

![Case two 100](results/t2.micro/case-two-latency-100.png)

#### Case one + Case two (Together)

![Case one Case two](results/t2.micro/case-one-case-two-latency-80.png)

#### Case three

![Case three](results/t2.micro/case-three.png)

#### Primes

![Primes](results/t2.micro/primes.png)

#### Only External service

![External service](results/t2.micro/get-hello-latency-80.png)
