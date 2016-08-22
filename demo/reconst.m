function result = reconst(measurement, m, opt)
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
    n = N;
    k=1;
    while  (norm(gx - gxprev) > gtol || k == 1)
        for i = 1:n_iterator
            % x updates
            gxprev = gx;
            gx = solvedbi_sm(gR, glambda, gR.*gm + glambda*ifft(gy-gu));
            gx(opt.measure) = opt.origin(opt.measure);
            figure(12); plot(opt.origin(119489:120000)); hold on; plot(real(gx(119489:120000))); stem(m(119489:120000)); hold off; drawnow;
            % y updates
            gy = wthresh(fft(gx)+gu, 's', 1/glambda);
            err(k) = gather(norm(gR.*real(gy) - gm));
            figure(11); plot(err); drawnow;
            k = k+1;
        end
        % u updates
        gu = gu + fft(gx)-gy;
        norm(gx - gxprev)
    end
    gx(gx<0) = 0;
    result = gather(real(gx));
return;