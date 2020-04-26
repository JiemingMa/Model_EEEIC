%% Tuning points
% Author: Jieming Ma
% Xi'an Jiaotong-Liverpool University - 2020
% jieming84@gmail.com

% If you like my work please cite my papers:

% J. Ma, K. Wang, K.L. Man, H.-N. Liang, X. Pan, 
% "An Analytical Model for a Photovoltaic Module Under Partial Shading Conditions", 
% the 20th annual conference of the International Conference on Environmental and Electrical Engineering
% accepted,2020.

function [Vtpa, Vtpb]=TP(para,x,env,alpha,Ipv)
%Load environmental data
D  = env(1, :); %irradiance [W/m2]
N = env(2, :); %
T = env(3, :); %
B = env(4, :);

Vd = x(4);  
Nd = length(N);

Vtpa = zeros(1, Nd);
Vtpb = zeros(1, Nd);
Vtpsum1 = 0;
Vtpsum2 = 0;
for i = 2 : Nd
    Vtp(i - 1) = Vmodel(para, x, env(:,i-1), alpha, Ipv(i));
    Vtpsum1 = Vtpsum1 + Vtp(i - 1);
    Vtpsum2 = Vtpsum2 + Vtp(i - 1) + B(i - 1) * Vd;
    Vtpa(i - 1) = Vtpsum1;
    Vtpb(i - 1) = Vtpsum2;
    if i == Nd
        Vtp(i) = Vmodel(para, x, env(:,i), alpha, 0);
        Vtpsum1 = Vtpsum1 + Vtp(i);
        Vtpsum2 = Vtpsum2 + Vtp(i);
        Vtpa(i) = Vtpsum1;
        Vtpb(i) = Vtpsum2;
    end
end

Vtpa = [0 Vtpa];
Vtpb = [0 Vtpb];
end