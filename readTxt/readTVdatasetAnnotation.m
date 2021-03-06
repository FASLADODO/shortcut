function info = readTVdatasetAnnotation(fileName)
% This file is used in MAC Machine. Not tested on a Windows Machine.

fid = fopen(fileName);
% for i = 1 : 3
%     tline = fgetl(fid);
% end
% The first line
tline = fgetl(fid);
C = textscan(tline, '%s %d');
info.NumFrame = getNumFrame(fileName) + 1;
PersonID = []; PersonInfo = []; FrameInfoBatch = cell(info.NumFrame, 1);

while 1
    tline = fgetl(fid);
    if ~ischar(tline)
        break;
    end
    
    remain = tline;
    for i = 1 : 2
        posC = strfind(remain, ':');
        [token remain] = strtok(remain(posC + 1 : end));
        switch num2str(i)
            case '1'
                FrameInfo.fn = str2num(token);
            case '2'
                FrameInfo.pn = str2num(token);
        end
    end
    % This is for the interactiong information
    FrameInfo.inter = remain;
    
    for i = 1 : FrameInfo.pn
        tline = fgetl(fid); 
        C = textscan(tline, '%d %d %d %d %s %s');
        tPersonID = C{1};
        [PersonID flag] = renewID(PersonID, tPersonID);
        if flag
            PersonInfo = cat(3, PersonInfo, zeros(info.NumFrame, 6));
        end
        sliceID = tPersonID + 1;
        PersonInfo(FrameInfo.fn + 1, 1:4, sliceID) = [C{2} C{3} C{2} + C{4} C{3} + C{4}];
        PersonInfo(FrameInfo.fn + 1, 5, sliceID) = ActionCode(C{5});
        PersonInfo(FrameInfo.fn + 1, 6, sliceID) = HeadCode(C{6});
    end
    FrameInfoBatch{FrameInfo.fn + 1} = FrameInfo;
end
info.PersonInfo = PersonInfo;
info.FrameInfoBatch = FrameInfoBatch;
info.PersonID = PersonID;
fid = fclose(fid);


function [PersonID flag] = renewID(PersonID, tPersonID)
idx = find(ismember(PersonID, tPersonID) == 1);
if isempty(idx)
    flag = 1;
    PersonID = cat(1, PersonID, tPersonID);
else
    flag = 0;
end

function Code = ActionCode(ActionStr)
try
    if strcmp(ActionStr, 'no_interaction'),     Code = 0; end
    if strcmp(ActionStr, 'hand_shake'),         Code = 1; end
    if strcmp(ActionStr, 'high_five'),          Code = 2; end
    if strcmp(ActionStr, 'hug'),                Code = 3; end
    if strcmp(ActionStr, 'kiss'),               Code = 4; end
catch
    display(['ActionStr is: ' ActionStr]);
end

function Code = HeadCode(HeadStr)
try
    if strcmp(HeadStr, 'profile_left'),         Code = 1; end
    if strcmp(HeadStr, 'frontal_left'),           Code = 2; end
    if strcmp(HeadStr, 'frontal_right'),          Code = 3; end
    if strcmp(HeadStr, 'profile_right'),        Code = 4; end
    if strcmp(HeadStr, 'backwards'),            Code = 5; end
catch
    display(['HeadStr is: ' HeadStr]);
end

function NumFrame = getNumFrame(fileName)
fid = fopen(fileName);
% for i = 1 : 3
%     tline = fgetl(fid);
% end
% The first line
tline = fgetl(fid);
% C = textscan(tline, '%s %d');

    while 1
        tline = fgetl(fid);
        if ~ischar(tline)
            break;
        end

        remain = tline;
        for i = 1 : 2
            posC = strfind(remain, ':');
            [token remain] = strtok(remain(posC + 1 : end));
            switch num2str(i)
                case '1'
                    NumFrame = str2num(token);
                case '2'
                    FrameInfo.pn = str2num(token);
            end
        end

        FrameInfo.inter = remain;

        for i = 1 : FrameInfo.pn
            tline = fgetl(fid); 
        end
    end