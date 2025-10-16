global key;
InitKeyboard;

while 1
    pause(0.1)
    switch key
        case 'uparrow'
            Drive(brick,'AB',0.5, -25,'Coast');
        case 'downarrow'
            Drive(brick,'AB',0.5, 15,'Coast');
        case 'leftarrow'
            brick.MoveMotorAngleRel('A', 50, 180,'Coast');
            brick.MoveMotorAngleRel('B', -50, 180, 'Coast');
            brick.WaitForMotor('A');
            brick.WaitForMotor('B');
        case 'rightarrow'
            brick.MoveMotorAngleRel('A', -50, 180,'Coast');
            brick.MoveMotorAngleRel('B', 50, 180, 'Coast');
            brick.WaitForMotor('A');
            brick.WaitForMotor('B');
        case 'p'
            brick.MoveMotor('C', 10);
            pause(0.75);
            brick.StopMotor('C', 'Coast')
        case 'o'
            brick.MoveMotor('C', -10);
            pause(0.75);
            brick.StopMotor('C','Coast');
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
end

function Turn(brick, motors, speed, angle)
    brick.MoveMotorAngleRel('A', 50, 180,'Coast');
    brick.MoveMotorAngleRel('B', -50, 180, 'Coast');
    brick.WaitForMotor('A');
    brick.WaitForMotor('B');
end