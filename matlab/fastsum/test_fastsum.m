% Computes the sums
% 
%   f(y_j) = sum_{k=1}^N alpha_k kernel(x_k-y_j)   (j=1:M).
% 
% size(x) = [N,d]                 source knots in d-ball with radius 1/4-eps_b/2
% size(alpha) = [N,1] (complex)   source coefficients
% size(y)=[M,d]                   target knots in d-ball with radius 1/4-eps_b/2
% size(f) = [N,1] (complex)       target evaluations
% 
% d number of dimensions
% N number of source knots
% M number of target knots
% kernel = 'multiquadric', etc. (see options below)
% c kernel parameter
% n expansion degree
% m cut-off parameter for NFFT
% p degree of smoothness of regularization
% eps_I inner boundary
% eps_B outer boundary
% 
% Kernel functions:
% 'gaussian'                K(x) = EXP(-x^2/c^2) 
% 'multiquadric'            K(x) = SQRT(x^2+c^2)
% 'inverse_multiquadric'    K(x) = 1/SQRT(x^2+c^2)
% 'logarithm'               K(x) = LOG |x|
% 'thinplate_spline'        K(x) = x^2 LOG |x|
% 'one_over_square'         K(x) = 1/x^2
% 'one_over_modulus'        K(x) = 1/|x|
% 'one_over_x'              K(x) = 1/x
% 'inverse_multiquadric3'   K(x) = 1/SQRT(x^2+c^2)^3
% 'sinc_kernel'             K(x) = SIN(cx)/x
% 'cosc'                    K(x) = COS(cx)/x
% 'cot'                     K(x) = cot(cx)
% 'one_over_cube'           K(x) = 1/x^3

%% Initialize parameters
d=2;
N = 2000;
M = 2000;
kernel = 'multiquadric';
c = 1/sqrt(N);
m = 4;
p = 3;
n = 156;
eps_I = p/n;
eps_B = 1/16;

%random source nodes in circle of radius 0.25-eps_B/2
r = sqrt(rand(N,1))*(0.25-eps_B/2);
phi = rand(N,1)*2*pi;
x = [r.*cos(phi) r.*sin(phi)];
%random coefficients
alpha = rand(N,1) + 1i*rand(N,1);
%random target nodes in circle of radius 0.25-eps_B/2
r = sqrt(rand(M,1))*(0.25-eps_B/2);
phi = rand(M,1)*2*pi;
y = [r.*cos(phi) r.*sin(phi)];

%% Perform fastsum
plan=fastsum_init_guru(d,N,M,n,m,p,kernel,c,eps_I,eps_B);
fastsum_set_x(plan,x)
fastsum_set_y(plan,y)
fastsum_set_alpha(plan,alpha)

fastsum_trafo_direct(plan)   % direct computation
f_direct = fastsum_get_f(plan);

fastsum_trafo(plan)         % fast computation
f = fastsum_get_f(plan);
b = fastsum_get_b(plan);    % get expansion coefficients
fastsum_finalize(plan)

%% plot source and target evaluations
figure(1)
scatter(x(:,1),x(:,2),120,real(alpha),'.')
colorbar
figure(2)
scatter(y(:,1),y(:,2),120,real(f),'.')
colorbar