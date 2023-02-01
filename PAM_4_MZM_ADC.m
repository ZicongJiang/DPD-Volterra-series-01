function P_4_mzm = PAM_4_MZM_ADC(N,loopnum,snr,symbol_rate,samples)
%SER calculation for 4PAM signal WITH MZM
% %%%%%%% bias %%%%%%%
Rs = symbol_rate;
L = samples;
Vpi = 1;
%%%%%%%% MZM %%%%%%
Vdc = 1;
Vpp = 1/3; % Vout = [0,1]
A = N; 
B = L;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha4pam_2 = [0 1 2 3];

% x = randsrc(1,N,alpha4pam);

P_avg = zeros(1,length(snr));

x_4= randsrc(1,N,alpha4pam_2);
Vi = Vdc+Vpp*x_4;
Eout4 = (cos((pi/2)*(Vi/Vpi))).^2;    
Eav = mean(Eout4.^2);
for n = 1:loopnum
    %     Eav = E_av(E,4);
    x_4= randsrc(1,N,alpha4pam_2);
    x_gauss = pulse_shape(N,Rs,L,x_4);

    x_gauss = Quantnoise_TX(x_gauss,A,B); % Quantnoise_Tx

    Vi = Vdc+Vpp*x_gauss;
    Eout4 = (cos((pi/2)*(Vi/Vpi))).^2;

for i=1:length(snr)
        N0=Eav/snr(i)/2;
        ni = sqrt(N0)*randn(1,length(Eout4));
        yR_4 = Eout4+ni;

        yR_4 = Quantnoise_RX(yR_4,A,B);
        
        samplesPerSymbol = length(x_gauss)/N;
        Etx_downsampled = yR_4((samplesPerSymbol/2+1):samplesPerSymbol:end);
    
    for k = 1:length(Etx_downsampled)
        if Etx_downsampled(k)<  1/6%((cos((pi/2)*(4/3/Vpi)).^2-cos((pi/2)*(1/Vpi)).^2)/2)
            y_detect_4(k) = 0;
        elseif Etx_downsampled(k) < 3/6 %((cos((pi/2)*(5/3/Vpi)).^2-cos((pi/2)*(4/3/Vpi)).^2)/2+cos((pi/2)*(4/3/Vpi)).^2)
            y_detect_4(k) = 1;
        elseif Etx_downsampled(k) < 5/6%((cos((pi/2)*(2/Vpi)).^2-cos((pi/2)*(5/3/Vpi)).^2)/2+cos((pi/2)*(5/3/Vpi)).^2)
            y_detect_4(k) = 2;
        else
            y_detect_4(k) = 3;
        end
    end

    bit_R_4=length(find(x_4~=y_detect_4));% Error Bits
    P_4_mzm(i)=bit_R_4/N;% BER
end
    P_avg = P_4_mzm+P_avg;
end
P_4_mzm = P_avg/loopnum;
end