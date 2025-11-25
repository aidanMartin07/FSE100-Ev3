global key;
InitKeyboard();

brick.ResetMotorAngle('AB');

while 1
    pause(0.1)
    switch key
        case 'uparrow'
            %Drive(brick,'AB',0.5, 25,'Coast');
            brick.MoveMotor('A',20);
            brick.MoveMotor('B',20);
        case 'downarrow'
            %Drive(brick,'AB',0.5, -25,'Coast');
            brick.MoveMotor('A', -20);
            brick.MoveMotor('B', -20);
        case 'leftarrow'
            %TurnLeft(brick, 40, 90);
            brick.MoveMotor('A', -25);
            brick.MoveMotor('B', 25);
            %disp("LEFT ARROW PRESSED")
        case 'rightarrow'
            %TurnRight(brick, 40, 90);
            brick.MoveMotor('A', 25);
            brick.MoveMotor('B', -25);
        case 'w'
            Drive(brick, 'AB', 0.5, 15, 'Coast');
        case 's'
            Drive(brick, 'AB', 0.5,-15, 'Coast');
        case 'a'
    %        TurnLeft(brick, 40, 50);
            brick.MoveMotor('A', 25);
            brick.MoveMotor('B', -25);
            pause(1.32)
            brick.StopMotor('AB', 'Brake');
        case 'd'
            %TurnRight(brick,40,50);
            %%brick.MoveMotor('B', -18.5);
            %brick.StopMotor('B', 'Brake');
            %brick.MoveMotor('A', 20);
            %brick.MoveMotor('B', 20);
            brick.MoveMotor('A', -25);
            brick.MoveMotor('B', 25);
            pause(1.32);
            brick.StopMotor('AB', 'Brake');
        case 'p'
            MoveLift(brick, 10);
        case 'o'
            MoveLift(brick, -10);
        case 'q'
            break;
        case 'z'
            brick.StopMotor('AB', 'Brake');
        case 0 
            disp('none pressed');
        
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