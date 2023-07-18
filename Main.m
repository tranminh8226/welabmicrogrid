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
R_f = 0.35;
L_f = 0.000659829*1.4;
C_f = 0.000112315*9;
%coupling gain
cf = 100;
cv = 100;
%sampling frequency
f_c = 50e3;

lo_co = 0.1; 


droopDivide = 10;
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

PMW = V_nom/0.55;

w_c_high = 2*pi*50; %cutoff frequency of high pass filter
kL = 1e-7;
LD_ref1 = 100e-6; %virtual L value OLD 50e-6;

L_in1 = 0.35e-3;
R_in1 = 0.03;
L_in2 = 0.35e-3;
R_in2 = 0.03;
L_in3 = 0.35e-3;
R_in3 = 0.03;
L_in4 = 0.35e-3;
R_in4 = 0.03;

%PR controller 
ki_pr =160;
K_h5 =0;
K_h7 =0 ;
K_h9 = 0;
K_h11 = 0;
K_h13 = 0;
%Kp_pr = 0.3;

Kp_pr = 1.7;	% old 0.7
%wc_pr = 2.8471;
wc_pr = 3;
wc_hc = 1;
%k = 1/15 ;
k = -0.5;

%adjancency DAPI
a12 = 1;
a13 = 1;
a14 = 1;
a21 = 1;
a23 = 1;
a24 = 1;
a31 = 1;
a32 = 1;
a34 = 1;
a41 = 1;
a42 = 1;
a43 = 1;

%Pinning gain
b1w = 1;
b2w = 1;
b3w = 1;
b4w = 1;

b1v = 1;
b2v = 1;
b3v = 1;
b4v = 1;

%coupling gain
cf = 100;
cv = 100;

%adjuncancy matrix

%adjuncancy matrix formation
A = [0 1 1 1 ; 1 0 1 1 ; 1 1 0 1 ; 1 1 1 0];

%Lambda initialization
lambda3 = 62.5*[1.5e-3 1.5e-3 1e-3 1.1e-3]';
lambda2 = 30.5*[0.8e-2 0.8e-2 0.5e-2 0.5e-2]';
lambda1 = 5.5*[1 1 0.8 0.8]';

Pmax = [45e3 45e3 37e3 37e3]';

Tsamp = 0.1; %secondary

N = 2;
time_thresh = 0.2;
load_on = 0.21;
load_off = 28;
