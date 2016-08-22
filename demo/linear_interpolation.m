function result = linear_interpolation(measurement, m, opt)
signal = opt.origin;
N = size(signal,1);
S = m;
result = zeros(N,1);
prevx = 1;
prevy = signal(1,1);
for i = 1:N
    if S(i,1) ~= 0;
        prevy = signal(i,1);
        prevx = i;
        result(i,1) = S(i,1);
    end
    if S(i,1) == 0;
        for j = i:N
            if S(j,1) ~= 0
                nextx = j;
                nexty = S(j,1);
                break;
            end
        end
        if nextx == prevx
            result(i,1) = result(i-1,1);
        end
        if nextx ~= prevx
            result(i,1) =  prevy + (nexty-prevy)*(i-prevx)/(nextx-prevx);
        end
    end
end

return;
% k=0;
% for i=1:N
% if(abs(signal(i,1)-recovered_signal(i,1)) < abs(signal(i,1)-result(i,1)))
% k=k+1;
% end
% end
% k/(N*(1-sparsity))