function stop = bealeout(x, optimValues, state)
    persistent hSurf hPlot hText
    
    stop = false;
    
    switch state
        case 'init'
            % Inizializzazione figura e superficie
            figure
            [X,Y] = meshgrid(linspace(-4.5,4.5,100), linspace(-4.5,4.5,100));
            Z = (1.5 - X + X.*Y).^2 + (2.25 - X + X.*Y.^2).^2 + (2.625 - X + X.*Y.^3).^2;
            
            hSurf = surf(X,Y,Z,'EdgeColor','none','FaceAlpha',0.7);
            colormap(jet)
            colorbar
            hold on
            title('Optimization path of Beale Function')
            xlabel('x_1'), ylabel('x_2'), zlabel('f(x)')
            view(3)
            
            % Inizializza percorso
            hPlot = plot3(x(1),x(2),optimValues.fval,'ro-',...
                'MarkerSize',8,'MarkerFaceColor','r','LineWidth',1.5);
            
            % Annotazione testuale
            hText = text(-4,4,200,...
                sprintf('Iter: 0\nfval: %.2f',optimValues.fval),...
                'Color','w','FontSize',12);
            
        case 'iter'
            % Aggiorna percorso
            xData = [get(hPlot,'XData') x(1)];
            yData = [get(hPlot,'YData') x(2)];
            zData = [get(hPlot,'ZData') optimValues.fval];
            
            set(hPlot,'XData',xData,'YData',yData,'ZData',zData)
            set(hText,'String',sprintf('Iter: %d\nfval: %.4f',...
                optimValues.iteration,optimValues.fval))
            drawnow
            
        case 'done'
            % Aggiungi marker finale
            plot3(x(1),x(2),optimValues.fval,'gh',...
                'MarkerSize',20,'MarkerFaceColor','y')
            legend(hPlot,'Optimization path','Location','best')
            hold off
    end
end