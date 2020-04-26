%% PV modeling 
% Author: Jieming Ma
% Xi'an Jiaotong-Liverpool University - 2020
% jieming84@gmail.com

% If you like my work please cite my papers:

% J. Ma, K. Wang, K.L. Man, H.-N. Liang, X. Pan, 
% "An Analytical Model for a Photovoltaic Module Under Partial Shading Conditions", 
% the 20th annual conference of the International Conference on Environmental and Electrical Engineering
% accepted,2020.

function I=PVmodel(para, x, env, Ipv, V,Vtpa, Vtpb,alpha)

D  = env(1, :); %irradiance [W/m2]
N = env(2, :); %Number of substring
T = env(3, :); %
NB = env(5, :);

Nd = length(N);
s = 0;
I = 0;
for i = 1 : Nd
    if s == 0 && (V >= Vtpb(i)) && (V < Vtpb(i + 1))
        if (V >= Vtpb(i)) && (V < Vtpa(i+1))
            I = Imodel(para, x,env(:,i), alpha, V - Vtpb(i));
            s = 1;
        elseif (V >= Vtpa(i + 1)) && (V < Vtpb(i + 1))
            if NB(i) ~= 0
                I = Ipv(i + 1);
                s = 1;
            else
                I = Imodel(para, x, env(:,i),alpha, V - Vtpb(i));
                s = 1;
            end

        end
    end
end