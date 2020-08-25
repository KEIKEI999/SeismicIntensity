%filename: 気象庁データ。csv形式
%delimit： デリミタ。気象庁データはカンマ
%ignorerow：無効列。気象庁データであれば、7
%nscolumn：NS(南北方向加速度)。気象庁データであれば1
%ewcolumn：EW(東西方向加速度)。気象庁データであれば2
%udcolumn：UD(上下方向加速度)。気象庁データであれば3
%fs 計測周波数[Hz]
function y = SeismicIntensity(filename,delimit,ignorerow,nscolumn,ewcolumn,udcolumn,fs)
    global data;

    % 気象庁のデータカンマ区切り＆先頭7行ほどヘッダ情報が存在
    data = dlmread(filename,delimit,ignorerow,0);
    
    ns = data(:,nscolumn)';     % NSデータ スライシング
    ew = data(:,ewcolumn)';     % EWデータ スライシング
    ud = data(:,udcolumn)';     % UDデータ スライシング
    
    y = SeismicIntensityBody(ns,ew,ud,fs);
