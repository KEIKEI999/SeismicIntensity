function plot_f(fftdata,fs)
    n = length(fftdata);          % number of samples
    f = (0:n-1)*(fs/n);     % frequency range
    power = abs(fftdata);%.^2/n;    % power of the DFT

    plot(f(1:n/2),power(1:n/2));
    xlabel('Frequency');
    ylabel('Power');
    