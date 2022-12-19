function symbol_error_rate = SER(format,N,loopnum,dB,input)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
snr=10.^(dB/10); % SNR in W
switch format
    case 'OOK'
        symbol_error_rate = OOK(N,loopnum,dB,snr);
    case '2PAM'
        symbol_error_rate = PAM_2(N,loopnum,snr,dB);
    case '4PAM'
        symbol_error_rate = PAM_4(N,loopnum,snr,dB);
    case '4PAM_MZM'
        symbol_error_rate = PAM_4_MZM(N,loopnum,snr);
    case '4PAM_MZM_with_arccos'
        symbol_error_rate = PAM_4_MZM_arccos(N,loopnum,snr);
    case 'test_4PAM'
        symbol_error_rate = test_4PAM(N,loopnum,snr,input);

end
end