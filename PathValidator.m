function z = PathValidator(adMatriz, path)
    %getPenaltyValue = @() PenaltyValue();

    pathLength = size(path);
    x = 1;
    existsConection = true;
    cost = 0;
    
    while x < pathLength(2) && existsConection
        verticeCost = adMatriz(path(x), path(x + 1));
        if verticeCost > 0
            cost = cost + verticeCost;
        else
            existsConection = false;
            cost = 10000;
        end
        x = x + 1;
    end

    z = cost;
end