%% PV modeling  - COMPLETE MODEL 

% Author: Jieming Ma
% Xi'an Jiaotong-Liverpool University - 2020
% jieming84@gmail.com

% If you like my work please cite my papers:

% J. Ma, K. Wang, K.L. Man, H.-N. Liang, X. Pan, 
% "An Analytical Model for a Photovoltaic Module Under Partial Shading Conditions", 
% the 20th annual conference of the International Conference on Environmental and Electrical Engineering
% accepted,2020.


function I=CompleteModel(para,x,env,V,iv)

%% Calculating short-circuit current for each step
Ipv=Istep(para,env);

%% Photo-current adjustment
alpha = iv(1, 2) / Ipv(1); %short-circuit current adjustment
% alpha=1;   % No Photo-current adjustment
Ipv = alpha * Ipv; %Adjusted short-circuit current 

%% Determine the location of tuning points
[Vtpa, Vtpb]=TP(para,x,env,alpha,Ipv);

%% PV modeling 
I=PVmodel(para, x, env, Ipv, V,Vtpa, Vtpb,alpha);
