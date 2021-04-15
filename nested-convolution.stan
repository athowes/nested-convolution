data {
  int<lower=0> N;
  int<lower=0> N1;
  int<lower=0> N2;
  int<lower=0> N3;
  vector[N] y;
  int<lower=1,upper=N1> level1[N];
  int<lower=1,upper=N2> level2[N];
  int<lower=1,upper=N3> level3[N];
  real<lower=0> sdscal;
}

parameters {
  real mu;
  real<lower=0, upper=1> pi1;
  real<lower=0, upper=1> pi2;
  real<lower=0> sigmaphi;
  real<lower=0> sigma;
  
  vector[N1] u1;
  vector[N2] u2;
  vector[N3] u3;
}

transformed parameters {
  vector[N] phi;
  vector[N] yhat;
  
  for (i in 1:N) {
    phi[i] = mu + sqrt(pi1) * u1[level1[i]] + sqrt((1 - pi1) * pi2) * u2[level2[i]] + sqrt((1 - pi1) * (1 - pi2)) * u3[level3[i]];
  }
  
  yhat = mu +  sigmaphi * phi;
}

model {
  u1 ~ normal(0, 1);
  u2 ~ normal(0, 1);
  u3 ~ normal(0, 1);
  pi1 ~ beta(1, 1);
  pi2 ~ beta(1, 1);
  sigmaphi ~ cauchy(0, 2.5 * sdscal);
  sigma ~ cauchy(0, 2.5 * sdscal);
  y ~ normal(yhat, sigma);
}
