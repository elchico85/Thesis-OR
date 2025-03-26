function stop = ackleyout(x, ~, state)
    persistent ph
    stop = false;
    
    switch state
        case 'init'
            newplot
            xx = -5:0.1:5;
            yy = -5:0.1:5;
            [xx,yy] = meshgrid(xx,yy);
            zz = -20*exp(-0.2*sqrt(0.5*(xx.^2+yy.^2))) - exp(0.5*(cos(2*pi*xx)+cos(2*pi*yy))) + exp(1) + 20;
            
            surface(xx,yy,zz,'EdgeColor',[0.8,0.8,0.8]);
            xlabel('x(1)')
            ylabel('x(2)')
            title('Ackley Function Optimization')
            view(20,35)
            colormap(jet)
            hold on
            
            [~,contHndl] = contour3(xx,yy,zz,[5,10,15],'k');
            contHndl.Color = [0.8,0.8,0.8];
            
            plot3(2,2,ackley(2,2),'ko','MarkerSize',15,'LineWidth',2);
            text(1.8,2.2,ackley(2,2),'   Start','Color',[0 0 0]);
            
            plot3(0,0,0,'ko','MarkerSize',15,'LineWidth',2);
            text(-0.5,0.5,0,'   Solution','Color',[0 0 0]);
            
            drawnow

        case 'iter'
            x1 = x(1);
            y1 = x(2);
            z1 = -20*exp(-0.2*sqrt(0.5*(x1^2+y1^2))) - exp(0.5*(cos(2*pi*x1)+cos(2*pi*y1))) + exp(1) + 20;
            ph = plot3(x1,y1,z1,'r.','MarkerSize',25);
            
            h = gca;
            h.SortMethod = 'childorder';
            drawnow;

        case 'done'
            legend(ph,'Iterative steps','Location','northeast')
            hold off
    end
    
    function f = ackley(x,y)
        f = -20*exp(-0.2*sqrt(0.5*(x.^2+y.^2))) - exp(0.5*(cos(2*pi*x)+cos(2*pi*y))) + exp(1) + 20;
    end
end