global key;
global mode;
global go;
global last_color;
InitKeyboard;
brick.SetColorMode(1, 4);

last_color = 0;
mode = 1;
go = 1;

while go 
    while mode
        pause(0.05);
        Drive(brick,'AB', 0.5, 25,'Coast');
        [red,green,blue] = GetColorValue(brick);
        found_color = CheckColor(brick, red, green, blue);
        last_color = DoColorAction(brick, found_color, last_color);

        if key == 'q'
            brick.beep();
            mode = 0; % Exit the loop when 'q' is pressed
            disp(mode)
        end 
        if key == 'l'
            go = 0;
            brick.beep();
            disp("Program End");
            break;
        end
    end 
    while mode == 0
        pause(0.05)
        %[red,green,blue] = CheckColor(brick);
        switch key
            case 'uparrow'
                Drive(brick,'AB',0.5, 35,'Coast');
            case 'downarrow'
                Drive(brick,'AB',0.5, -35,'Coast');
            case 'leftarrow'
                TurnLeft(brick, 40, 85);
                %disp("LEFT ARROW PRESSED")
            case 'rightarrow'
                TurnRight(brick, 40, 85);
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
                brick.beep();
                mode = 1; %Stop remote control
            case 'l'
                go = 0;
                brick.beep();
                disp("Program End");
                break;
        end
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


function [red,green,blue] = GetColorValue(brick)
    current_color = 0;
    color_rgb = brick.ColorRGB(1);

    red = color_rgb(1);
    green = color_rgb(2);
    blue = color_rgb(3);
end

function [current_color] = CheckColor(brick, red, green, blue)
    if red > 30 && green > 30
        %brick.beep();
        current_color = 4;
        disp("Yellow");
    elseif red > green && red > blue && (blue < 50)
        %brick.beep();
        current_color = 1;
        %last_color = 1;
        disp("Red");
        disp(current_color);
    elseif green > red && green > blue
        %brick.beep();
        current_color = 3;
         %last_color = 3;
        disp("Green");
    elseif blue > green && blue> red
        %brick.beep();
        current_color = 2;
        %last_color = 2;
        disp("Blue");
    end 
    
end

function previous = DoColorAction(brick, current_color,previous_color)
    if current_color == 1 && previous_color ~= 1 
        pause(1.0);
    elseif current_color == 2 && previous_color ~= 2
        brick.StopMotor('AB', 'Brake');
        pause(0.2);
        brick.beep();
        pause(0.2);
        brick.beep();
    elseif current_color == 3 && previous_color ~= 3
        brick.StopMotor('AB', 'Brake');
        pause(0.2);
        brick.beep();
        pause(0.2);
        brick.beep();
        pause(0.2);
        brick.beep();
    elseif current_color == 4 && previous_color ~= 4
        mode = ChangeMode(0);
    end
    previous = current_color
end 

function car_mode = ChangeMode(mode_number)
    car_mode = mode_number
end