function [tangentialPointsX,tangentialPointsY, wrongPos] = getTangentialPointsToObstacles(robotPositionX, robotPositionY,...
                                                 obstaclesPositionsX, obstaclesPositionsY, obstaclesRadius)
% The tangential points to the obstacles will be calculated

% Input:
% robotPositionX: position of the robot (x coordinate)
% robotPositionY: position of the robot (y coordinate)
% obstaclesPositionsX: position of the obstacles (x coordinate), Vector: 1*nObstacles
% obstaclesPositionsY: position of the obstacles (y coordinate), Vector: 1*nObstacles
% obstaclesRadius: radii of obstacles, Vector: 1*nObstacles


% Output:
% tangentialPointsX : tangential points of the obstacles in x coordinates, MATRIX: 2*nObstacles
% tangentialPointsY : tangential points of the obstacles in y coordinates, MATRIX: 2*nObstacles

nObstacles=size(obstaclesPositionsX,2);
tangentialPointsX=zeros(2,nObstacles);
tangentialPointsY=zeros(2,nObstacles);


%old code
% for iObstacles=1:nObstacles
%
%     if(wrongpos(obstaclesPositionsX(iObstacles),obstaclesPositionsY(iObstacles),obstacleRadius(iObstacles),robotPositionX,robotPositionY)) % ha rossz helyen van az akad�ly
%         error('Error : Az akad�ly  rajta van a roboton, ez hib�s eset\n');
%     else
%         thx=(obstaclesPositionsX(iObstacles)+robotPositionX)/2;  % thalesz k�r x k�z�ppontja
%         thy=(obstaclesPositionsY(iObstacles)+robotPositionY)/2;  % thalesz k�r y k�z�ppontja
%         syms x y;
%         eq1 = (x-obstaclesPositionsX(iObstacles)).^2 + (y-obstaclesPositionsY(iObstacles)).^2 == obstacleRadius(iObstacles).^2;% norm�l akad�ly k�regyenlete
%         eq2 = (x-thx).^2 + (y-thy).^2 == (sqrt((obstaclesPositionsX(iObstacles)-robotPositionX).^2+(obstaclesPositionsY(iObstacles)-robotPositionY)^2)/2).^2; % Thalesz k�r k�regyenlete
%
%         [x, y] = vpasolve(eq1, eq2, x, y); % megoldjuk az egyenletet, v�geredm�ny az �rint�si pontok
%         tangentialPointsX(:,iObstacles) = x;  % visszat�r�si �rt�k
%         tangentialPointsY(:,iObstacles) = y;  % visszat�r�si �rt�k
%     end
%
% end


if(wrongpos(robotPositionX,robotPositionY,obstaclesPositionsX,obstaclesPositionsY,obstaclesRadius)) % ha rossz helyen van az akad�ly
    wrongPos = 1;
    %error('Error : The obstacle is on the robot, it is a bad situation\n');
else
wrongPos = 0;
distanceRobotObstacles = distance(obstaclesPositionsX,obstaclesPositionsY, robotPositionX,robotPositionY);

distanceRobotTangentialPoints = sqrt(distanceRobotObstacles.^2 - obstaclesRadius.^2); % distance between the robot pos and the angential point
anglesRobObst = atan2((obstaclesPositionsY-robotPositionY),(obstaclesPositionsX-robotPositionX)); % angles between the robot and the obstacles
angles = asin(obstaclesRadius./distanceRobotObstacles); % how big is the angle between the line of the robotObstacle - and robotTangentialPoint

tangentialPointsX = [ distanceRobotTangentialPoints.*cos(anglesRobObst-angles)+robotPositionX;...
                      distanceRobotTangentialPoints.*cos(anglesRobObst+angles)+robotPositionX ]; % visszat�r�si �rt�k
tangentialPointsY = [ distanceRobotTangentialPoints.*sin(anglesRobObst-angles)+robotPositionY;...  % visszat�r�si �rt�k
                      distanceRobotTangentialPoints.*sin(anglesRobObst+angles)+robotPositionY; ]; % visszat�r�si �rt�k
end 
end

function badPos=wrongpos(robotPositionX,robotPositionY,obstaclesPositionsX,obstaclesPositionsY,obstacleRadius)
% This function will see if the obstacles are in a good position, if one of the obstacles is on the robot,
%the function will return with 1

% Input:
%   robotPositionX: position of the robot (x coordinate)
%   robotPositionY: position of the robot (y coordinate)
%   obstaclesPositionsX: x center point of obstacles
%   obstaclesPositionsY: y center point of obstacles
%   obstacleRadius: radii of obstacles

% Output
%   badPos: 1 bit, the value is 1 if the obstacle is on the robot

r_a=distance(obstaclesPositionsX,obstaclesPositionsY,robotPositionX, robotPositionY); % the distance of the robot and the centerpoint of the obstacles
if (sum(r_a<obstacleRadius)) % if one of the obstacle is on the robot, then the motion planning is not feasable
    badPos=1;
else
    badPos=0;
end
end


