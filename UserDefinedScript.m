% Hi Devon. You can ignore this script. I was (selfishly) using our unfinished 
% app to help conduct my own research. - jake :)

writedata = 1;

if writedata == 1
    
    % Input Settings
    myDir1 = 'C:\Users\jacob\Documents\ORRE_Offline\NREL TCF\OSWEC\W2 Testing\From Mike\WEC testing\Optical Tracking\90 Deg Decay\No Spring\';
    myDir2 = 'C:\Users\jacob\Documents\ORRE_Offline\NREL TCF\OSWEC\W2 Testing\Free Decay Response\90 Deg\No Spring\';
    
    myFiles1 = dir(fullfile(myDir1,'*.mat'));
    myFiles2 = dir(fullfile(myDir2,'*.txt'));
    
    
    Ts = 0.020000;
    datatype = 1;
    
    % Output Settings
    outputfileprefix = '90 Deg Decay Run ';
    outputdir = 'C:\Users\jacob\Documents\ORRE_Offline\NREL TCF\OSWEC\W2 Testing\W2 Experimental Results\90 Deg Decay\';
    outputfiletype = '.txt';
    myFiles1 = dir(fullfile(myDir1,'*.mat'));
    
%     dataset = cell(length(myFiles),1);
    
    for k = 1:length(myFiles1)
        baseFileName1 = myFiles1(k).name;
        fullFileName1 = fullfile(myDir1, baseFileName1);  
        
        storedStructure = load(fullFileName1);
        names = fieldnames(storedStructure);
        
%         runnum = baseFileName1(end-4);

        runnum = num2str(k);
        
%         for j = 1:length(myFiles2) 
%             splitfilename = split(myFiles2(j).name,' ');
%             if k < 16 && strcmp(splitfilename{4},['Reg ',runnum]) == 1
%                 baseFileName2 = myFiles2(j).name;
%                 break
%             end
%         end
        
        baseFileName2 = myFiles2(k).name;
        
        
        data = pkg.fun.read_data(myDir2,baseFileName2,datatype);
        
%         baseFileName2 = contains(myFiles2.name,['Reg ',runnum]);
        
        P = transpose(squeeze(storedStructure.(names{1}).RigidBodies.RPYs));
        P = fillgaps(P(:,2));
        P = sgolayfilt(P,3,41);
        offset = round(length(P)/2);
        P = P-mean(P(offset:end));
        tP=0:.02:(length(P)-1)*.02;
        
        if length(data.ch9) ~= length(tP)
            data.ch9 = [data.ch9; data.ch9(end)];
        end
        
        A = [tP; transpose(P); transpose(data.ch9)];
        
        
        
        headernames = {'Time(s)','Response(deg)','LoadCell(N)'};
        
        savename = [outputfileprefix,runnum,outputfiletype];
         
        datestring = split(storedStructure.(names{1}).Timestamp,',');
    
        origfile = ['% Original filename: ',baseFileName1];
        
        disp(['Combining results from ',baseFileName1,' and ',baseFileName2])
        
        fid = fopen(strcat(outputdir,savename),'wt');
        
        fprintf(fid, '%s \n', origfile);
        fprintf(fid, '%s %s \n', [outputfileprefix,runnum], datestring{1});
        fprintf(fid,'%s %s %s \r','Time(s)','Response(deg)','LoadCell(N)');
        fprintf(fid,'%f %f %f \r',A);

        fclose(fid);
        
%         fprintf(1, 'Now reading %s\n', fullFileName1);
%         data = pkg.fun.read_data(myDir1,baseFileName,datatype);
%         data.ch1 = sqrt(data.ch1).*Ts;
%         dataset{k,1} = data;
%         if writedata == 1
%             combined_data = [];
%             for ch = 1:length(data.headers)
%                 combined_data(:,ch) = data.(strcat('ch',num2str(ch)));
%             end
%             
%             data.tags = split(data.tags{1},char(9));
%             datestring = split(data.tags{2},'_');
%             Y = extractBetween(datestring{2},1,4);
%             M = extractBetween(datestring{2},5,6);
%             D = extractBetween(datestring{2},7,8);
%             
%             data.tags{2} = datestr(datetime(cellfun(@str2num,{Y{1} M{1} D{1}})));
%             
%             outputdir = 'C:\Users\jacob\Documents\ORRE_Offline\NREL TCF\OSWEC\W2 Testing\Fixed\';
%             headerfmt = [repmat('%s,',1,length(data.headers)-1),'%s'];
%             
%             fid = fopen(strcat(outputdir,data.filename),'wt');
%             fprintf(fid, '%s %s %s \n', data.tags{1}, data.tags{3}, data.tags{2});
%             fprintf(fid, headerfmt, data.headers{:});
%             fclose(fid);
%             
%             %           dlmwrite(strcat(outputdir,data.filename),combined_data,'delimiter','\t','-append','precision','%10.8f')
%             writematrix(combined_data,strcat(outputdir,data.filename),'WriteMode','append')
%         end
    end
end