%% INPE - Rocket Design %%
%  Projeto de motoriza��o   %
%  Respons�vel: Nicollas Alexandre V. F. Pereira
%  Criado em: 20-10-2016
clear
close all
clc
%% Par�metros de entrada
g=9.80665;

%motor
dgrao=55/1000;            %diametro do grao combustivel
d_port=20/1000;
egrao=(dgrao-d_port)/2;
hgrao=125/1000;
ngrao=2;
moxt=8.5;              %quantidade de oxidante no tanque
F=1000;
% Pa (730 psi)
% Pc=3447378; %Pa (500 psi)
Pc=25e5;                %35bar
Pinj=50e5;              %50bar
rhoox= 670;             %kg/m^3 %0.67 specific gravity
rhowax=1050;             %kg/m^3

d_port_0=d_port;
%propelente
OF=4;                   %valor inicial
OFr=OF;
c_star=inter_cstar_a(OFr);

% %regress�o
% a=0.472;
% n=0.555;
a=0.48;
n=0.45;


%% C�lculos geometrias
%propelente

ve=inter_pa(OF);        %estima v_exaustao pela raz�o OF dada

m_dot=F/ve;             %calcula a vaz�o m�ssica necess�ria

mf=m_dot/(OF+1);        %mdot combust�vel
mox=m_dot-mf;           %mdot oxidante 

%inje��o                %calcula os par�metros de inje��o

cd=0.5;   
N_inj=1;

A_inj=mox/(cd*N_inj*sqrt(2*rhoox*(Pinj-Pc)));       %�rea total de inje��o

d4f=sqrt(4/pi*A_inj/4); %di�metros para 4 injetores
d8f=sqrt(4/pi*A_inj/8); %di�metros para 8 injetores

%garganta
At=m_dot*c_star/(Pc);
Dt=sqrt(4/pi*At);       %di�metros para garganta


%% simula��o
t=0;
moxg=0;
mfg=0;
dt=0.05;
rsum=0;
i=1;
Itot=0;

while rsum<=egrao && moxg<=moxt   %condi��o de parada - toda parafina � consumida

mox=A_inj*(cd*N_inj*sqrt(2*rhoox*(Pinj-Pc)));
%% daqui
a_port=pi*d_port^2/4;
Gox=mox/a_port;
Goxgcms=Gox*1000/(100^2);
rmm=a*Goxgcms^n;
r=rmm/1000;

% if t<1
%     af=d_port*pi*ngrao*hgrao*0.80;
% else
    af=d_port*pi*ngrao*hgrao;
% end

% af=areaqueima(t,dex,dp,mox);

mf=af*(1*r*rhowax);
%% ate aqui
if 1==0     % OF constante
mox=OF*mf;
ve=inter_pa(OF);
mdot=mf+mox;
F=ve*mdot;
isp=ve/g;
cstar2(i)=inter_cstar_a(OF);
else        % mox constante
   OFr=mox/mf;
ve=inter_pa(OFr);
mdot=mf+mox;
F=ve*mdot;
isp=ve/g;
cstar2(i)=inter_cstar_a(OFr); 
end
Fs(i)=F;
Ves(i)=ve;
mfs(i)=mf;
OFrs(i)=OFr;
moxs(i)=mox;
rsums(i)=rsum;
Goxs(i)=Gox;
rs(i)=r;
ts(i)=t;
i=i+1;
t=t+dt;
rsum=rsum+r*dt;
moxg=moxg+mox*dt;
mfg=mfg+mf*dt;
d_port=d_port+2*r*dt;
Itot=Itot+F*dt;
end
isps=Ves/g;
cfs=Ves./cstar2;
clc

figure(1)
subplot(2,3,1)
plot(ts,OFrs,'b','LineWidth',1.5)
title('O/F')
xlabel('tempo (s)')
ylabel('O/F')
grid minor

% figure(2)
subplot(2,3,2)
plot(ts,Fs,'b','LineWidth',1.5)
title('Curva de empuxo')
grid minor
xlabel('tempo (s)')
ylabel('Empuxo (N)')

save('cur_thrust.mat','Fs','ts')


% figure(3)
subplot(2,3,3)
plot(ts,rs*1000,'b','LineWidth',1.5)
title('Taxa de regress�o')
grid minor
xlabel('tempo (s)')
ylabel('Taxa de regress�o (mm/s)')
% figure(3)
% 
subplot(2,3,4)
plot(ts,Goxs,'b','LineWidth',1.5)
title('GOx')
grid minor
xlabel('tempo (s)')
ylabel('Unidades SI')

% figure(2)
subplot(2,3,5)
plot(ts,mfs*1000,'b','LineWidth',1.5)
title('Vaz�o m�ssica - Parafina')
grid minor
xlabel('tempo (s)')
ylabel('Vaz�o m�ssica combust�vel (g/s)')

subplot(2,3,6)
plot(ts,(egrao-rsums)*1000,'b','LineWidth',1.5)
title('Espessura do gr�o')
grid minor
xlabel('tempo (s)')
ylabel('Espessura do gr�o (mm)')

##display('-----   INPE -- Rocket Design    -----')
##display('---       An�lise preliminar       ---')
##display('--------------------------------------')
display('---          Motoriza��o           ---')
display('--------------------------------------')

fprintf('\nImpulso total: %.0f N.s \n', Itot)
Fmedio=Itot/t;

fprintf('Impulso espec�fico: %.1f s\n', isps(i-1))

fprintf('Empuxo m�dio: %.2f N \n', Fmedio)

fprintf('Tempo de queima: %.2f s \n\n', t)

fprintf('Diametro da garganta: %.2f mm \n', Dt*1000)

fprintf('Diametro do gr�o: %.0f mm \n', dgrao*1000)

fprintf('Diametro do furo: %.0f mm \n', d_port_0*1000)

mgraos=pi*((dgrao)^2-d_port_0^2)/4*rhowax*ngrao*hgrao;

fprintf('Massa de combust�vel: %.0f g \n', mgraos*1000)

fprintf('Massa de res�duo: %.0f g \n\n', (mgraos-mfg)*1000)


fprintf('Diametros dos injetores (4): %.3f mm \n', d4f*1000)

fprintf('Diametros dos injetores (8): %.3f mm \n\n', d8f*1000)

fprintf('Vaz�o m�ssica oxidante: %.2f g/s \n', mox*1000)

fprintf('Massa total de oxidante: %.2f g \n\n', moxg*1000)

save('masses.m','mgraos','moxg')

figure(1)
k=1;
type(k) = menu('Deseja simular o desempenho?','Sim',...
        'N�o');
    if type==1
        run desempenho_foguete_balistico_octavio.m
    end