function plot_transformations(trans_list)
% plots the [[R|-Rt]; 0 0 0 1] transformations
figure()
hold on
loc = zeros(3,size(trans_list,3));
for i = 1:size(trans_list,3)
    loc(:,i) = -trans_list(1:3,1:3,i)'*trans_list(1:3,4,i);
end
%quiver3( loc(1,:), loc(2,:), loc(3,:),...
%        reshape(trans_list(1,1,:),1,[]), reshape(trans_list(2,1,:),1,[]), reshape(trans_list(3, 1, :),1,[]), 'r'); %z
%quiver3( loc(1,:), loc(2,:), loc(3,:),...
%        reshape(trans_list(1,2,:),1,[]), reshape(trans_list(2,2,:),1,[]), reshape(trans_list(3, 2, :),1,[]), 'g'); %z
quiver3( loc(1,:), loc(2,:), loc(3,:),...
        reshape(trans_list(1,3,:),1,[]), reshape(trans_list(2,3,:),1,[]), reshape(trans_list(3, 3, :),1,[]), 'b'); %z
plot3(loc(1,:),loc(2,:),loc(3,:))
axis equal
end