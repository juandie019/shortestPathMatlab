function PaintGraph(path)
    getAdMatriz = @() AdMatriz();
    
    adMatriz = getAdMatriz();

    G = graph(adMatriz, 'upper');
    h = plot(G,'Layout','force');
    highlight(h, path,'NodeColor','g','EdgeColor','g', 'LineWidth',1.7)
end