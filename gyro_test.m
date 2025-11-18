
brick.GyroCalibrate(2);
brick.ResetMotorAngle('AB');

angle = brick.GyroAngle(2);
%disp(angle);
angle = 0;

while 1
    angle = brick.GyroAngle(2);
    pause(0.05);
    touch = brick.TouchPressed(4);
    %Drive(brick, 'AB', 1 , 30, 'Coast');
    disp(angle)
    if touch
        brick.beep()
        break;
    end
    

end

%{
TurnLeft(brick, 50, 420);
angle = brick.GyroAngle(2);
disp(angle);
brick.GyroCalibrate(2);
angle = brick.GyroAngle(2);
disp(angle);




while angle < 90
    TurnRight(brick,30,60);
    angle = brick.GyroAngle(2);
    disp(angle);
end 
%}
%TurnNinety(brick, 0, 50);
%TurnNinety(brick, 1, 50);
%TurnNinety(brick, 1, 50);



function Drive(brick, motors, time, speed, stop)
    %disp('Function Run')
    brick.MoveMotor(motors, speed);
    pause(time);
    brick.StopMotor(motors, 'Coast');
    brick.ResetMotorAngle('AB')
end

function TurnLeft(brick, speed, angle)
    brick.MoveMotorAngleAbs('A', speed, angle,'Brake');
    brick.WaitForMotor('A');
    brick.ResetMotorAngle('A');
end

function TurnRight(brick, speed, angle)
    brick.MoveMotorAngleAbs('B', speed, angle,'Brake');
    brick.WaitForMotor('B');
    brick.ResetMotorAngle('B');
end

function TurnNinety(brick, dir, speed)
    angle = brick.GyroAngle(2);
    if isnan(angle)
        angle = 0;
    end
    %dir = 0 turn right
    %dir = 1 turn left
    if dir == 0 
        TurnRight(brick,speed,420);
        angle = brick.GyroAngle(2);
        angleDiff = 90 - double(abs(angle));
        TurnRight(brick,25,angleDiff * 4);

        %if angle < 90 && angle > 80
        %    TurnRight(brick, 25, 45);
        %end
    else
        TurnLeft(brick, speed, 420);
        angle = brick.GyroAngle(2);
        angleDiff = 90 - double(abs(angle));
        TurnLeft(brick,25, angleDiff* 4);
        %if angle > -90 && angle < -80
        %    TurnLeft(brick,25,45);
        %end
    end
    disp(angle)
    brick.GyroCalibrate(2);
end