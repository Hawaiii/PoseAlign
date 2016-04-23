function transmat = pose2transformation(pose)
% Input:
%   1x7 array: translation, quaternion, x,y,z;x,y,z,w
% return 4x4 Transformation matrix
R = qGetR(pose(1,4:end));
assert(abs(det(R) - 1 ) < 0.1)
transmat = [horzcat(R, -R*pose(1,1:3)');0, 0, 0, 1];
end