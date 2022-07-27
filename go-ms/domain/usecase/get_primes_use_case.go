package usecase

import "strconv"

type GetPrimesUseCase struct {
}

func (p *GetPrimesUseCase) Primes(n int) string {
	return SieveOfEratosthenes(n)
}

func SieveOfEratosthenes(n int) string {

	integers := make([]bool, n+1)
	for i := 2; i < n+1; i++ {
		integers[i] = true
	}

	for p := 2; p*p <= n; p++ {
		// If integers[p] is not changed, then it is a prime
		if integers[p] == true {
			// Update all multiples of p
			for i := p * 2; i <= n; i += p {
				integers[i] = false
			}
		}
	}

	// return all prime numbers <= n
	var primes string
	for p := 2; p <= n; p++ {
		if integers[p] == true {
			primes += strconv.Itoa(p) + " "
		}
	}

	return primes
}
