function psnr1 = experiment(img, n,K, h, L, M, DIM1, DIM2, noise, lambda, sensingMatrixCase,measurementVector, optiAlgoCase)
    img_recon = zeros(size(img));
    N = n^2;
    
    
    for i = 1:n:DIM1
        for j = 1:n:DIM2
            patch = img(i:i+n-1,j:j+n-1);
            patch = patch(:);

            switch sensingMatrixCase
                case 'gaussian' 
                    Phi = randn(M,N);
                    matrixNorm = Phi.'*Phi;
                    matrixNorm = sqrt(diag(matrixNorm)).';
                    Phi = Phi./repmat(matrixNorm, [M,1]);

                case 'subsampling'
                    D = dctmtx(N);
                    iD = D^-1;
                    perm = randperm(N);
                    Phi = iD(perm(1:M),:);
            end

            switch measurementVector
                case 'dct' 
                    y = Phi*dct(patch); %dct
                case 'dwt'
                    y = Phi*mdwt(patch,h,L); %dwt
                case 'identity'
                   % y = y;
            end
            y = y + randn(size(y))*noise;

            switch optiAlgoCase
                case 'OMP'
                    alpha = OMP(y, Phi, K);
                case 'SP'
                    alpha = SP(y,Phi,K);
                case 'ALM'
                    alpha = ALM(Phi,y);
                case 'GPSR'
                    [alpha,~,~,~,~,~] = GPSR_Basic(y,Phi,lambda);    
            end
            
            
            switch measurementVector
                case 'dct' 
                    patch_recon = reshape(idct(alpha),n,n); % idct
                case 'dwt'
                    patch_recon = reshape(midwt(alpha,h,L),n,n); % idwt
            end
            img_recon(i:i+n-1,j:j+n-1) = patch_recon;
        end
    end
    % figure;imshow(img,[]);
    % figure;imshow(img_recon,[]);
    
    psnr1 = psnr(img, img_recon);
end