%% INPE - Rocket Design %%
%  Previs�o de desempenho   %
%  Respons�vel: Nicollas Alexandre V. F. Pereira
%  Criado em: 20-10-2016



%% Parametros de entrada
% - foguete considerado
load('cur_thrust.mat','Fs','ts')
%%  Hibrido ~10km~ Quimera 

mp=moxg+mgraos; %massa de propelente (kg)
ms=(0.75+2.3+0.5)*1.1; % massa da estrutura do motor (kg)
mtot=ms+mp+5+10; %massa total do foguete (kg)
ch_isp=215; %impulso espec�fico estimado (s)

% tb=ch_isp*9.80655*mp/t_med;    %f=isp*g*(mdot)-> (mp/tb)
dmaxmm= 75; % diametro maximo da fuselagem (mm)
inc=2;%inclina��o em rela��o � vertical do lan�amento (graus)

%%
%%
dmax=dmaxmm/1000; %convers�o pra metros (m)
area=pi()*dmax^2/4; %area em m^2
cd=0.60; % coeficiente de arrasto estimado
cda=cd*area; %parametro CdA
%inc=5;%inclina��o em rela��o � vertical do lan�amento (graus)
theta(1)=90-inc; % complementar do angulo de inclinacao
%% Constantes
g=9.80665; %m/s^2
h_base=5; %altitude em rela��o ao nivel do mar da base de lan�amento
%% pre-calculo
h(1)=h_base; %altitude no instante inicial
vv(1)=0 ; % velocidade vertical no instante inicial
vh(1)=0;  %velocidade horizontal no instante inicial
v(1)=0; %velocidade total incial
d(1)=0; %dist�cia horizontal em rela��o a base de lan�amento
m(1)=mtot; %massa inicial
load('cur_thrust.mat','Fs','ts')
thrust(1)=Fs(1); % empuxo inicial
tb=ts(end);
%% parametros do programa
dt=0.005; %passo do programa
i=1;
j=1;
k=1;
t(1)=0;
t_total=500; %tempo de simula��o
soma1=zeros(10,1);
%% Calculos

while t(i)<t_total && h(i)>=h_base
##    [T(i), a, ~, rho(i)] = atmosisa(h(i)); %propriedades da atmosfera

##    drag(i)=0.5*rho(i)*(vv(i)^2+vh(i)^2)*cda; %calculo de arrasto
    drag(i)=0.5*1.0*(vv(i)^2+vh(i)^2)*cda; %calculo de arrasto
    acc_v(i)=(-m(i)*g +(-drag(i)+thrust(i))*sind(theta(i)))/(m(i)); %acelera��o vertical
    acc_h(i)=((-drag(i)+thrust(i))*cosd(theta(i)))/(m(i)); %acelera��o horizontal
    del_v(i)=acc_v(i)*dt; %integra��o numerica da acelera��o
    del_h(i)=acc_h(i)*dt; %integra��o numerica da acelera��o
    vv(i+1)=vv(i)+del_v(i); %calculo da velocidade vertical
    vh(i+1)=vh(i)+del_h(i); %calculo da velocidade horizontal
    v(i+1)=sqrt(vv(i+1)^2+vh(i+1)^2); %velocidade total
    h(i+1)=h(i)+vv(i+1)*dt; %calculo de altitude
    d(i+1)=d(i)+vh(i+1)*dt; %calculo de deslocamento horizontal
    if t(i)<tb          %funcionamento do motor 1o estagio
        m(i+1)=m(1)-t(i)*(mp)/tb; %decrescimo linear de massa

        thrust(i+1)=interp1(ts,Fs,t(i));
    else
        m(i+1)=m(1)-mp;
        thrust(i+1)=0;
    end
    theta(i+1)=+atand(vv(i+1)/vh(i+1)); %foguete se alinhando com o escoamento
    
%     theta(i+1)=(+atand(vv(i+1)/vh(i+1))+theta(i))/2; %foguete se alinhando com o escoamento
    
##    v_sound(i)=331.3+0.606*(T(i)-273.15); %velocidade do som na altitude do foguete
##    mach(i)=v(i)/v_sound(i); %n mach local
    t(i+1)=t(i)+dt; %avanco no tempo
   %% parte em construcao
    
##    if vv(i)>0
##        if mach(i)<0.1 && mach(i)>0
##            soma1(1)=soma1(1)+1;
##        else
##            if mach(i)<0.2 && mach(i)>0.1
##            soma1(2)=soma1(2)+1;
##            else
##                if mach(i)<0.3 && mach(i)>0.2
##            soma1(3)=soma1(3)+1;
##                else
##                    if mach(i)<0.4 && mach(i)>0.3
##            soma1(4)=soma1(4)+1;
##                    else
##                        if mach(i)<0.5 && mach(i)>0.4
##            soma1(5)=soma1(5)+1;
##                        else
##                            if mach(i)<0.6 && mach(i)>0.5
##            soma1(6)=soma1(6)+1;
##            else
##                            if mach(i)<0.7 && mach(i)>0.6
##            soma1(7)=soma1(7)+1;
##            else
##                            if mach(i)<0.8 && mach(i)>0.7
##            soma1(8)=soma1(8)+1;
##            else
##                            if mach(i)<0.9 && mach(i)>0.8
##            soma1(9)=soma1(9)+1;
##            else
##                            if mach(i)<1.0 && mach(i)>0.9
##            soma1(10)=soma1(10)+1;
##                            end
##                            end
##                            end
##                            end
##                            end
##                        end
##                    end
##                end
##            end
##        end
##    end
     i=i+1; %avanco na itera��o
end
h_voo=h-h(1); %altitude AGL
drag(i)=drag(i-1); %detalhes para plotar gr�ficos
acc_v(i)=acc_v(i-1); %detalhes para plotar gr�ficos
acc_h(i)=acc_h(i-1); %detalhes para plotar gr�ficos
acc=(acc_v.^2+acc_h.^2).^(1/2); %detalhes para plotar gr�ficos
%% Resultados

if t(i)>t_total
    display('**--------------------------------------**')
    display('-WARNING - PLEASE INCREASE SIMULATION TIME-')
    display('**--------------------------------------**')
end
[hmax, imax]=max(h);
tmax=t(imax);
vmax=max(v);
##machmax=max(mach);
maxacc=max(acc)/g;
maxdrag=max(drag);
Gamma=mtot/(mtot-mp); %calculo do Gamma do foguete
seff=1-1/Gamma;  %eficiencia estrutural - valor 0-1
isp=tmax/log(Gamma); % Calculo de isp
##display('-----   INPE -- Rocket Design    -----')
##display('---       An�lise preliminar       ---')
##display('--------------------------------------')
display('---      Desempenho bal�stico      ---')
display('--------------------------------------')
display('Par�metros')
fprintf('\nMassa inicial do foguete: %.1f kg \n', m(1))
fprintf('Massa de combust�vel: %.1f kg \n', mp)

fprintf('Di�metro m�ximo: %.1f mm \n', dmaxmm)
fprintf('Empuxo: %.1f N \n', thrust(1))
fprintf('Empuxo: %.1f kgf \n', thrust(1)/g)
fprintf('Tempo de queima: %.2f s \n', tb)
fprintf('Impulso total: %.2f N.s \n', thrust(1)*tb )
fprintf('�ngulo de inclina��o no lan�amento: %.1f � \n\n', inc)
display('Desempenho')
fprintf('\nAltitude m�xima: %.f metros \n', hmax-h_base)
fprintf('Alcance m�ximo: %.f metros \n', d(i))
fprintf('Velocidade m�xima: %.f m/s \n', vmax)
##fprintf('Mach m�x: %.2f  \n', machmax)
fprintf('Tempo at� o apogeu: %.2f s \n', tmax)
fprintf('Tempo balist�co: %.2f s \n', t(i))
fprintf('Impulso espec�fico: %.1f s \n\n', isp)
display('Esfor�os')
fprintf('\nAcelera��o m�xima: %.1f g \n', maxacc)
fprintf('Arrasto m�ximo: %.1f N \n', maxdrag)

%% Graficos
while j==1
    type(k) = menu('Selecione os gr�ficos que deseja ver:','Desempenho',...
        'Esfor�os','Trajet�ria','Gerar gr�ficos');
if type(k)==4
    j=0;
end
    k=k+1;
end
a1=find(type==1);
if a1>0
    figure('Name','Desempenho','NumberTitle','on')
    subplot(2,1,1)
        plot(t,h_voo,'b','LineWidth',1.5)
        title('Altitude de voo')
        xlabel('t (s)')
        ylabel('H (m)')
        grid on
    subplot(2,1,2)
        plot(t,v,'r','LineWidth',1.5)
        title('Velocidade')
        xlabel('t (s)')
        ylabel('V (m/s)')
        grid on
        
end
    a2=find(type==2);
if a2>0
    figure('Name','Esfor�os','NumberTitle','on')
    subplot(2,1,1)
        plot(t,acc_v,'b','LineWidth',1.5)
        grid on
        title('Acelera��o vertical')
        xlabel('t (s)')
        ylabel('a_v (m/s^2)')
    subplot(2,1,2)
        plot(t,drag,'r','LineWidth',1.5)
        title('Arrasto')
        xlabel('t (s)')
        ylabel('D (N)')
        grid on
end
    a3=find(type==3);
if a3>0
    figure('Name','Trajet�ria','NumberTitle','on')
    plot(d,h_voo,'b','LineWidth',1.5)
    title('Trajet�ria')
    xlabel('Dist�ncia (m)')
    ylabel('Altitude (m)')
    grid on
    axis equal
    
end

