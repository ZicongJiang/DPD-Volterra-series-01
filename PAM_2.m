function P_2 = PAM_2(N,loopnum,snr,dB)
%SER calculation for 2PAM signal
E_av = @(E,M) E*(M^2-1)/3;
alpha2pam = [-1 1];
alpha2pam_2 = [0 1];
% E = ((alpha2pam(2)-alpha2pam(1))/2)^2;
% Eav = E_av(1/4,2);
% x = randsrc(1,N,alpha2pam);
P_avg = zeros(1,length(snr));
for n = 1:loopnum
   x_2= randsrc(1,N,alpha2pam_2);
   Eav = mean(x_2.^2); % 1
%    Eav = E_av(E,2); % 1
%     p = pow2db(Eav); % 2
for i=1:length(snr)
    N0=Eav/snr(i)/2;% power of noise % 1
%     N0_dB=10*log10(N0);
%     ni=wgn(1,N,N0_dB);% gaussian noise

    ni = sqrt(N0)*randn(1,N); % 1
    yR_2 = x_2+ni; % 1
%     yR_2 = awgn(x_2,dB(i),p); % 2

    for k = 1:length(yR_2)
        if yR_2(k)< 1/2
            y_detect_2(k) = 0;
        else
            y_detect_2(k) = 1;
        end
    end

    bit_R_2=length(find(x_2~=y_detect_2));% Error symbols
    P_2(i)=bit_R_2/N;% BER 
end
    P_avg = P_2+P_avg;
end
P_2 = P_avg/loopnum;
end