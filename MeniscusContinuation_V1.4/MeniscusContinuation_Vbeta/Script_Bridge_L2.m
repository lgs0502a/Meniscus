% construction de la courbe P/V pour un pont
% (adimensionalisation par le rayon)

% CAS L=2, SANS GRAVITE

global Bo RR dpdz alphac Weta Wxi verbosity beta discretization nbdim Vref;


L = 2;

RR = 1;
dpdz = 0;
Weta = 1;
Wxi = 1;
verbosity = 0;
close all;
beta = -1;
discretization = 'FD';
nbdim = 3;
Vref = pi*L;





% solution limite theorique : deux portions de sphere de rayon Rc tel que
% Rc^2 = R^2 + (Rc-L/2)^2 
F = @(x)(x^2-1-(x-L/2)^2);
Rc = fzero(F,1.5)
%  Rc = 1
Kl = 2/Rc;
Vl = 2*pi/3*(L/2)^2*(3*Rc-L/2);% formule volume d'une calotte spherique
figure(21);
plot(Kl,Vl/Vref,'go','MarkerSize',10);
hold on;
% geometrie initiale : pont cylindrique
t = [0:.005:1];
R0 = RR*ones(size(t));
Z0 = L*t;

R = R0;
Z = Z0;
P = 1;
V = 1; 
[R,Z,P,V] = Newton_P(R0,Z0,P,V,1);
figure(10);
hold on;
plot(R,Z,'r');
figure(21);
plot(P,V/Vref,'ro','MarkerSize',10);

% continuation en diminuant P 
[R,Z,P,V] = Loop_P(R,Z,P,V,-.02,5);
[R,Z,P,V] = Loop_P(R,Z,P,V,-.02,5);


% au passage on attrape la solution d'equilibre final 
% (volume = celui des deux portions de spheres)
[Rf,Zf,Pf,Vf] = Newton_V(R,Z,P,V,Vl);
figure(21);
plot(Pf,Vf/Vref,'go','MarkerSize',10);
figure(10);
plot(Rf,Zf,'g')

% loop V dans le virage
[R,Z,P,V] = Loop_V(R,Z,P,V,-.2,5);
[R,Z,P,V] = Loop_V(R,Z,P,V,-.2,5);

%remonte en P
[R,Z,P,V] = Loop_P(R,Z,P,V,+.1,10);
[R,Z,P,V] = Loop_P(R,Z,P,V,+.1,10);
[R,Z,P,V] = Loop_P(R,Z,P,V,+.1,10);
[R,Z,P,V] = Loop_P(R,Z,P,V,+.02,10);
%[R,Z,P,V] = Loop_P(R,Z,P,V,+.004,10);

%solution limite deux spheres qui se touchent
[Rlim,Zlim,Plim,Vlim] = Newton_P(R,Z,P,V,P);
figure(10);
plot(Rlim,Zlim,'g')

if (1==1) %tentative d'attraper la solution a deux cols pour L=4
[Rlim,Zlim,Plim,Vlim] = Newton_P(Rlim,Zlim,Plim,Vlim,Plim-.004);
Rw = [Rlim,Rlim];
Zw = [Zlim,Zlim+2];
Pw = Plim;
Vw = 2*Vlim;
[R,Z,P,V] = Newton_P(Rw,Zw,Pw,Vw,Pw);
figure(10);
plot(R,Z,'g')

[R,Z,P,V] = Loop_P(R,Z,P,V,-.02,100);

pause;
end

% continuation en montant V 
[R,Z,P,V] = Loop_V(R0,Z0,1,Vref,+.1*Vref,50);
[R,Z,P,V] = Loop_V(R,Z,P,V,Vref*.02,20);



% mise en forme des figures

figure(21);
grid on;
xlabel('P')
ylabel('V')

figure(10);
grid on;
xlabel('R')
ylabel('Z')

figure(31);
grid on;
figure(32);
grid on;



%solution a deux cols pour L=4

Rw = [Rlim,Rlim];
Zw = [Zlim,Zlim+2];
Pw = 2.02;

[R,Z,P,V] = Newton_P(Rw,Zw,Pw,0,Pw);
figure(10);
plot(R,Z,'g')


