function CreateReportButtonPushed(app,event)
documentObj = Document(ORRE_post_processing, docx);
imageObj = mlreportgen.dom.Image(ORRE.png);
image = FormalImage(imageObj);

end

%%old idea:
% project_dir = pwd();
% files = dir( fullfile(project_dir, '*.png'));
% a = actxserver('Word.application');
% a.Visible = 1;
% Document = a.Document;
% 
% [fn, dn] = uigetfile('*.docx', 'Select Word File To Amend');
% filename = fullfile(dn, fn);                                %changed
% Document = invoke(Document, 'open', filename);
% 
% for i=1:length(files)
%     page_count = int32(double(slide_count)+1);
%     page = invoke(Document.Pages, 'Add', page_count{i}, 11);
%     pagefile = fullfile(project_dir, files(i).name);
%     Image{i} = page.AddPicture(pagefile);
% end
% outfile = fullfile(project_dir, 'DRAFT.docx');
% Document.SaveAs(outfile);
% 
% a.Quit;
% a.delete;
    
