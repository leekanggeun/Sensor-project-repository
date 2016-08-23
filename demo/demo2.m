clc; clear all; close all; 
%%
gpuDevice(1);
addpath(genpath('.'));
path(path, './toolbox_optim');
%%
rng(2016);
load data4.mat
N = 120000;
%% Setting sparsity
sparsity = 0.125;
measure = randperm(N, sparsity.*N);
signal = data4(1:120000);
S0 = signal;
636666
N = size(signal,1);

%% Generating undersampled signal
measurement = zeros([N, 1]);
measurement(measure) = 1;
measurement(1:119488) = 1;
m = measurement.*signal;

opt.alpha  = params;
opt.lambda = params;
opt.rho    = params;
opt.measure = measure;
opt.alpha.Value  = 1;
opt.lambda.Value = .001; % .1 if N = 256
opt.iteration    = 1;
opt.tol          = 1;
opt.origin = signal;
opt.measure = measure;

% lam - regularization parameter
% Nit - number of iterations
% lam = 500;
% Nit = 20;
% recovered_signal2=  TVD_mm(recovered_signal, lam, Nit);
% recovered_signal2(measure) = signal(measure);

%% Sparsity = 0.125

recovered_signal = reconst(measurement, m, opt);
recovered_signal(measure) = signal(measure);

% B = input('Enter a number of figure');
% figure(B);
figure(4);
plot(signal(119489:120000)); hold on; plot(recovered_signal(119489:120000)); 
title('Sparsity = 0.125, L1 minimization');hold off;
RMSE(1) = norm(signal(119489:120000)-recovered_signal(119489:120000))/norm(signal(119489:120000));
%% 