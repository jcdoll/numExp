% Uncertainty.m
% Overview:
% Calculates the uncertainty in the spring constant of a cantilever beam
% using error propagation. Two different calculation techniques are 
% included: k via direct spring constant calculation from dimensions
% (error ~ t^3), and k via resonant frequency (error ~ t).
%
% Details:
% 1) Symbolic expressions are defined for the spring constant in terms of
%    cantilever dimensions, elastic modulus, and density. 
% 2) Calculate the partial derivates of the spring constant expressions in
%    terms of the experimental parameters.
% 3) Nominal values and standard deviations for the parameters are defined
% 4) Calculate the error
% 5) Output the results nicely using sprintf
% 
% by Joey Doll
%
% History:
% Sept 10, 2009 - Wrote initial version

clc
clear all
close all

% Define symbolic equations for calculating derivatives
syms k E w t l f0 rho;

meff = 0.243*rho*l*w*t; % Effective mass of cantilever beam
k = E*w*t^3/(4*l^3); % Spring constant directly from dimensions
kfreq = (2*pi*f0)^2*meff; % Calculating stiffness from frequency

% Derivatives for calculating errors
dk_dE = diff(k, E);
dk_dl = diff(k, l);
dk_dw = diff(k, w);
dk_dt = diff(k, t);

dkfreq_df0 = diff(kfreq, f0);
dkfreq_drho = diff(kfreq, rho);
dkfreq_dl = diff(kfreq, l);
dkfreq_dw = diff(kfreq, w);
dkfreq_dt = diff(kfreq, t);

% Mean values
E = 130e9; % GPa
rho = 2330; % kg/m^3
w = 30e-6; % m
t = 4e-6; % m
l = 125e-6; % m
f0 = 1/(2*pi)*sqrt(subs(k)/subs(meff)); % Hz

% Standard deviations (in same units as above)
s_E = .05*E; % 5 percent variation in E and rho
s_rho = .05*rho;
s_w = 1e-6;
s_l = 1e-6;
s_t = 0.3e-6;
s_f0 = 100;

% Calculate errors
s_k = subs(sqrt( (dk_dE*s_E)^2 + ...
                 (dk_dl*s_l)^2 + ...
                 (dk_dw*s_w)^2 + ...
                 (dk_dt*s_t)^2));
error_k = s_k/subs(k)*100; % error in percentage

s_kfreq = subs(sqrt( (dkfreq_df0*s_f0)^2 + ...
                     (dkfreq_drho*s_rho)^2 + ...
                     (dkfreq_dl*s_l)^2 + ...
                     (dkfreq_dw*s_w)^2 + ...
                     (dkfreq_dt*s_t)^2));
error_kfreq = s_kfreq/subs(kfreq)*100; % error in percentage

% Output in a readable format

sprintf(['Direct spring constant calculation: k = %0.2f N/m, k_STD = %0.2f N/m (%0.1f%%) \n' ...
         'Resonance spring constant calculation: k = %0.2f N/m, k_STD = %0.2f N/m (%0.1f%%)'], ...
         subs(k), s_k, error_k, subs(kfreq), s_kfreq, error_kfreq)