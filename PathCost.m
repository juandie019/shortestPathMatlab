function z = PathCost(x, startNode, endNode)
    getMatriz = @() AdMatriz();
    getPathCost = @(x, y) PathValidator(x, y);
    getUniqueList = @(x) UniqueList(x);
    %getPenaltyValue = @() PenaltyValue();

    adTable = getMatriz();
    newList = getUniqueList(x);
    
    listLength = size(newList);
    startPosition = newList(1);
    endPosition = newList(listLength(2));
    
    if startPosition == startNode && endPosition == endNode
        z = getPathCost(adTable, newList);
    else
        z = 10000;
    end
      
end

