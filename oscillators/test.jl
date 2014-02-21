function compute_price(paths, S0, K, r, T, sigma)
  price = 0;
  for i = 1:200
      Zs = randn(paths,1);
      for i in 1:paths
          Z = T*(r-sigma^2/2) + Zs[i]*T^0.5*sigma;
          ST = S0*exp(Z);
          C = exp(-r*T)*max(ST - K,0)/200;
          price = price + sum(C)/paths;
      end
  end
  return price
end

S0 = 100;
K = 100;
r = 0.1;
T = 1;
sigma = 0.1;
paths = 100000;

tic();
price = compute_price(paths, S0, K, r, T, sigma);
toc();
print("Call price = $price\n");
