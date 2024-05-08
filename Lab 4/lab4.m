function yesno = lab4(amplitude, frequency, duration, samplingRate)
    tt = 0:1/samplingRate:duration;
    xx = amplitude * cos(2 * pi * frequency * tt + rand(1) * 2 * pi);
    soundsc(xx, samplingRate);
    pause(duration); 
    figure
    subplot(2,1,1)
    pspectrum(xx,samplingRate)
    subplot(2,1,2)
    pspectrum(xx,samplingRate,"spectrogram")
    aa = input('Can you hear me now? (Press n for no, y for yes):', 's');
    if isempty(aa)
        yesno = false;
        disp("Oops! Please re-enter the MATLAB back!")
    else
        yesno = upper(aa(1)) == 'Y';
        disp("Yay! You are not deaf!")
    end
end


% For running the code, please use the code instance at below
% lab4(1000,100,5,1000)‚