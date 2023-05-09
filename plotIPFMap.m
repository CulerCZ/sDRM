function color_drm_reg = plotIPFMap(EUmap,options)
    arguments
        EUmap
        options.plotDir (1,1) string = "z"
        options.crystalSymmetry (1,1) string = "cubic"
        options.plot (1,1) logical = false
    end
    
    euler = reshape(EUmap,size(EUmap,1)*size(EUmap,2),size(EUmap,3));
    % get the color mapping of DRM measurement
    cs = crystalSymmetry(options.crystalSymmetry);
    ipfKey = ipfHSVKey(cs);
    ori_drm = orientation.byEuler(euler(:,1)*degree,euler(:,2)*degree,euler(:,3)*degree,cs);
    if options.plotDir == "z"
        ipfKey.inversePoleFigureDirection = vector3d.Z;
    elseif options.plotDir == "y"
        ipfKey.inversePoleFigureDirection = vector3d.Y;
    end
    color_drm = ipfKey.orientation2color(ori_drm);
    color_drm_reg = reshape(color_drm,size(EUmap,1),size(EUmap,2),3);
    if options.plot
        figure, imshow(color_drm_reg,'Border','tight')
    end

end