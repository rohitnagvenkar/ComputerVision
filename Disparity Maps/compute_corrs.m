function [disparity] = compute_corrs(img_left,img_right, method)

    if strcmp(method,'SSD')
        tic;
        imgL = imread(img_left);
        imgR = imread(img_right);
        img_right1 = rgb2gray(imgR);
        img_left1 = rgb2gray(imgL);
        range = 100;
        WSIZE = 5;
        [rows,cols] = size(img_right1);
        disparityT = zeros(rows,cols);

        for i=1:rows-WSIZE
            for j=1:cols-WSIZE
                template = img_right1(i:i+WSIZE,j:j+WSIZE);
                maxR = min(range,((cols-WSIZE)-j));
                arrSSD = zeros(maxR, 1);
                for k=0:maxR
                    block = img_left1(i:i+WSIZE,j+k:j+k+WSIZE);
                    diff = double(block) - double(template);
                    ssd = sum(diff(:).^2);
                    arrSSD(k+1,1) = ssd;
                end
                [value, index] = sort(arrSSD);
                disparityT(i,j) = index(1,1);
            end
            if (mod(i, 10) == 0)
               fprintf('%d rows remain\n', (rows - i)); 
            end
        end
        disparity = disparityT;
        image(disparity);
        title('Dispartiy map using Sum of Squared Differences (SSD)');
        timeElapsed = toc;
        fprintf('Elasped Time %f seconds\n',timeElapsed);
        fprintf('Window Size %i \n',WSIZE);
        fprintf('Disparity Range (Threshold) %i \n',range);
        run('errorDisparity.m');
    elseif strcmp(method,'CC')
        tic;
        imgL = imread(img_left);
        imgR = imread(img_right);
        img_right1 = rgb2gray(imgR);
        img_left1 = rgb2gray(imgL);
        range = 100;
        WSIZE = 31;
        [rows,cols] = size(img_right1);
        disparityT = zeros(rows,cols);

        for i=1:rows-WSIZE
            for j=1:cols-WSIZE
                template = img_right1(i:i+WSIZE,j:j+WSIZE);
                maxR = min(range,((cols-WSIZE)-j));
                arrSSD = zeros(maxR, 1);
                for k=0:maxR
                    block = img_left1(i:i+WSIZE,j+k:j+k+WSIZE);
                    [r , c] = size(block);
                    mb = mean(block(:));
                    mt = mean(template(:));
                    co = ((double(block(:,:)) - mb) .* (double(template(:,:)) - mt));

                    s = sum(co(:));
                    d = r * c;
                    corr = s / d;
                    arrSSD(k+1,1) = corr;
                end
                [value, index] = sort(arrSSD,'descend');
                disparityT(i,j) = index(1,1);
            end
            if (mod(i, 10) == 0)
               fprintf('%d rows remain\n', (rows - i)); 
            end
        end
        disparity = disparityT;
        image(disparity);
        title('Dispartiy map using Cross Correlation (CC)');
        timeElapsed = toc;
        fprintf('Elasped Time %f seconds\n',timeElapsed);
        fprintf('Window Size %i \n',WSIZE);
        fprintf('Disparity Range (Threshold) %i \n',range);
        run('errorDisparity.m');
    elseif strcmp(method,'NCC')
        tic;
        imgL = imread(img_left);
        imgR = imread(img_right);
        img_right1 = rgb2gray(imgR);
        img_left1 = rgb2gray(imgL);
        range = 100;
        WSIZE = 11;
        [rows,cols] = size(img_right1);
        disparityT = zeros(rows,cols);

        for i=1:rows-WSIZE
            for j=1:cols-WSIZE
                template = img_right1(i:i+WSIZE,j:j+WSIZE);
                maxR = min(range,((cols-WSIZE)-j));
                arrSSD = zeros(maxR, 1);
                for k=0:maxR
                    block = img_left1(i:i+WSIZE,j+k:j+k+WSIZE);
                    mb = mean(block(:));
                    mt = mean(template(:));
                    co = ((double(block(:,:)) - mb) .* (double(template(:,:)) - mt));
                    s = sum(co(:));
                    db = (double(block(:,:)) - mb);
                    dsb = sum(db(:).^2);
                    dt = (double(template(:,:)) - mt);
                    dst = sum(dt(:).^2);
                    dem = sqrt(dsb*dst);
                    ncorr = s / dem;
                    arrSSD(k+1,1) = ncorr;
                end
                [value, index] = sort(arrSSD,'descend');
                disparityT(i,j) = index(1,1);
            end
            if (mod(i, 10) == 0)
               fprintf('%d rows remain\n', (rows - i)); 
            end
        end
        disparity = disparityT;
        image(disparity);
        title('Dispartiy map using Normalized Cross Correlation (NCC)');
        timeElapsed = toc;
        fprintf('Elasped Time %f seconds\n',timeElapsed);
        fprintf('Window Size %i \n',WSIZE);
        fprintf('Disparity Range (Threshold) %i \n',range);
        run('errorDisparity.m');
    else
        disparity = 0;
        fprintf('error, invalid input');
    end
end

