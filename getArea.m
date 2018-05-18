function [ area ] = getArea( G, S, weight )
%GETAREA Summary of this function goes here
%   Detailed explanation goes here
[height, width] = size(G);
G = [
    zeros(S(1),width+2*S(2));
    zeros(height, S(2)), G, zeros(height, S(2));
    zeros(S(1),width+2*S(2));
];
[height, width] = size(G);

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
    epsilon = 10;
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
    
    if centre(2)*centre(1)==0
        left = 1;
        right = 10;
        down = 1;
        up = 10;
    else
        up = centre(1);%floor(height / 2);
        down = centre(1);
        while (sum(G(up,:))>epsilon)+(sum(G(down,:))>epsilon)>0
            up = up + 1;
            down = down - 1;
            if (down == 1)+(up == height)>0
                break;
            end
        end
        
        left = centre(2);%(width / 2);
        right = centre(2);
        while (sum(G(centre(1):height,left))>epsilon)+(sum(G(centre(1):height,right))>epsilon)>0
            left = left - 1;
            right = right + 1;
            if (left == 1)+(right == width)>0
                break;
            end
        end
    end
end

if sum(S==[0 0])==2
    area = G(down:up, left:right);
else
    halfsize = S./2;
    area = G(centre(1)-halfsize(1):centre(1)+halfsize(1)-1, centre(2)-halfsize(2):centre(2)+halfsize(2)-1);
end
end
