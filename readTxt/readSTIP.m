function info = readSTIP(fileName, mode)
% This file is used in MAC Machine. Not tested on a Windows Machine.
% mode = "Feature Discriptor" or "Trajectory"

Filt = 1;

fid = fopen(fileName);
for i = 1 : 3
    tline = fgetl(fid);
end

FeaturePoint = []; FilterPara = []; Conf = []; STIPVector = [];
while 1
    tline = fgetl(fid);
    if ~ischar(tline)
        break;
    end
    tlineNum = str2num(tline);
    FeaturePoint = cat(1, FeaturePoint, tlineNum(2 : 4));
    FilterPara = cat(1, FilterPara, tlineNum(5 : 6));
    Conf = cat(1, Conf, tlineNum(7));
    switch mode
        case 'discriptor'
          STIPVector = cat(1, STIPVector, {tlineNum(10 : end)});
        case 'trajectory'
            tSTIPVector = tlineNum(10:end);
%             tSTIPVector = 120 + 1 - tSTIPVector;
            tSTIPVector = reshape(tSTIPVector, 2, [])';
            STIPVector = cat(1, STIPVector, {tSTIPVector});
    end
    
end

if Filt == 1
%     [~, idx] = sort(Conf);
%     idx = idx(1 : 20);
    idx = find(Conf >= 3 * mean(Conf));
    FeaturePoint = FeaturePoint(idx, :);
    FilterPara = FilterPara(idx, :);
    Conf = Conf(idx, :);
    STIPVector = STIPVector(idx, :);
end
    

[~, IX] = sort(FeaturePoint(:, 3));
FeaturePoint = FeaturePoint(IX, :);
FilterPara = FilterPara(IX, :);
Conf = Conf(IX, :);
STIPVector = STIPVector(IX, :);

info.FeaturePoint = FeaturePoint;
info.FilterPara = FilterPara;
info.Conf = Conf;
info.STIPVector = STIPVector;