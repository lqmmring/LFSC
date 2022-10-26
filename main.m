clear;clc;

%% inpute scRNA-seq datasets
x=csvread('Data_Kolod-1000.csv',1,1);
Y= csvread('Data_Kolod-cluster.csv',1,0);
ns=length(unique(Y));
clist=unique(Y);
for i= 1:ns
    Y(find(Y==clist(i)))=i;
end

rng(5489,'twister');
for i=1:ns
    index=find(Y==i);
    sx(:,i) = mean(x(:,index),2);
    label(i,:)=i;
end

%% run scASBGWW
alpha=[.1 1 10 50 100];
beta=[1e-4 1e-3 1e-2 .1 1 10 50 100]; %, .1 1 10 50 100];

% alpha=[10 50 100];
% beta=[1e-4 1e-3 1e-2 .1 1 10 50 100]; %, .1 1 10 50 100];
%% ï¿½ï¿½à¶?
for i=1:length(alpha)
    rng(5489,'twister');
    for m=1:length(beta)
        fprintf('\talpha=%f\tbeta:%f\n',alpha(i), beta(m));
        tic;
        [F,U,predict,result]=scASBG(x,sx,Y,label,alpha(i),beta(m));% result: ACC, NMI, Purity
        t=toc;
        fprintf('result(ACC NMI Purity ARI):\t%12.6f %12.6f %12.6f %12.6f %12.6f\n',[result t]);
        dlmwrite('Marques-1000.txt',[alpha(i) beta(m) result t],'-append','delimiter','\t','newline','pc');
    end
end