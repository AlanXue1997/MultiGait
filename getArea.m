function [ area ] = getArea( G, S, weight )
%GETAREA Summary of this function goes here
%   Detailed explanation goes here

[height, width] = size(G);

if weight && sum(S~=[0 0]) == 2
    half = sum(sum(G))/2;
    eax = 0;
    centre = [0 0];
    k = 0;
    while eax<half
        k = k + 1;
        eax = eax + sum(G(k,:));
    end
    centre(1) = k;
    eax = 0;
    k = 0;
    while eax<half
        k = k + 1;
        eax = eax + sum(G(:,k));
    end
    centre(2) = k;
else
    for i=1:width
        if sum(G(:,i))>0
            left = i;
            break
        end
    end

    for i=width:-1:1
        if sum(G(:,i))>0
            right = i;
            break
        end    
    end

    for i = 1:height
        if sum(G(i, :))>0
            up = i;
            break
        end        
    end

    for i=height:-1:1
        if sum(G(i, :))>0
            down = i;
            break
        end        
    end
    centre = [(up+down)/2, (left+right)/2];
end

if sum(S==[0 0])==2
    area = G(up:down, left:right);
else
    halfsize = S./2;
    area = G(centre(1)-halfsize(1):centre(1)+halfsize(1)-1, centre(2)-halfsize(2):centre(2)+halfsize(2)-1);
end
end

