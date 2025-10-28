brick.SetColorMode(1, 4);
%color = brick.ColorCode(1);

Drive(brick, 'AB', 0.25, 20, 'Coast')

% 0 = other, 1 = red, 2 = blue, 3 = green, 4 = yellow
%current_color = 0;
%color_rgb = brick.ColorRGB(1);

%red = color_rgb(1);
%green = color_rgb(2);
%blue = color_rgb(3);

[red,green,blue] = CheckColor(brick);

fprintf("\tRed: %d\n",  red);
fprintf("\tGreen: %d\n", green);
fprintf("\tBlue: %d\n", blue);




%Drive(brick, 'AB',0.3, -15, 'Coast');

%if current_color == 1
%    Drive(brick, 'AB', 0.3, -15, 'Coast');
%elseif current_color == 2
%    TurnLeft(brick, 40, 50);
%elseif current_color == 3
%    TurnRight(brick,40, 50);
%elseif current_color == 4
%    display("Yellow Found ")
%    brick.beep();
%   brick.beep();
%end

disp("Function Finished")



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

function [red, green, blue] = CheckColor(brick)
    current_color = 0;
    color_rgb = brick.ColorRGB(1);

    red = color_rgb(1);
    green = color_rgb(2);
    blue = color_rgb(3);

    if red > 30 && green > 30
        %brick.beep();
        current_color = 4
        disp("Yellow");
    elseif red > green && red > blue && (blue < 50)
        %brick.beep();
        current_color = 1;
        disp("Red");
        disp(current_color);
    elseif green > red && green > blue
        %brick.beep();
        current_color = 3;
        disp("Green");
    elseif blue > green && blue> red
        %brick.beep();
        current_color = 2;
        disp("Blue");
    end 
    
    if current_color == 1
        pause(1.0);
    elseif current_color == 2
        brick.StopMotor('AB', 'Brake');
        pause(0.2);
        brick.beep();
        pause(0.2);
        brick.beep();
    elseif current_color == 3
        brick.StopMotor('AB', 'Brake');
        pause(0.2);
        brick.beep();
        pause(0.2);
        brick.beep();
        pause(0.2);
        brick.beep();
    end

end