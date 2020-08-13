% Hi Devon. You can ignore this script. I was (selfishly) using our unfinished 
% app to help conduct my own research. - jake :)

writedata = 0;

if writedata == 1
    
    Ts = 0.020000;
    
    datatype = 1;
    
    myDir = 'C:\Users\jacob\Documents\ORRE_Offline\NREL TCF\OSWEC\W2 Testing\Regular Wave Response\0 Deg\';
    myFiles = dir(fullfile(myDir,'*.txt'));
    
    dataset = cell(length(myFiles),1);
    
    for k = 1:length(myFiles)
        baseFileName = myFiles(k).name;
        fullFileName = fullfile(myDir, baseFileName);  % Changed myFolder to myDir
        
        storedStructure1 = load(fullFileName);
        names = fieldnames(storedStructure1);
        
        P = transpose(squeeze(storedStructure1.(names{1}).RigidBodies.RPYs));
        P = fillgaps(P(:,2));
        P = sgolayfilt(P,3,41);
        offset = round(length(P)/2);
        P = P-mean(P(offset:end));
        tP=0:.02:(length(P)-1)*.02;
        A = [tP;transpose(P)];
        
        fileID = fopen(sprintf('Run%d.txt',i),'w');
        fprintf(fileID,'Time(s) Response(deg)\r\n');
        fprintf(fileID,'%f %f\r\n',A);
        fclose(fileID);
        
        fprintf(1, 'Now reading %s\n', fullFileName);
        data = pkg.fun.read_data(myDir,baseFileName,datatype);
        data.ch1 = sqrt(data.ch1).*Ts;
        dataset{k,1} = data;
        if writedata == 1
            combined_data = [];
            for ch = 1:length(data.headers)
                combined_data(:,ch) = data.(strcat('ch',num2str(ch)));
            end
            
            data.tags = split(data.tags{1},char(9));
            datestring = split(data.tags{2},'_');
            Y = extractBetween(datestring{2},1,4);
            M = extractBetween(datestring{2},5,6);
            D = extractBetween(datestring{2},7,8);
            
            data.tags{2} = datestr(datetime(cellfun(@str2num,{Y{1} M{1} D{1}})));
            
            outputdir = 'C:\Users\jacob\Documents\ORRE_Offline\NREL TCF\OSWEC\W2 Testing\Fixed\';
            headerfmt = [repmat('%s,',1,length(data.headers)-1),'%s'];
            
            fid = fopen(strcat(outputdir,data.filename),'wt');
            fprintf(fid, '%s %s %s \n', data.tags{1}, data.tags{3}, data.tags{2});
            fprintf(fid, headerfmt, data.headers{:});
            fclose(fid);
            
            %           dlmwrite(strcat(outputdir,data.filename),combined_data,'delimiter','\t','-append','precision','%10.8f')
            writematrix(combined_data,strcat(outputdir,data.filename),'WriteMode','append')
        end
    end
end