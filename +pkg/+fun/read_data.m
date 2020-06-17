function [obj] = read_data(directory,filename,datatype,channeltypes,tagtypes)

file_location = strcat(directory,'\',filename);
fileID = fopen(file_location,'r');

if datatype == 0 % test data

    ntaglines = 2;
    nheaderlines = 1;
    data_tags = textscan(fileID,'%s',ntaglines,'CommentStyle','#');
    data_headers = textscan(fileID,'%s %s',nheaderlines,'Delimiter',',','CommentStyle','#');
    data = textscan(fileID,'%f %f','Delimiter',',','CommentStyle','#');
    
elseif datatype == 1 % regular wave repsonse
    tagformat = '%s%s%s%d';
    headerformat = repmat('%s',1,length(channeltypes));
    dataformat = repmat('%f',1,length(channeltypes));
    
    ntaglines = 1;
    nheaderlines = 1;
    data_tags = textscan(fileID,tagformat,ntaglines,'CommentStyle','#');
    data_headers = textscan(fileID,headerformat,nheaderlines,'Delimiter',',','CommentStyle','#');
    data = textscan(fileID,dataformat,'Delimiter',',','CommentStyle','#');
    
    % initialize class
    obj = pkg.obj.dataClass();
    
    for tag = 1:length(data_tags)
        if iscell(data_tags{tag})
            obj.addprop(tagtypes{tag});
            obj.(tagtypes{tag}) = data_tags{tag}{1};
            
        elseif isnumeric(data_tags{tag})
            obj.addprop(tagtypes{tag});
            obj.(tagtypes{tag}) = data_tags{tag}(1);
        end    
    end
   
    propcnt = 1; 
    for prop = 1:length(data_headers)
        nnz(strcmp(channeltypes,channeltypes{prop}))
        
        if nnz(strcmp(channeltypes,channeltypes{prop})) > 1
            
            while isprop(obj,(channeltypes{prop}))
                
                if propcnt == 1
                    ch_name = channeltypes{prop};
                end
                channeltypes{prop} = strcat(ch_name,num2str(propcnt+1));
                propcnt = propcnt + 1;
                
            end
            propcnt = 1;
        end
        obj.addprop(channeltypes{prop});
        obj.(channeltypes{prop}) = data{prop};
    end
end
 
 fclose(fileID);

end

