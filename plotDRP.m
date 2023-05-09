function plotDRP(drp,plotPara,options)
    arguments
        drp
        plotPara
        options.cMap (1,1) string="jet"
        options.format (1,1) string="3d"
        options.caxis (1,2) double=[0 1]
        options.colorbar (1,1) logical = false
    end
    x3 = plotPara.x;
    y3 = plotPara.y;
    z3 = plotPara.z;
    if options.format == "3d"
        patch(x3,y3,z3,drp,"EdgeColor","none")
    elseif options.format == "2d"
        x2 = x3./(1+z3);
        y2 = y3./(1+z3);
        patch(x2,y2,drp,"EdgeColor","none")
    end
    axis equal
    colormap(gca,options.cMap)
    warning('off')
    set(gca,"Visible","off")
    clim(gca,options.caxis)
    warning('on')
    if options.colorbar
        colorbar("FontSize",14,"FontWeight","bold")
    end

end