function datakernel = kernelSmooth(dataNorm,options)
    arguments
        dataNorm struct
        options.kernelSize (1,1) double = 1
    end
    datakernel = dataNorm;
    % seeking the adjacent neighbors within the preset kernel size
    num_x = dataNorm.num_x;
    num_y = dataNorm.num_y;
    num_datapoints = size(dataNorm.drplist,2);
    dataMap = reshape(dataNorm.drplist, num_x, num_y, num_datapoints);
    switch options.kernelSize
        case 1
            kernel = [0 1 0; 1 1 1; 0 1 0];
        case 2
            kernel = ones(3);
        otherwise
            kernel = 1;
    end
    kernel = kernel / sum(kernel,"all");  % rescale the kernel value
    for ii = 1:num_datapoints
        dataMap(:,:,ii) = conv2(dataMap(:,:,ii), kernel, "same");
    end
    datakernel.drplist = reshape(dataMap,[],num_datapoints);
    fprintf("Kernel processing finished!\n")
end