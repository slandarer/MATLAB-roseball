function roseball(varargin)
% roseball - Create a 3D roseball visualization (创建 3D 玫瑰花球)
%   roseball() creates a roseball with default colormap in the current axes.
%   在当前坐标区使用默认配色创建玫瑰花球。
%
%   roseball(CList) creates a roseball in the current axes using the
%   specified colormap matrix CList.
%   在当前坐标区使用指定的配色矩阵 CList 创建玫瑰花球。
%
%   roseball(ax, CList) creates a roseball in the specified axes using
%   the given colormap matrix.
%   在指定坐标区使用给定的配色矩阵创建玫瑰花球。


% Zhaoxu Liu / slandarer (2026). roseball 
% (https://www.mathworks.com/matlabcentral/fileexchange/93510-roseball), 
% MATLAB Central File Exchange. Retrieved April 15, 2026.
ax = gca; CList = [.02 .04 .39; .02 .06 .69; .01 .26 .99; .17 .69 1];
if nargin >= 1 && isa(varargin{1}, 'matlab.graphics.axis.Axes')
    ax = varargin{1};
    if nargin >= 2
        CList = varargin{2};
    end
elseif nargin >= 1
    CList = varargin{1};
    if nargin >= 2
        ax = varargin{2};
    end
end
hold(ax, 'on'); 
ax.View = [11, -.07]; 
axis(ax, 'equal')
axis(ax, 'off')

% Basic surface
[x, t] = meshgrid((0:24)./24, (0:.5:575)./575.*20.*pi + 4*pi);
p = (pi/2)*exp(-t./(8*pi));
u = 1 - (1 - mod(3.6*t, 2*pi)./pi).^4./2 + sin(15*t)/150;
y = 2*(x.^2 - x).^2.*sin(p);
r = u.*(x.*sin(p) + y.*cos(p));
h = u.*(x.*cos(p) - y.*sin(p)) + .35;
x = r.*cos(t); y = r.*sin(t);

% Rotation matrix
Rx = @(rx) [1, 0, 0; 0, cos(rx), -sin(rx); 0, sin(rx), cos(rx)];
Rz = @(yz) [cos(yz), - sin(yz), 0; sin(yz), cos(yz), 0; 0, 0, 1];
Rx1 = Rx(pi - acos(- 1/sqrt(5)));
Rz1 = Rz(2*pi/5); Rz2 = Rz(pi/5);

prop = {'EdgeAlpha',.05, 'EdgeColor','none', ...
        'FaceColor','interp', 'CData',H2C(h, CList)};
surf(ax, x, y,   h, prop{:})
surf(ax, x, y, - h, prop{:})
[U, V, W] = matRotate(x, y, h, Rx1);
for k = 1:5, [U, V, W] = matRotate(U, V, W, Rz1); surf(ax, U, V,   W, prop{:}), end
[U, V, W] = matRotate(U, V, W, Rz2);
for k = 1:5, [U, V, W] = matRotate(U, V, W, Rz1); surf(ax, U, V, - W, prop{:}), end

    function C = H2C(H, cL)
        X = rescale(H, 0, 1);
        C = interp1(rescale(1:size(cL, 1), 0, 1), cL, X);
    end

    function [U, V, W] = matRotate(X, Y, Z, R)
        U = X; V = Y; W = Z;
        for i = 1:numel(X)
            v = [X(i); Y(i); Z(i)];
            n = R*v; U(i) = n(1); V(i) = n(2); W(i) = n(3);
        end
    end

end