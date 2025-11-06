global key;
%car state 0 = idle, 1 = moving, 2 = turning, 3 = picking up,
global state; 
%last color seen 0 = none, 1 = red, 2 = blue, 3 = green 4 = yellow
%yellow is starting location
%red is stop for 1 second
%blue is pickup location switch to remote
%green is drop off
global last_seen; 
%determines if code is beign executed
global go; 
%determines if should be in remote control
global remote;

InitKeyboard;

%reset car components to default vals
brick.ResetMotorAngle('ABC');
brick.SetColorMode(1,4);
brick.GyroCalibrate(2);
angle = brick.GyroAngle(2);
disp(angle);
angle = 0

state = 0;
last_seen =0;
go = 1;
remote = 0;

brick.beep();
% main loop once exited car should stop all together
while go
    %loop for when car is not remote controlled
    while remote == 0 
        pause(0.05);
        [red, green, blue] = GetColorValue(brick);
        found_color = CheckColor(brick, red, green, blue);

        if found_color == 2
            remote = 1;
        end

        last_seen = DoColorAction(brick, found_color, last_seen);
        angle = brick.GyroAngle(2);
        distance = brick.UltrasonicDist(4);
        disp(distance)
        if distance < 25
            TurnNinety(brick, 0, 40);
        else 
            Drive(brick,'AB', 1, 35, 'Coast');
        end
        
        if key == 'q'
            remote = 1;
        end
        if key == 'z'
            go = 0;
            break;
        end

    end
    %loop for when car in remote control
    while remote
        pause(0.05)
     
        switch key 
            case 'uparrow'
                Drive(brick, 'AB', 1, 30, 'Coast')
            case 'downarrow'
                Drive(brick, 'AB', 1, -30, 'Coast')
            case 'leftarrow'
                TurnLeft(brick, 30, 90);
            case 'rightarrow'
                TurnRight(brick,30 ,90);
            case 'w'
                Drive(brick, 'AB', 0.5, 20, 'Coast');
            case 's'
                Drive(brick, 'AB', 0.5, -20, 'Coast');
            case 'a'
                TurnLeft(brick, 30 ,30);
            case 'd'
                TurnRight(brick, 30 ,30);
            case 'p'
                MoveLift(brick, 10); 
            case 'o'
                MoveLift(brick, -10)
            case 'l'
                remote = 0;
        end

    end


end

CloseKeyboard();

%{
car functions
Drive, Turn Left, Turn Right, Turn Ninety, Color Sensing, Change car mode
%}

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
        brick.beep();
        brick.beep();
    elseif current_color == 3 && previous_color ~= 3
        brick.StopMotor('AB', 'Brake');
        Drive(brick, 'AB', 1, 30, 'Coast');
        pause(0.5)
        MoveLift(brick, 15);
        pause(0.5)
        Drive(brick, 'AB', 1.5, -30, 'Coast');
        pause(0.5)
        MoveLift(brick,-15);
        TurnNinety(brick, 0,50);
        TurnNinety(brick, 0,50);
    elseif current_color == 4 && previous_color ~= 4
        mode = ChangeMode(0);
    end
    previous = current_color
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

function car_mode = ChangeMode(mode_number)
    car_mode = mode_number
end

function SolveMaze(brick)
    
end