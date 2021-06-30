function [] = OSWEC_loadpaths(dataset,subfields,varnames)

setnames = fieldnames(rmfield(dataset,'Results'));
verbose = 1



% figure; hold on

for i = 1:length(setnames)
    currentrun = setnames{i};
    if verbose==1; disp(['%',repmat('-',1,100),'%',newline,currentrun]); end
    
    % loop over subfields and varnames:
    %     for j = 1:length(subfields)
    %         subfield = subfields{j};
    %         varname = varnames{j};
    %         if verbose==1; disp([newline,varname]); end
    %
    %
    phi = dataset.(currentrun).position.phi;
    fx = dataset.(currentrun).forceX.fx
    fz = dataset.(currentrun).forceZ.fz
    
    fig1 = figure;
    fig1.Position(1) = fig1.Position(1) - fig1.Position(3);
    fig1.Position(2) = fig1.Position(2) - fig1.Position(4)/2;
    plot(phi,fx)
    xlabel('pitch displacement (deg)')
    ylabel('fx (N)')
    
    fig2 = figure;
    fig2.Position(2) = fig2.Position(2) - fig2.Position(4)/2;
    plot(phi,fz)
    xlabel('pitch displacement (deg)')
    ylabel('fz (N)')
    
    
    fig3 = figure;
    fig3.Position(1) = fig3.Position(1) + fig3.Position(3);
    fig3.Position(2) = fig3.Position(2) - fig3.Position(4)/2;
    plot(fx,fz)
    xlabel('fx (N)')
    ylabel('fz (N)')
%     xlim(2.5.*[-1 1])
%     ylim(2.5.*[-1 1])
end



end




