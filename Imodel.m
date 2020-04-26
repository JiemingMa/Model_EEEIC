%% PV Single-Diode Model (Outpput, terminal currrent)
% Author: Jieming Ma
% Xi'an Jiaotong-Liverpool University - 2020
% jieming84@gmail.com

% If you like my work please cite my papers:

% J. Ma, K. Wang, K.L. Man, H.-N. Liang, X. Pan, 
% "An Analytical Model for a Photovoltaic Module Under Partial Shading Conditions", 
% the 20th annual conference of the International Conference on Environmental and Electrical Engineering
% accepted,2020.

function I = Imodel(para, x,env, alpha, V)
G  = env(1); %irradiance [W/m2]
N = env(2); %Number of cells
Ts = env(3); % Temperature [oC]
T = Ts + 273.15;    %Temperature [K]
Rs = x(1); %Series resistor
Rp = x(2); %Shunt resistor
a = x(3); %Idelity factor

%% Sub-string technial data

Iscn = para(1);         %Nominal short-circuit voltage [A]
Vocn = para(3) * N;     %Nominal array open-circuit voltage [V]
Kv = para(4);           %Voltage/temperature coefficient [V/K]
Ki = para(2);           %Current/temperature coefficient [A/K]
Ns = para(5) * N;       %Nunber of series cells
Gn = 1000;              %Nominal irradiance [W/m^2] @ 25oC
Tn = 25 + 273.15;       %Nominal operating temperature [K]

% Constants
k = 1.3806503e-23;   %Boltzmann [J/K]
q = 1.60217646e-19;  %Electron charge [C]

% Thermal voltages
Vt = k * T / q;      %Thermal junction voltage (actual temperature)

% Method of calculating Io

dT = T - Tn;
Isc_ = (Iscn + Ki * dT);
Voc_ = (Vocn + Kv * dT);

Io = Isc_ / (exp(Voc_ / a / Ns / Vt) - 1); %% OLD %%

%  Temperature and irradiation effect on the current
dT = T - Tn;
Ipvn = Iscn;         % Nominal light-generated current
Ipv = (Ipvn + Ki * dT) * G / Gn * alpha;       % Actual light-generated current

% Newton-Raphson algorithm
I = 0;    % Current 

g = Ipv - Io * (exp((V + I * Rs) / Vt / Ns / a) - 1) - (V + I * Rs) / Rp - I;

while (abs(g) > 1e-6)
    g = Ipv - Io * (exp((V + I * Rs) / Vt / Ns / a) - 1) - (V + I * Rs) / Rp - I;
    glin = -Io * Rs / Vt / Ns / a * exp((V + I * Rs) / Vt / Ns / a) - Rs / Rp - 1;
    I_ = I - g / glin;
    I = I_;  
end

%Assume that a block diode is used.
if I < 0
    I = 0;
end

end
