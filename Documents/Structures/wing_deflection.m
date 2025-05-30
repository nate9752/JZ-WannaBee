% Simple algorithm to calculate the deflection, bending moment, shear force in a
% cantilever beam.
% Using the load distribution from  XFLR5 for Telemaser
% load = loading distribution
    
clear; close all;

% read normalized wing loading 

filename = input('Enter name of file: ', 's');

[x,load]=textread(filename,'%f %f');
ei=1.;
l=1;
dl=.01;
x_uniform=0:dl:l;
load_uniform=interp1(x,load,x_uniform);

[deflection,moment,shear]=beam_deflection(load_uniform,ei,l,dl);

total_load = sum(load_uniform)*dl;


figure
plot(x_uniform,moment,'LineWidth',4)
hold on
plot(x_uniform,shear,'r','LineWidth',4)
set(gca,'fontsize',20)
legend('bending moment','shear force')
xlabel('length along the beam','FontSize',20)
ylabel(' bending moment and shear force (SI units)','FontSize',20)
grid
hold off
figure,plot(x_uniform,deflection,'r','LineWidth',4)
set(gca,'fontsize',20)
xlabel('length along the beam','FontSize',20)
ylabel('deflection')
grid
title('Deflection','FontSize',20)

figure
plot(x,load,x_uniform,load_uniform,'LineWidth',4)
set(gca,'fontsize',20)
xlabel('length along the beam,','FontSize',20)
ylabel('load','FontSize',20)
grid
title('load','FontSize',20)
