function W=PCA2DL1S(x,lam,nPV)
% Calculate the 2DPCAL1-S components.

s=1; % set s as 1 since the script is adopted from GPCA

x0=x;
[~,d,n]=size(x);

% initialization by the results of 2DPCA
cov=zeros(d);
for i=1:n
    cov=cov+x(:,:,i)'*x(:,:,i);
end
[V,D]=eig(cov);
[~,indx]=sort(diag(D),'descend');
V=V(:,indx);
W0=V;

% calculate multiple projection vectors
W=zeros(d,nPV);
for iPV=1:nPV
    w=W0(:,iPV);
    
    % the value of objective function
    f=0;
    for i=1:n
        f=f+pnorm(x(:,:,i)*w,s)^s;
    end
    
    rsd=1;
    while rsd>1e-4
        fp=f;
        
        % a key vector in G2DPCA problem
        v=zeros(d,1);
        for i=1:n
            z=x(:,:,i);
            v=v+z'*(abs(z*w).^(s-1).*sign(z*w));
        end
        
        % update rule
        w=v.*abs(w)./(lam+abs(w));
        w=w/norm(w);
        
        % the value of objective function
        f=0;
        for i=1:n
            f=f+pnorm(x(:,:,i)*w,s)^s;
        end
        rsd=abs(f-fp)/fp;
    end
    
    W(:,iPV)=w;
    
    % deflation
    for i=1:n
        x(:,:,i)=x0(:,:,i)*(eye(d)-W*W');
    end
end