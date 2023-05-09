function checkDetail = checkIndexResult(dataNorm, indexResult, options)
    arguments
        dataNorm
        indexResult
        options.cMap (1,1) string = "jet"
        options.faceting (1,3) double = [1 0 0]
        options.fitting_para (1,6) double = [1,0.7,25,4,0.8,8]
    end
    indexEulerMap = reshape(indexResult.Euler,dataNorm.num_x,dataNorm.num_y,3);
    figure("Name","Index Result");
    imshow(plot_ipf_map(indexResult.eulerMap),"Border","tight")
    [x,y] = ginput;
    % press 'enter' to stop
    nn = length(y);
    y = fix(y);
    x = fix(x);
    close(findobj("type","figure","name","Index Result"));
    posList = [y, x];

    drp_selected = zeros(nn,dataNorm.num_pixel);
    figure('Position',[100,100,200*(nn),200*2])
    tiledlayout(2,nn,'TileSpacing','tight','Padding','compact')
    for ii = 1:nn
        % DRP from measurement 
        ax = nexttile(ii);
        x_pos = y(ii);
        y_pos = x(ii);
        drp_selected(ii,:) = squeeze(dataNorm.drpMap(x_pos,y_pos,:));
        plotDRP(drp_selected(ii,:), dataNorm.plotPara)
        colormap(ax, options.cMap)
        ax = nexttile(ii+nn);
        plotDRP(drpSimCone(dataNorm.posInfo, squeeze(indexEulerMap(x_pos,y_pos,:)), ...
            options.faceting, options.fitting_para), dataNorm.plotPara);
        colormap(ax, options.cMap)
    end
    
    figure,
    imshow(plot_ipf_map(indexResult.eulerMap),"Border","tight")
    hold on
    scatter(x,y,72,'filled','o','black')
    for ii = 1:nn
        text(x(ii)+5,y(ii)+5,int2str(ii),'FontSize',14,'FontWeight','bold')
    end
    hold off

    checkDetail.posList = posList;
    checkDetail.drpSelected = drp_selected;

end