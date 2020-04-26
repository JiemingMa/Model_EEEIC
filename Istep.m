%% Calculating short-circuit current for each step
% Author: Jieming Ma
% Xi'an Jiaotong-Liverpool University - 2020
% jieming84@gmail.com

% If you like my work please cite my papers:

% J. Ma, K. Wang, K.L. Man, H.-N. Liang, X. Pan, 
% "An Analytical Model for a Photovoltaic Module Under Partial Shading Conditions", 
% the 20th annual conference of the International Conference on Environmental and Electrical Engineering
% accepted,2020.

function Ipv=Istep(para,env)
D  = env(1, :); %irradiance [W/m2]
N = env(2, :); 
T = env(3, :); 
NB = env(5, :);
Iscn = para(1);
Ki = para(2);

Tn = 25;
deltaT = T - Tn;

Gn = 1000;
Ipvn = Iscn;  % Nominal light-generated current
Ipv = (Ipvn + Ki * deltaT) .* D / Gn;       % Actual light-generated curre


Ipv = [Ipv 0];