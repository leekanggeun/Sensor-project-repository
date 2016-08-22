function result = recov(measurement, m, opt)
    N = size(measurement,1);
    gR = gpuArray(measurement);
    gm = gpuArray(m);
    gx = gpuArray.zeros(N,1);
    gy = gpuArray.zeros(N,1);
    gu = gpuArray.zeros(N,1);
    gt = gpuArray.zeros(N,1);
    gxprev = gpuArray.zeros(N,1);
%    galpha = gpuArray(opt.alpha.Value);
    glambda = gpuArray(opt.lambda.Value);
    gtol = gpuArray(opt.tol);
    n_iterator = opt.iteration;
    err = [];
    signal = opt.origin;
    k = 1;
    b = [2;
           2;
           4;
           8;
          16;
          32;
          64;
         128;
         256;
         512;
        1024;
        2048;
        4096;
        8192;
       16384;
       32768;
       65536;
];
    while  (norm(gx - gxprev) > gtol || k == 1)
        for i = 1:n_iterator
            % x updates
            gxprev = gx;
            if(opt.A == 1)
                gt = ifft(gy-gu);
            end
            if(opt.A == 2)
                gt = idct(gy-gu);
            end
            if(opt.A == 3)
                t  = gather(gy-gu);
                gt = waverec(t, b, 'Haar');
            end
            if(opt.A == 4)
                gt = waveletcdf97(gy-gu,-15);
            end
            gx = solvedbi_sm(gR, glambda, gR.*gm + glambda*gt);
            gx(opt.measure) = opt.origin(opt.measure);
            figure(12); plot(opt.origin(119489:120000)); hold on; plot(real(gx(119489:120000))); stem(m(119489:120000)); hold off; drawnow;
            % y updates
            if(opt.A == 1)
                gt = fft(gx)+gu;
            end
            if(opt.A == 2)
                gt = dct(gx)+gu;
            end
            if(opt.A == 3)
                e = wavedec(gx,15,'Haar');
                e = e(1:N);
                gt = e+gu;
            end
            if(opt.A == 4)
               gt = waveletcdf97(gx,15)+gu; 
            end
            gy = wthresh(gt, 's', 1/glambda);
            err(k) = gather(norm(gR.*real(gy) - gm));
            figure(11); plot(err); drawnow;
            k = k+1;
        end
        if(opt.A == 1)
            gt = fft(gx)-gy;
        end
        if(opt.A == 2)
            gt = dct(gx)-gy;
        end
        if(opt.A == 3)
            e = wavedec(gx,15,'Haar');
            gt = e - gy;
        end
        if(opt.A == 4)
            gt = waveletcdf97(gx,15)-gy;
        end
        % u updates
        gu = gu + gt;
        norm(gx - gxprev)
    end
    gx(gx<0) = 0;
    result = gather(real(gx));
return;
