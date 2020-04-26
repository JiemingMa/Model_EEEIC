function [f] = pvmodetestII(data, env, para, x)

V = data(:, 1);
II = data(:, 2);
Rs = x(1);
Rp = x(2);
a = x(3);
Vd = x(4);


D = env(1, :);
N = env(2, :);
T = env(3, :);
B = env(4, :);
NB = env(5, :);

Iscn = para(1); %Nominal short-circuit voltage [A]
Ki = para(2); %Current/temperature coefficient [A/K]
Tn = 25;
deltaT = T - Tn;

Gn = 1000;
Ipvn =  Iscn; % Nominal light-generated current
Ipv = (Ipvn + Ki * deltaT) .* D / Gn; % Actual light-generated curre
alpha = II(1) / Ipv(1);
Ipv = alpha * Ipv;
Ipv = [Ipv 0];
q = 1.602176 * 10^(-19);
k = 1.380650 * 10^(-23);
Nd = length(N);
Vt = k * T / q;

Vstep = 0.1;
Vtpa = zeros(1, Nd);
Vtpb = zeros(1, Nd);
Vtpsum1 = 0;
Vtpsum2 = 0;
for i = 2: Nd
    Vtp(i - 1) = Vmodel(para, x, alpha, Ipv(i), D(i - 1), T(i - 1), N(i - 1));
    VN(i - 1) = floor(Vtp(i - 1) / Vstep);
    Vtpsum1 = Vtpsum1 + Vtp(i - 1);
    Vtpsum2 = Vtpsum2 + Vtp(i - 1) + B(i - 1) * Vd;
    Vtpa(i - 1) = Vtpsum1;
    Vtpb(i - 1) = Vtpsum2;
    if i == Nd
        Vtp(i) = Vmodel(para, x, alpha, 0, D(i), T(i), N(i));
        VN(i) = floor(Vtp(i) / Vstep);
        Vtpsum1 = Vtpsum1 + Vtp(i);
        Vtpsum2 = Vtpsum2 + Vtp(i);
        Vtpa(i) = Vtpsum1;
        Vtpb(i) = Vtpsum2;
    end
end

Vtpa = [0 Vtpa];
Vtpb = [0 Vtpb];
Vtp = [0 Vtp];

Nsize = length(data);
for  j = 1 : Nsize
    s = 0;
    I(j) = 0;
    for i = 1 : Nd
        if s == 0 && (V(j) >= Vtpb(i)) &&  (V(j) < Vtpb(i + 1))
            if (V(j) >= Vtpb(i)) && (V(j) < Vtpa(i + 1))
                I(j) = Imodel(para, x, alpha, V(j) - Vtpb(i), D(i), T(i), N(i));
                s = 1;
            elseif (V(j) >= Vtpa(i + 1)) && (V(j) < Vtpb(i + 1))
                if NB(i) ~= 0
                    I(j) = Ipv(i+1);
                    s = 1;
                else
                    I(j) = Imodel(para, x, alpha, V(j) - Vtpb(i), D(i), T(i), N(i));
                    s = 1;
                end
            end
        end 
    end
end
I=I';
f=sqrt(sum((I-II).^2)/Nsize);
end