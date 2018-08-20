% CVX code Question 4(g) of HW4
% SOCP

return_file = "E:\GW DS\2018 Spring\Computational Optimization\HW\Homework 4\g\Return_Matlab.csv";
r = csvread(return_file); % read return data
mu = mean(r);% average return per assset
T = 0.0011; % annualized target return level
n = 200; % number of assets
m = 469; % number of periods

cvx_begin
    variables k v(m) y(n) h;
    minimize sqrt(1/m)*h;
    subject to
        sum(y) == k;
        v >= k*T-r*y;
        {v,h} == lorentz(m);
        mu*y == 1;
        v >= 0;
        y >= 0;
cvx_end

w = y/k; % recover weights variables
b = v/k;
target = (mu*w)/(sqrt(1/m*sum(transpose(b)*b))) % recover optimal value
w

