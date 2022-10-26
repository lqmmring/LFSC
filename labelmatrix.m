function [Y] = labelmatrix(y,k)
  m = length(y);
  Y = repmat(y(:),1,k) == repmat(1:k,m,1);