load('transform_stream_ekf.mat');

A = t_vtk3_list(1:3,1:3,:);
B = -t_orb_list(1:3,1:3,:); %negative already added
big_mat = zeros(0, 18);
for t = 1:size(t_orb_list,3),
    pt_mat = [A(1,1,t), 0, 0, A(1,2,t), 0, 0, A(1,3,t), 0, 0, B(1,1,t), B(2,1,t), B(3,1,t), 0, 0, 0, 0, 0, 0;...
        A(2,1,t), 0, 0, A(2,2,t), 0, 0, A(2,3,t), 0, 0, 0, 0, 0, B(1,1,t), B(2,1,t), B(3,1,t), 0, 0, 0;...
        A(3,1,t), 0, 0, A(3,2,t), 0, 0, A(3,3,t), 0, 0, 0, 0, 0, 0, 0, 0, B(1,1,t), B(2,1,t), B(3,1,t);...
        0, A(1,1,t), 0, 0, A(1,2,t), 0, 0, A(1,3,t), 0, B(1,2,t), B(2,2,t), B(3,2,t), 0, 0, 0, 0, 0, 0;...
        0, A(2,1,t), 0, 0, A(2,2,t), 0, 0, A(2,3,t), 0, 0, 0, 0, B(1,2,t), B(2,2,t), B(3,2,t), 0, 0, 0;...
        0, A(3,1,t), 0, 0, A(3,2,t), 0, 0, A(3,3,t), 0, 0, 0, 0, 0, 0, 0, B(1,2,t), B(2,2,t), B(3,2,t);...
        0, 0, A(1,1,t), 0, 0, A(1,2,t), 0, 0, A(1,3,t), B(1,3,t), B(2,3,t), B(3,3,t), 0, 0, 0, 0, 0, 0;...
        0, 0, A(2,1,t), 0, 0, A(2,2,t), 0, 0, A(2,3,t), 0, 0, 0, B(1,3,t), B(2,3,t), B(3,3,t), 0, 0, 0;...
        0, 0, A(3,1,t), 0, 0, A(3,2,t), 0, 0, A(3,3,t), 0, 0, 0, 0, 0, 0, B(1,1,t), B(2,1,t), B(3,1,t)];
    big_mat = [big_mat; pt_mat];
end
[U, S, V] = svd(big_mat);
solu = V(:,end);
T_orb_headset = reshape(solu(1:9,:),3,3)';
T_slam_mocap = reshape(solu(10:18,:),3,3)';

[u,s,v] = svd(T_orb_headset);
T_orb_headset = u * v';
[u,s,v] = svd(T_slam_mocap);
T_slam_mocap = u * v';
save('rot_align3.mat', 'T_orb_headset', 'T_slam_mocap', 'solu');

err_aft_projection = zeros(size(t_orb_list,3),9);
for t = 1:size(t_orb_list,3)
    err_aft_projection(t,:) = reshape(A(:,:,t)*T_orb_headset + B(:,:,t)*T_slam_mocap, 1, 9);
end

plot(err_aft_projection(:,1))
plot(err_aft_projection(:,2))
plot(err_aft_projection(:,3))
plot(err_aft_projection(:,4))
plot(err_aft_projection(:,5))
plot(err_aft_projection(:,6))
plot(err_aft_projection(:,7))
plot(err_aft_projection(:,8))
plot(err_aft_projection(:,9))