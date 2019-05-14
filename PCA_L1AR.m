function [ w ] = PCA_L1AR( data,lambda)

    x = data';
    [~,d,n]=size(data);
    [x_size1,x_size2] = size(data);
    % initialization by the results of PCA
    cov=zeros(d);
    for i=1:n
        cov=cov+data(:,:,i)'*data(:,:,i);
    end
    [V,D]=eig(cov);
    [~,indx]=sort(diag(D),'descend');
    V=V(:,indx);
    w0=V;
    
    e = x'*w0;
%     j = transpose(x)*diag(w);
    y1= e;y2 = e;
    
    % initialization
    mu1 = 0.5;mu2 = 0.5;p = 1.5;
    converged = 0;
    w = w0 ;
    while converged ~= 1

        tresh = lambda/mu2;
        A = transpose(x)*diag(w)-(1/mu2*y2);
        if data(x_size2) < 3
            [U,~,~] = svt(A,'lambda',tresh,'m',x_size2,'n',x_size1);
            j = U;
        else
            [~,MO,~] = svd(A);
            j = MO;
        end
        z = transpose(x)*diag(w)-(1/mu1*y1);
        for i=1:size(x,2)
            if z(i) == 0
                e(i) = 1/mu1;
            else
                e(i) = sign(z(i))*(abs(z(i))+ 1/mu1);
            end
        end
        
        w = inv(mu1*(x*x') + mu2*diag(diag(x*x')))*(x*y1+mu1*(x*e)+diag(y2'*x')+mu2*diag(j'*x'));
        if sum(w-w0) < 10^-6
            converged = 1;
        end
        
        w0 = w;
        y1 = y1 + mu1*(e-x'*w);
        y2 = y2 + mu2*(j-x'*diag(w));
        mu1 = p*mu1;
        mu2 = p*mu2;
        
    end
end

