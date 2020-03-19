
%% para valores de P = 25 bar  ABS + N2O
function ve = inter_pa (OFr)
OFp=[1 2 3 4 5 6 7 8 9 10];

ve=[1789.0, 1920.2, 2114.9, 2228.0, 2250.9, 2232.3, 2203.7, 2174.8, 2147.8, 2122.9 ];

ve_real= interp1(OFp ,ve, OFr);

ve=ve_real;

end