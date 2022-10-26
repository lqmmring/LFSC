function [F,U,actual_ids,result]=scASBG(K,A,s,label,alpha,beta)
% s is the true class label.
% K=x;
% A=sx;
% s=Y;
% label=label;
% alpha=alpha(i);
% beta=beta(m);

[~,n]=size(K);
[~,m]=size(A);
Z=ones(n,m)/m;
c=length(unique(s));
W=zeros(n,m);
Vold=labelmatrix(label,c);
options = optimset( 'Algorithm','interior-point-convex','Display','off');
% options = optimset( 'Algorithm','trust-region-reflective','Display','off');
% options = optimset( 'Algorithm','active-set','Display','off');


for i=1:100
    Zold=Z;
    D1=(sum(Z')).^(-1/2);
    D2=(sum(Z)).^(-1/2);
    D=[D1,D2];
%     [~,U,V,~,~,~,]=svd2uv(Z, c);
%     F=[U;V]; %�޼ල
    [~,U,~,~,~,~,]=svd2uv(Z, c);
    F=[U;Vold];%��ල
   for ij=1:n
        for ji=1:m
            W(ij,ji)=(norm((F(ij,:)*D(ij)-F(n+ji,:)*D(n+ji)),'fro'))^2;
        end   
   end
   H=2*alpha*eye(m)+2*A'*A;
   H=(H+H')/2;
   parfor ij=1:n
        ff=beta*W(ij,:)-2*(K(:,ij))'*A;
        Z(ij,:)=quadprog(H,ff',[],[],ones(1,m),1,zeros(m,1),ones(m,1),Z(ij,:),options);
   end
    
    if i>5 &&((norm(Z-Zold)/norm(Zold))<1e-3)
        break
    end
end
 rng(5489,'twister');
actual_ids= litekmeans(U,c,'MaxIter', 100,'Replicates',100);%�޼ල
% [~,actual_ids]=max(abs(U),[],2);
% [~,actual_ids]=max(U,[],2);
[result] = ClusteringMeasure(s,actual_ids);
