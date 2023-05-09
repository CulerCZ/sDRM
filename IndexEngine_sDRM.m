function indexResult = IndexEngine_sDRM(dataNorm, drpLib, options)
    arguments
        dataNorm
        drpLib
        options.K (1,1) double = 1
    end
    % treatment on input drps: normalization, 
    % drp_in = normalizeVec(drp_in);
    [Idx, D] = knnsearch(drpLib.drpList, dataNorm.drplist, K=options.K);
    indexResult.Euler = drpLib.eulerList(Idx(:,1),:);
    indexResult.Idx = Idx;
    indexResult.distance = D;
    indexResult.eulerMap = reshape(indexResult.Euler,dataNorm.num_x,dataNorm.num_y,3);
    indexResult.idxMap = reshape(indexResult.Idx,dataNorm.num_x,dataNorm.num_y,options.K);
    indexResult.distanceMap = reshape(indexResult.distance(:,1),dataNorm.num_x,dataNorm.num_y);
    fprintf("Orientation indexing finished!\n")
end