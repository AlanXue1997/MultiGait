function [ area ] = getArea2( G, S, weight, number )
%GETAREA Summary of this function goes here
%   Detailed explanation goes here


% G = [
%     zeros(S(1),width+2*S(2));
%     zeros(height, S(2)), G, zeros(height, S(2));
%     zeros(S(1),width+2*S(2));
% ];
% G = [
%     zeros(G(1),width+2*G(2));
%     zeros(height, G(2)), G, zeros(height, G(2));
%     zeros(G(1),width+2*G(2));
% ];
[height, width] = size(G);
% if number==2
%     G = [zeros(floor(height/4),width);G;zeros(floor(height/4),width)];
%     [height, width] = size(G);
%     G = [zeros(height,floor(width/4)) G zeros(height,floor(width/4))];
%     [height, width] = size(G);
% end

if weight && sum(S~=[0 0]) == 2
    half = sum(sum(G))/2;
    eax = 0;
    centre = [0 0];
    k = S(1);
    while eax<half
        k = k + 1;
        eax = eax + sum(G(k,:));
    end
    centre(1) = k;
    eax = 0;
    k = S(2);
    while eax<half
        k = k + 1;
        eax = eax + sum(G(:,k));
    end
    centre(2) = k;
else
    left = floor(width / 2);
    for i=1:width
        if sum(G(:,i))>0
            left = i;
            break
        end
    end
    
    right = left+1;
    for i=width:-1:1
        if sum(G(:,i))>0
            right = i;
            break
        end    
    end
    
    up = floor(height / 2);
    for i = 1:height
        if sum(G(i, :))>0
            up = i;
            break
        end        
    end

    down = up-1;
    for i=height:-1:1
        if sum(G(i, :))>0
            down = i;
            break
        end        
    end
    
    if number==2
        G = G(up:down, left:right);
         [height, width] = size(G);
        G = [zeros(height,width);G;zeros(height,width)];
        [height, width] = size(G);
        G = [zeros(height,width) G zeros(height,width)];
        [height, width] = size(G);
        
        left = floor(width / 2);
        for i=1:width
            if sum(G(:,i))>0
                left = i;
                break
            end
        end

        right = left+1;
        for i=width:-1:1
            if sum(G(:,i))>0
                right = i;
                break
            end    
        end

        up = floor(height / 2);
        for i = 1:height
            if sum(G(i, :))>0
                up = i;
                break
            end        
        end

        down = up-1;
        for i=height:-1:1
            if sum(G(i, :))>0
                down = i;
                break
            end        
        end
    
%         half = sum(sum(G))/2;
%         eax = 0;
%         centre = [0 0];
%         k = S(1);
%         while eax<half
%             k = k + 1;
%             eax = eax + sum(G(k,:));
%         end
%         centre(1) = k;
%         eax = 0;
%         k = S(2);
%         while eax<half
%             k = k + 1;
%             eax = eax + sum(G(:,k));
%         end
%         centre(2) = k;
    end
    
    %centre = [(up+down)/2, (left+right)/2];
end

if number==1
    area = G(up:down, left:right);
elseif number==2
    %halfsize = [(up-down)/2 floor((right-left)/2)];
    %area = G(floor(centre(1)-halfsize(1)):floor(centre(1)+halfsize(1)), floor(centre(2)-halfsize(2)):floor(centre(2)+halfsize(2)));
    centre = G./2;
    disp(left);
    disp(right);
    disp(centre(2))
    
    if abs(centre(1)-up)>abs(centre(1)-down)
        down = centre(1)+abs(centre(1)-up);
    else
        up = centre(1)-abs(centre(1)-down);
    end
    if abs(centre(2)-left)>abs(centre(2)-right)
        right = centre(2)+abs(centre(2)-left);
    else
        left = centre(2)-abs(centre(2)-right);
    end
    disp(left);
    disp(right);
    area = G(up:down, left:right);
% else
%     halfsize = S./2;
%     area = G(centre(1)-halfsize(1):centre(1)+halfsize(1)-1, centre(2)-halfsize(2):centre(2)+halfsize(2)-1);
%     area = area*triu(ones(S(2)))>0;
%     area = 1-area;
    %w=fspecial('gaussian',[15 5],3);
    % w=fspecial('disk',10);
    %area=imfilter(area,w);
    %area = area>0.9;
end
end
