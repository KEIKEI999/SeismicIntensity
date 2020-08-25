function y = SeismicIntensityBody(ns,ew,ud,fs)

    global fft_ns;
    global fft_ew;
    global fft_ud;

    % FFT�Ŏ��g���̈��
    fft_ns = fft(ns);
    fft_ew = fft(ew);
    fft_ud = fft(ud);
    
    global num;
    num = size( ns, 2 );       % �f�[�^��(��)
    n = 0:( num - 1 );         % �v���b�g�����l�^    
    %f =  n / (num/fs);
    % 0��������^��0�l�̂��ߔ����l�����Z
    f =  n / (num / fs) + 0.00000000000000000001; %�֐����p�v���b�g��
    
    % �揜�͍s��揜("*" , "/")�ł͂Ȃ��v�f�P�ʂ̏揜(".*" , "./")
    
    % �������ʊ֐���
    global winX;
    winX = sqrt(1 ./ f);
    
    % �n�C�J�b�g�֐���
    Y = f ./ 10;
    global winY;
    winY = 1 ./ sqrt(ones(1,num) + 0.694*Y.^2 + 0.241*Y.^4 + 0.0557*Y.^6 + 0.009664*Y.^8 + 0.00134*Y.^10 + 0.000155*Y.^12);
    
    % ���[�J�b�g�֐���
    global winZ;
    winZ = sqrt(ones(1,num) - exp(-(f./0.5).^3));
    
    % �֐�������
    win1 = winX .* winY .* winZ;    % �O�����p
    win2 = fliplr(winX) .* fliplr(winY) .* fliplr(winZ); % �㔼�p
    
    nn = floor(num/2);
    global win;
    win = [win1(1:nn),win1(nn+1),win2(nn+2:num)];
    
    % �o���h�p�X�t�B���^
    global fft_ns_;
    global fft_ew_;
    global fft_ud_;
    fft_ns_ = win.*fft_ns;
    fft_ew_ = win.*fft_ew;
    fft_ud_ = win.*fft_ud;
    
    % �t�t�[���G�ϊ�
    global res_ns;
    global res_ew;
    global res_ud;    
    res_ns = ifft(fft_ns_);
    res_ew = ifft(fft_ew_);
    res_ud = ifft(fft_ud_);
    
    % ���������x
    global anorm;
    anorm = abs(sqrt(res_ns.^2 + res_ew.^2 + res_ud.^2));
    
    % �~���\�[�g
    sorted_anorm = sort(anorm,'descend');
    
    % 0.3�b��̃f�[�^�T���v���m��(�J�n�ʒu��0�b�Ƃ���B)
    S = sorted_anorm(floor(0.3*fs)+1);
    
    % �C�ے��w��̉��Z�Ők�x�Z�o
    I = 2 * log10(S) + 0.94;
    y = floor(10*(I+0.005)) / 10;   % ������3�ʂ��l�̌ܓ����A������2�ʂ�؂�̂�
