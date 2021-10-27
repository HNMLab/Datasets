clc
clear all
close all
%%
Data = readtable('4channel1.xlsx'); % 2 column numerical data time(s) - voltage (V)
data = Data{:,:};

T = data(:,1); %time(s)
v = data(:,2)*1000; % voltage(mV)

Stau = 0.00146*ones(6,1); Stau(2) = 0.00914; Stau(3) = 0.01792; 
Stau(6) = 0.16; Stau(4) = 0.04367; Stau(5) = 0.08924; %relaxation time for each channel, Original settings could be changed according to the experimental environment (i.e. noise level, temperature change).

%%
cha_vol = 32;% threshold of charateristic peak voltage
decoder_function(T,v,Stau,cha_vol,3);
