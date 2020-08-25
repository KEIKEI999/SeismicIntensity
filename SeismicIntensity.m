%filename: �C�ے��f�[�^�Bcsv�`��
%delimit�F �f���~�^�B�C�ے��f�[�^�̓J���}
%ignorerow�F������B�C�ے��f�[�^�ł���΁A7
%nscolumn�FNS(��k���������x)�B�C�ے��f�[�^�ł����1
%ewcolumn�FEW(�������������x)�B�C�ے��f�[�^�ł����2
%udcolumn�FUD(�㉺���������x)�B�C�ے��f�[�^�ł����3
%fs �v�����g��[Hz]
function y = SeismicIntensity(filename,delimit,ignorerow,nscolumn,ewcolumn,udcolumn,fs)
    global data;

    % �C�ے��̃f�[�^�J���}��؂聕�擪7�s�قǃw�b�_��񂪑���
    data = dlmread(filename,delimit,ignorerow,0);
    
    ns = data(:,nscolumn)';     % NS�f�[�^ �X���C�V���O
    ew = data(:,ewcolumn)';     % EW�f�[�^ �X���C�V���O
    ud = data(:,udcolumn)';     % UD�f�[�^ �X���C�V���O
    
    y = SeismicIntensityBody(ns,ew,ud,fs);
