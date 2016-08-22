clc; clear all; close all; 
%%
gpuDevice(1);
addpath(genpath('.'));
path(path, './toolbox_optim');
%%
rng(2016);
load data4.mat
N =120000;
%% Setting sparsity
sparsity = 0.125;

measure = randperm(N, sparsity.*N);
signal = data4(1:N);
S0 = signal;
N = size(signal,1);

%% Generating undersampled signal
m = zeros([N, 1]);
m(measure) = signal(measure);
measurement = zeros([N, 1]);
measurement(measure) = 1;
m = measurement.*signal;

opt.alpha  = params;
opt.lambda = params;
opt.rho    = params;
opt.measure = measure;
opt.alpha.Value  = 1;
opt.lambda.Value = .001; % .1 if N = 256
opt.rho.Value    = 10;
opt.step = 0.1;
opt.iteration    = 1;
opt.origin = signal;
opt.measure = measure;

% lam - regularization parameter
% Nit - number of iterations
% lam = 500;
% Nit = 20;
% recovered_signal2=  TVD_mm(recovered_signal, lam, Nit);
% recovered_signal2(measure) = signal(measure);

%% Sparsity = 0.125
A = input('Enter a number of transform \n 1. Fourier transform\n 2. Cosine discrete transform \n 3. Haar wavelet transform \n 4. CDF wavelet transform \n 5. 916 wavelet transform \n: ');
opt.A = A;
if(A == 1)
    opt.lambda.Value = .001;
    opt.tol = 7; % 0.05 if N = 256
end
if(A == 2)
    opt.lambda.Value = 1;
    opt.tol = .4;
end
if(A == 3)
    opt.lambda.Value = 30;
    opt.tol = .01;
end
if(A ==4)
    opt.lambda.Value = 100;
    opt.tol = .001;
end

recovered_signal = recov(measurement, m, opt);
recovered_signal(measure) = signal(measure);

B = input('Enter a number of figure');
figure(B);
plot(signal(119489:120000)); hold on; plot(recovered_signal(119489:120000)); 
title('Sparsity = 0.125, L1 minimization');hold off;
RMSE(1) = norm(signal(119489:120000)-recovered_signal(119489:120000))/norm(signal(119489:120000));
%% 

% if(A==1)
%     opt.lambda.Value = .1;
%     opt.tol = 0.01;
% end
% 
% if(A==2)
%     opt.lambda.Value = .1;
%     opt.tol = 0.01;
% end
% if(A == 3)
%     opt.lambda.Value = .01;
%     opt.tol = .1;
% end
% if(A ==4)
%     opt.lambda.Value = .01;
%     opt.tol = .001;
% end
% 
% measurement = measurement(1:256);
% a=1;
% for i = 1:15000
%     if measure(1,i) < 257
%         t(a,1) = measure(1,i);
%         a = a+1;
%     end
% end
% opt.measure = t;
% m = m(1:256);
% opt.origin = signal(1:256);
% 
% recovered_signal2 = recov(measurement, m, opt);
% 
% figure(B+1);
% plot(signal(1:256,1)); hold on; plot(recovered_signal2(1:256,1)); 
% title('Sparsity = 0.125, L1 minimization');hold off;

    