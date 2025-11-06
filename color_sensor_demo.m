brick.SetColorMode(1, 4);
brick.ResetMotorAngle('AB');
global mode;
last_seen = 0;
% 0 = other, 1 = red, 2 = blue, 3 = green, 4 = yellow, 5 = black ground


mode = 1;

%Drive(brick, 'AB', 0.25, 20, 'Coast')

%current_color = 0;
%color_rgb = brick.ColorRGB(1);

%red = color_rgb(1);
%green = color_rgb(2);
%blue = color_rgb(3);

%[red,green,blue] = CheckColor(brick);

%fprintf("\tRed: %d\n",  red);
%fprintf("\tGreen: %d\n", green);
%fprintf("\tBlue: %d\n", blue);

%car loop 
%car drives and checks color underneath it 
%stops once car sees color yellow
while mode
    %car moves for one second then checks if color has changed
    %if color is different than last do color action
    Drive(brick, 'AB', 0.5, 20, 'Coast'); 
    
    %check colors and do color action
    [red,green,blue] = GetColorValue(brick);
    found_color = CheckColor(brick, red, green, blue);
    last_seen = DoColorAction(brick, found_color, last_seen)

    %if found yellow stop car
    if found_color == 4
        display("Yellow Found Stop")
        brick.beep();
        mode = 0;
        break;
    end
    %break;
end 


disp("Function Finished")



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


function MoveLift(brick, speed)
    brick.MoveMotor('C', speed);
    pause(0.15);
    brick.StopMotor('C', 'Coast')
end


function [red,green,blue] = GetColorValue(brick)
    current_color = 0;
    color_rgb = brick.ColorRGB(1);

    red = color_rgb(1);
    green = color_rgb(2);
    blue = color_rgb(3);
end

function [current_color] = CheckColor(brick, red, green, blue)
    %compares color values in vector
    %determines what color seen

    current_color = 0;
    if red > 30 && green > 30 && blue < 15
        current_color = 4
        disp("Yellow");
    elseif red > 30 && green < 15 && blue < 15 && red < 50
        %red > green && red > blue && (blue < 20) && (green < 30)
        current_color = 1;
        disp("Red");
        disp(current_color);
    elseif green > red && green > blue
        current_color = 3;
        disp("Green");
    elseif blue > green && blue> red
        current_color = 2;
        disp("Blue");
    else 
        %brick.beep();
        current_color = 0;
        disp("No Color")
    end 
    
end

function previous = DoColorAction(brick, current_color,previous_color)
    if current_color == 1 && previous_color ~= 1 
        brick.StopMotor('AB');
        pause(1.0);
    elseif current_color == 2 && previous_color ~= 2
        brick.StopMotor('AB', 'Brake');
        for i = 1:2
            pause(0.2);
            brick.beep();
        end
    elseif current_color == 3 && previous_color ~= 3
        brick.StopMotor('AB', 'Brake');
        for i = 1:3
            pause(0.2);
            brick.beep();
        end 
    elseif current_color == 4 && previous_color ~= 4
        mode = ChangeMode(0);
    end
    previous = current_color
end 

function car_mode = ChangeMode(mode_number)
    car_mode = mode_number
end