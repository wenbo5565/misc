% Matlab code Question 4(f) of HW4
% SOCP in Matlab (without CVX)

return_file = "E:\GW DS\2018 Spring\Computational Optimization\HW\Homework 4\g\Return_Matlab.csv";
r = csvread(return_file); % read return data
mu = mean(r);% average return per assset
T = 0.0011; % target return level
n = 200; % number of assets
m = 469; % number of periods

% =================================
% set QP coefficients
% =================================

% assume decision vector x = [v1,...,vm, y1,...,yn, k ]

% coefficient matrix
diagH = [ones([1,m]) zeros([1 n+1])]; % no need to include 1/m because of equivalence. 
H = diag(diagH);

% coefficient for linear inequality constraints
A = horzcat(-1*diag(ones([m,1])),-r,T*ones([m,1])); % coefficient for linear inequality
b = zeros([m,1]); % constant (right-hand side) of linear inequality

% coeffcient for linear equality constraints
Aeq1 = horzcat(zeros([1,m]),ones([1,n]),-1); % coef for y*e - k = 0
Aeq2 = horzcat(zeros([1,m]),mu,0);% coef for u*y = 1
Aeq = [Aeq1;Aeq2];% coefficient for linear equality constraints
beq = [0;1];% constant for linear equality constraints
lb = [zeros([1,m+n]) -Inf]; % lower bound for decision variable

% solve the problem
options = optimoptions('quadprog','Algorithm','interior-point-convex');
tic;
[x,fval] = quadprog(H,[],A,b,Aeq,beq,lb,[],[],options);
toc

y = x(m+1:m+n); % recover y
v = x(1:m); % recover v
k = x(m+1+n); % recover k

w = y/k;
b = v/k;
target = mu*w/sqrt(1/m*transpose(b)*b);
w
target




