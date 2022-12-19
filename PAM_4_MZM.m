function P_4_mzm = PAM_4_MZM(N,loopnum,snr)
%SER calculation for 4PAM signal WITH MZM
% %%%%%%% bias %%%%%%%
Vpi = 1;
%%%%%%%% MZM %%%%%%
Vdc = 3;
Vpp = 1/3; % Vout = [0,1]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
E_av = @(E,M) E*(M^2-1)/3;
alpha4pam = [-3 -1 1 3];
alpha4pam_2 = [0 1 2 3];

% x = randsrc(1,N,alpha4pam);

P_avg = zeros(1,length(snr));
for n = 1:loopnum
%     Eav = E_av(E,4);
    x_4= randsrc(1,N,alpha4pam_2);
    Eav = mean(x_4.^2);
    Vi = Vdc+Vpp*x_4;
    Eout4 = (cos((pi/2)*(Vi/Vpi)));
for i=1:length(snr)
%     N0=5/36/2/snr(i);% calculate the power of noise
%     N0_dB=10*log10(N0);% power of noise to dBW
%     ni=wgn(1,N,N0_dB);% gaussian noise
%     yR_4 = Eout4+ni;
        N0=Eav/snr(i)/2;
        ni = sqrt(N0)*randn(1,N);
        yR_4 = Eout4+ni;
    
    for k = 1:length(yR_4)
        if yR_4(k)< 1/6
            y_detect_4(k) = 0;
        elseif yR_4(k) < 1/2
            y_detect_4(k) = 1;
        elseif yR_4(k) < 5/6
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