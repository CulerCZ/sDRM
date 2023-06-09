function [drp_selected, x_output, y_output] = showSampleDRP(dataNorm, plotPara, options)
    arguments
        dataNorm struct
        plotPara struct
        options.cMap (1,1) string = "jet"
    end
    f1 = figure('Name','demo_fig');
    fig_temp = median(dataNorm.drpMap,3);
    imshow(fig_temp,[min(fig_temp,[],"all"),max(fig_temp,[],"all")],'Border','tight');
    colormap("parula")
    [x,y] = ginput;
    % press 'enter' to stop
    nn = length(y);
    y = fix(y);
    x = fix(x);
    close(f1);
    
    figure('Position',[200,200,200*(nn+1),200])
    tiledlayout(1,nn+1,'TileSpacing','tight','Padding','compact')
    ax1 = nexttile(1);
    imshow(fig_temp,[min(fig_temp,[],"all"),max(fig_temp,[],"all")],'Border','tight')
    colormap(ax1,"parula")
    hold on
    scatter(x,y,72,'x','k')
    for ii = 1:nn
        text(x(ii)+5,y(ii)+5,int2str(ii),'FontSize',14)
    end
    hold off
    
    drp_selected = zeros(nn,dataNorm.num_pixel);
    
    for ii = 1:nn
        % DRP from measurement 
        nexttile(ii+1)
        x_pos = y(ii);
        y_pos = x(ii);
        drp_selected(ii,:) = squeeze(dataNorm.drpMap(x_pos,y_pos,:));
        plotDRP(drp_selected(ii,:), plotPara,cMap=options.cMap)
    end
    x_output = y;
    y_output = x;
end