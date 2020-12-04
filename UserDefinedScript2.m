% Hi Devon. You can ignore this script. I was (selfishly) using our unfinished 
% app to help conduct my own research. - jake :)

writedata = 1;

if writedata == 1
    
    % Input Settings
    myDir1 = 'C:\Users\jacob\Documents\ORRE_Offline\NREL TCF\OSWEC\W2 Testing\From Mike\Fixed\90 Deg\';
    myFiles1 = dir(fullfile(myDir1,'*.txt'));
    
    Ts = 0.020000;
    datatype = 1;
    
    % Output Settings
    outputfileprefix = '90 Deg Fixed Reg ';
    outputdir = 'C:\Users\jacob\Documents\ORRE_Offline\NREL TCF\OSWEC\W2 Testing\W2 Experimental Results\90 Deg Fixed\';
    outputfiletype = '.txt';

    
%     dataset = cell(length(myFiles),1);
    
    for k = 1:length(myFiles1)
        baseFileName1 = myFiles1(k).name;
        fullFileName1 = fullfile(myDir1, baseFileName1);  
        
      
        runnum = num2str(k);

        data = pkg.fun.read_data(myDir1,baseFileName1,datatype);
        
        A = [transpose(data.ch1); transpose(data.ch9)];
        
        
        
        headernames = {'Time(s)','LoadCell(N)'};
        
        savename = [baseFileName1];
         
        datestring = split(data.tags,' ');
        
        
        datestring = datestring{8};
        
        
        disp(['Cleaning results from ',baseFileName1])
        
        fid = fopen(strcat(outputdir,savename),'wt');
        
        fprintf(fid, '%s %s \n', baseFileName1(1:end-4), datestring);
        fprintf(fid,'%s %s\r','Time(s)','LoadCell(N)');
        fprintf(fid,'%f %f \r',A);

        fclose(fid);
        
%         
    end
end