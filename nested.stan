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
  real<lower=0> sigma1;
  real<lower=0> sigma2;
  real<lower=0> sigma3;
  real<lower=0> sigma;
  
  vector[N1] u1;
  vector[N2] u2;
  vector[N3] u3;
}
transformed parameters {
  vector[N1] su1;
  vector[N2] su2;
  vector[N3] su3;
  vector[N] yhat;
  
  su1 = sigma1 * u1;
  su2 = sigma2 * u2;
  su3 = sigma3 * u3;
  
  for (i in 1:N)
    yhat[i] = mu +  su1[level1[i]] + su2[level2[i]] + su3[level3[i]];
  
}
model {
  u1 ~ normal(0, 1);
  u2 ~ normal(0, 1);
  u3 ~ normal(0, 1);
  sigma1 ~ cauchy(0, 2.5 * sdscal);
  sigma2 ~ cauchy(0, 2.5 * sdscal);
  sigma3 ~ cauchy(0, 2.5 * sdscal);
  sigma ~ cauchy(0, 2.5 * sdscal);
  y ~ normal(yhat, sigma);
}
