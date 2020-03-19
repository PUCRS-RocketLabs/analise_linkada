
%% para valores de P = 25 bar ABS+N2O
function cstar = inter_cstar_a (OFr)
OFp=[1 2 3 4 5 6 7 8 9 10];

cstar=[1244.1, 1388.6, 1490.3, 1562.9, 1575.3, 1560.8, 1540.2, 1519.8, 1500.9, 1483.6 ];

cstar_real= interp1(OFp ,cstar, OFr);

cstar=cstar_real;

end