% Digital Communication Integrated Circuit Design 
% Homework 1: BasedBand MIMO-OFDM Transmitter Design
% Author: Chung-Yuan Lan

% No.of Carriers: 64
% coding used: Convolutional coding
% Single frame size: 96 bits
% Total no. of Frames: 100
% Modulation: 16-QAM
% No. of Pilots: 4
% Cylic Extension: 25%(16)

close all
clear all
clc
%% OFDM parameters 
fs = 1.92*10^6;                                      % sampling rate/Bandwidth 
Ncarr =128;                                      % number of subcarriers 
GIlen = 160;                                      % length of OFDM symbol plus cyclic prefix 
CPlen = GIlen - Ncarr;                            % length of cyclic prefix 
%% Data Stream
t_data = randi([0 1],1,100);
x=1;
si=1; %for BER rows
%%
%for d=1:100;
%data=t_data(x:x+95);
%x=x+96;
%k=3;
%n=6;
%s1=size(data,2);  % Size of input matrix
%j=s1/k;

%% Convolutional Code Encoder 
constlen=3;
gen= [5 7];  %g1=[1 0 1] g2=[1 1 1]
trellis = poly2trellis(constlen, gen);
codedata = convenc(t_data, trellis);

%% Constellation Mapper
%QPSK

%16-QAM
B=reshape(codedata,size(codedata,2)/4,4) % 4bit
intlvddata = matintrlv(B',2,2)'; % Interleave.
intlvddata=intlvddata';
codedata_dec=bi2de(intlvddata','left-msb');
M = 16;
y = qammod(codedata_dec,M);
scatterplot(y);
y_=y/(10^0.5);
scatterplot(y_);

%64-QAM

%%  SFBC Encoder
yy_=y_';
symbol_num=size(yy_,2);

antenna1=[zeros(1,symbol_num)];
antenna2=[zeros(1,symbol_num)];

for i=1:3:symbol_num
    antenna1(i)=yy_(i);
    antenna2(i)=yy_(i+1);
    antenna1(i+1)=-conj(yy_(i+1));
    antenna2(i+1)=conj(yy_(i+1));
end
antenna1
antenna2

%%

ofdmMod = comm.OFDMModulator;

ofdmMod.FFTLength = 128;
ofdmMod.NumSymbols = 50;
ofdmMod.InsertDCNull=true;
disp(ofdmMod)
showResourceMapping(ofdmMod)

FFTLength: 64   
    NumGuardBandCarriers: [6;5]
            InsertDCNull: false
          PilotInputPort: false
      CyclicPrefixLength: 16   
               Windowing: false
              NumSymbols: 1    

%{
%%
% Pilot insertion

lendata=length(y);
pilt=3+3j;
nofpits=4;

k=1;

for i=(1:13:52)
    
    pilt_data1(i)=pilt;

    for j=(i+1:i+12);
        pilt_data1(j)=y(k);
        k=k+1;
    end
end

pilt_data1=pilt_data1';   % size of pilt_data =52
pilt_data(1:52)=pilt_data1(1:52);    % upsizing to 64
pilt_data(13:64)=pilt_data1(1:52);   % upsizing to 64

for i=1:52
    
    pilt_data(i+6)=pilt_data1(i);
    
end


%%
% IFFT

ifft_sig=ifft(pilt_data',64);


%%
% Adding Cyclic Extension

cext_data=zeros(80,1);
cext_data(1:16)=ifft_sig(49:64);
for i=1:64
    
    cext_data(i+16)=ifft_sig(i);
    
end

%end
%%
% Channel

 % SNR

 o=1;
for snr=0:2:50

ofdm_sig=awgn(cext_data,snr,'measured'); % Adding white Gaussian Noise
% figure;
% index=1:80;
% plot(index,cext_data,'b',index,ofdm_sig,'r'); %plot both signals
% legend('Original Signal to be Transmitted','Signal with AWGN');
end
%}