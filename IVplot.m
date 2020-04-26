%% Example. I-V curves
% Author: Jieming Ma
% Xi'an Jiaotong-Liverpool University - 2020
% jieming84@gmail.com

% If you like my work please cite my papers:

% J. Ma, K. Wang, K.L. Man, H.-N. Liang, X. Pan, 
% "An Analytical Model for a Photovoltaic Module Under Partial Shading Conditions", 
% the 20th annual conference of the International Conference on Environmental and Electrical Engineering
% accepted,2020.

clear
clc
%% Load experimental data
load IV_SPM045P
plot(iv(:, 1), iv(:, 2),'o');
hold on


load env  %Load environmental data
load SPM045P %Load PV technical data
load para %Load parameters


%% Plot I-V curve
V = iv(:, 1);
I=zeros(length(V));

for i = 1 : length(V)
    I(i) = CompleteModel(tech, para, env, V(i), iv);
end

plot(V, I);
%% Caculate RMSE
f = sqrt(sum((I' - iv(:, 2)) .^ 2) / length(iv));


