function y=pnorm(x,p)
% Lp-norm
% x, a vector
% p, a scalar

if p==0
    y=sum(x~=0);
elseif p==Inf
    y=max(abs(x));
else
    y=sum(abs(x).^p)^(1/p);
end