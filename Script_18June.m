clear 
clc
close all
Vdc = 600;
f = 50;
w_nom = 2*pi*f;

V_nom = 220*sqrt(2);
%sample time simulation
Ts = 10e-6;
%LC filter (Il max = 1.1 I nom)
%R_f = 0.1; %L internal resistor
%L_f = 0.0111; %1.35e-3
%C_f = 5.4805e-06; %50e-6

%R_f = 0.1;
%L_f = 1.35e-3*6;
%C_f = 50e-6/13;
u = 0.04;
R_f = 0.1;
L_f = 0.000659829*1.4*u*8;
C_f = 0.000112315*4/u;
%coupling gain
cf = 100;
cv = 100;
%sampling frequency
f_c = 50e3;

lo_co = 0.1; 


droopDivide = 1;
droopDivide2 = 20;
m_p1 = 9.4e-5/droopDivide;
m_p2 = 9.4e-5/droopDivide;
m_p3 = 11.4e-5/droopDivide;
m_p4 = 11.4e-5/droopDivide;
%voltage droop %0.5 kvar, 5%
%n_q1 = 0.02; %Số liệu Bá Linh
n_q1 = 1.3e-3/droopDivide2;
n_q2 = 1.3e-3/droopDivide2;
n_q3 = 1.5e-3/droopDivide2;
n_q4 = 1.5e-3/droopDivide2;

PMW = V_nom/0.4;

w_c_high = 2*pi*49; %cutoff frequency of high pass filter
kL = 1e-7;
LD_ref1 = 50e-6; %virtual L value OLD 50e-6;

L_in1 = 0.35e-3;
R_in1 = 0.03;
L_in2 = 0.35e-3;
R_in2 = 0.03;
L_in3 = 0.35e-3;
R_in3 = 0.03;
L_in4 = 0.35e-3;
R_in4 = 0.03;

%PR controller 
ki_pr =150;
K_h5 = 0;
K_h7 =0;
K_h9 = 0;
K_h11 = 0;
K_h13 = 0;
%Kp_pr = 0.3;

Kp_pr = 1;	% old
%wc_pr = 2.8471;
wc_pr = 1.5;
wc_hc = 0.3;
%k = 1/15 ;
k = 0.5;
time_thresh = 0.2;
load_on = 0.21;
load_off = 28;
