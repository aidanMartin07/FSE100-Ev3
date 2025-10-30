global key;
global state;

state = 0; %0 = idle, 1 = moving, 2 = turning
%Drive(brick,'AB',0.5, 35,'Coast');
InitKeyboard;

while 1
    pause(0.05);
    distance = brick.UltrasonicDist(4);
    disp(distance)

    if distance >40 && state ~= 1
        state = 1
        Drive(brick,'AB',0.5, 35,'Coast');
        %pause(1);
        %waitFor; % Wait for the drive to complete
        state = 0; % Reset state to idle
    elseif distance < 40 && distance > 30
        state = 2
        disp("Turning")
        TurnLeft(brick, 40, 85);
        state = 0
    end

    if key == 'q'
        break;
    end 
end 
CloseKeyboard;

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