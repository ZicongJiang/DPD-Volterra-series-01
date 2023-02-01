function symbol_error_rate = SER(format,N,loopnum,dB,symbol_rate,samples,input)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
snr=10.^(dB/10); % SNR in W
switch format
    case 'OOK'
        symbol_error_rate = OOK(N,loopnum,dB,snr,symbol_rate,samples);
    case '2PAM'
        symbol_error_rate = PAM_2(N,loopnum,snr,dB,symbol_rate,samples);
    case '4PAM'
        symbol_error_rate = PAM_4(N,loopnum,snr,dB,symbol_rate,samples);
    case '4PAM_MZM'
        symbol_error_rate = PAM_4_MZM(N,loopnum,snr,symbol_rate,samples);
    case '4PAM_MZM_with_arccos'
        symbol_error_rate = PAM_4_MZM_arccos(N,loopnum,snr,symbol_rate,samples);
    case 'test_4PAM'
        symbol_error_rate = test_4PAM(N,loopnum,snr,input,symbol_rate,samples);

    case 'OOK_ADC'
        symbol_error_rate = OOK_ADC(N,loopnum,dB,snr,symbol_rate,samples);
    case '4PAM_ADC'
        symbol_error_rate = PAM_4_ADC(N,loopnum,snr,dB,symbol_rate,samples);

    case '4PAM_MZM_ADC'
        symbol_error_rate = PAM_4_MZM_ADC(N,loopnum,snr,symbol_rate,samples);
    case '4PAM_MZM_with_ADC_arccos'
        symbol_error_rate = PAM_4_MZM_ADC_arccos(N,loopnum,snr,symbol_rate,samples);

end
end