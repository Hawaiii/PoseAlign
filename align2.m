data = csvread('dump1.log');
vtk3_ver = 0
orb_ver = 2 % ekf=1, orb=2
MAX_LIMIT = 10000000000000;

t_vtk3 = [];
t_vtk3_list = zeros(4,4,0);
t_orb = [];
t_orb_list = zeros(4,4,0);
tmp_idx = 0;
cnt = 1;
i = 1;
%while i < 100
while i < size(data,1)
    if data(i, 2) == vtk3_ver
        tmp_idx = data(i,3);
        t_vtk3 = pose2transformation(data(i, 4:end));
    else
        if data(i,3) ~= tmp_idx,
            tmp_idx = data(i,3);
        else
            if data(i,2) == orb_ver
                t_orb = pose2transformation(data(i,4:end));
                t_vtk3_list(:,:,end+1) = t_vtk3;
                t_orb_list(:,:,end+1) = t_orb;
                 i = 50 + i;
            end
        end
    end
%     if mod(i,100) == 0
%         i
%     end
    i = i+1;
end
% load('transform_stream_ekf.mat')

% plot_transformations(t_vtk3_list)
% plot_transformations(t_orb_list)

assert(size(t_orb_list,3) == size(t_vtk3_list,3));
A = zeros(4,4,0);
B = zeros(4,4,0);

for i = 1: size(t_orb_list,3) -1 
    A(:,:,end+1) = t_orb_list(:,:,i)*inv(t_orb_list(:,:,i+1));
    B(:,:,end+1) = t_vtk3_list(:,:,i)*inv(t_vtk3_list(:,:,i+1));
end

% A = rand(4,4,1);
% T = rand(4,4,1);
% B = T*A*inv(T)
AAA = zeros(0, 16);

for x = 1 : min( size(A,3), MAX_LIMIT)
    for i = 1:4
        for j = 1:4
            ARow = [zeros(1,4*(j-1)) ,A(:,i,x)', zeros(1,4*(4-j))];
            BRow = [zeros(1,(i-1)), B(j,1,x), zeros(1,(4-i)),...
                    zeros(1,(i-1)), B(j,2,x), zeros(1,(4-i)),...
                    zeros(1,(i-1)), B(j,3,x), zeros(1,(4-i)),...
                    zeros(1,(i-1)), B(j,4,x), zeros(1,(4-i))];
            AAA(end+1, :) = ARow - BRow;
        end
    end
end

% rank_ = rank(AAA)
% [u,s,v] = svd(AAA);
% solu = reshape(v(:,end),4,4)';
% res = solu./solu(4,4);
% [u,s,v] = svd(solu(1:3,1:3));
% R = u*eye(3)*v'
% T = res(1:3,4)

C = AAA;
d = zeros(size(AAA,1),1);
A_ = zeros(1,16);
b_ = Inf;
eq = [zeros(3,4);ones(1,4)]';
Aeq = diag(eq(:));

Beq = zeros(16,1);
Beq(end) = 1;

X = lsqlin(C,d,A_,b_,Aeq,Beq);
solu = reshape(X,4,4)';
[u,s,v] = svd(solu(1:3,1:3));
R = u * eye(3) * v';
solu(1:3,1:3) = R;
solu

% Plot difference
diff = zeros(1, size(A, 3));
for i = 1:size(A,3)
    diff(1,i) = sum(sum(abs(solu * A(:,:,i) - B(:,:,i)*solu)));
end
plot(diff)

