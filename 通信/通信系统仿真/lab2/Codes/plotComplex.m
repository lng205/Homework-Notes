function plotComplex(x,y)
    plot3(x, zeros(size(x)), zeros(size(x)), '-k'); 
    ylabel('imag(y)'); zlabel('real(y)');
    axis square; zoom on; grid on; hold on;
    for k=1:length(x)
        plot3([x(k) x(k)],[0 imag(y(k))],[0 real(y(k))],'-b');
        plot3( x(k), imag(y(k)), real(y(k)), 'bo');
    end
    hold off;
end