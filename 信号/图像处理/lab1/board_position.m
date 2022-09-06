function im = board_position(row,col)

    % Load Image
    im = imread('./images/chess.png');
    
    % Obtain the size of the image
    [rows, columns] = size(im);
    
    % Calculate the board size 
    %计算棋盘格边长
    board_size = rows/8;
    
    % Calculate the require position
    %计算所求格坐标
    row_start = row * board_size + 1;
    col_start = col * board_size + 1;
    
    row_end = row_start + board_size - 1;
    col_end = col_start + board_size - 1;
    
    %分离所求格
    im_crop = im(row_start : row_end,col_start:col_end,:);

    %转为灰度图
    im_gray = rgb2gray(im_crop);
    
    % Detemien how many zero(white) values in the image
    n = nnz(im_gray);%非黑色像素数
    m = numel(im_gray);%总像素数
    

    if all(im_gray(:) == im_gray(1))
        disp('Empty board');%全像素灰度相同时显示空棋盘格
    else
        white_pixel = (n/m) * 100;
        
        if white_pixel > 80 %非黑色像素比例大于80%视作白棋，否则视作黑棋
            disp('white piece');
        else
            disp('black piece');
        end
    end
    
    % Display the croped image
    imshow(im_gray)

end