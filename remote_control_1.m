global key;
InitKeyboard;

brick.ResetMotorAngle('AB');

while 1
    pause(0.1)
    switch key
        case 'uparrow'
            Drive(brick,'AB',0.5, 25,'Coast');
        case 'downarrow'
            Drive(brick,'AB',0.5, -25,'Coast');
        case 'leftarrow'
            TurnLeft(brick, 40, 90);
            %disp("LEFT ARROW PRESSED")
        case 'rightarrow'
            TurnRight(brick, 40, 90);
        case 'w'
            Drive(brick, 'AB', 0.5, 15, 'Coast');
        case 's'
            Drive(brick, 'AB', 0.5,-15, 'Coast');
        case 'a'
            TurnLeft(brick, 40, 50);
        case 'd'
            TurnRight(brick,40,50);
        case 'p'
            MoveLift(brick, 10);
        case 'o'
            MoveLift(brick, -10);
        case 0 
            disp('none pressed');
        case 'q'
            break;
    end
end
CloseKeyboard();

function Drive(brick, motors, time, speed, stop)
    %disp('Function Run')
    brick.MoveMotor(motors, speed);
    pause(time);
    brick.StopMotor(motors, 'Coast');
    brick.ResetMotorAngle('AB')
end

function Turn(brick, speed, angle)
    brick.MoveMotorAngleAbs('A', 20, -90, 'Brake');
    brick.WaitForMotor('A');
    brick.ResetMotorAngle('A');
   % brick.MoveMotorAngleAbs('B', speed, angle, 'Coast');
   % brick.WaitForMotor('B');
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


function MoveLift(brick, speed)
    brick.MoveMotor('C', speed);
    pause(0.15);
    brick.StopMotor('C', 'Coast')
end