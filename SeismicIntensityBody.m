function y = SeismicIntensityBody(ns,ew,ud,fs)

    global fft_ns;
    global fft_ew;
    global fft_ud;

    % FFTで周波数領域に
    fft_ns = fft(ns);
    fft_ew = fft(ew);
    fft_ud = fft(ud);
    
    global num;
    num = size( ns, 2 );       % データ数(列数)
    n = 0:( num - 1 );         % プロット軸元ネタ    
    %f =  n / (num/fs);
    % 0割回避＆疑似0値のため微小値を加算
    f =  n / (num / fs) + 0.00000000000000000001; %関数窓用プロット軸
    
    % 乗除は行列乗除("*" , "/")ではなく要素単位の乗除(".*" , "./")
    
    % 周期効果関数窓
    global winX;
    winX = sqrt(1 ./ f);
    
    % ハイカット関数窓
    Y = f ./ 10;
    global winY;
    winY = 1 ./ sqrt(ones(1,num) + 0.694*Y.^2 + 0.241*Y.^4 + 0.0557*Y.^6 + 0.009664*Y.^8 + 0.00134*Y.^10 + 0.000155*Y.^12);
    
    % ローカット関数窓
    global winZ;
    winZ = sqrt(ones(1,num) - exp(-(f./0.5).^3));
    
    % 関数窓合成
    win1 = winX .* winY .* winZ;    % 前半分用
    win2 = fliplr(winX) .* fliplr(winY) .* fliplr(winZ); % 後半用
    
    nn = floor(num/2);
    global win;
    win = [win1(1:nn),win1(nn+1),win2(nn+2:num)];
    
    % バンドパスフィルタ
    global fft_ns_;
    global fft_ew_;
    global fft_ud_;
    fft_ns_ = win.*fft_ns;
    fft_ew_ = win.*fft_ew;
    fft_ud_ = win.*fft_ud;
    
    % 逆フーリエ変換
    global res_ns;
    global res_ew;
    global res_ud;    
    res_ns = ifft(fft_ns_);
    res_ew = ifft(fft_ew_);
    res_ud = ifft(fft_ud_);
    
    % 合成加速度
    global anorm;
    anorm = abs(sqrt(res_ns.^2 + res_ew.^2 + res_ud.^2));
    
    % 降順ソート
    sorted_anorm = sort(anorm,'descend');
    
    % 0.3秒後のデータサンプル確保(開始位置を0秒とする。)
    S = sorted_anorm(floor(0.3*fs)+1);
    
    % 気象庁指定の演算で震度算出
    I = 2 * log10(S) + 0.94;
    y = floor(10*(I+0.005)) / 10;   % 小数第3位を四捨五入し、小数第2位を切り捨て
