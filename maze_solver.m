global go; % 1 if car loop running
global remote; %1 if car is remote controlled
global key;
global last_seen;
global searching;
global color_counts;

searching = 1;
last_seen = 0;
go = 1;
remote = 0;
color_counts = [1,0,0];






a_s = 30; %motor A speed
b_s = 30; %motor B speed

InitKeyboard();

brick.SetColorMode(1,4);

while go 
    while remote ==0 
        brick.MoveMotor('A', b_s);
        brick.MoveMotor('B',b_s);
    
        touch = brick.TouchPressed(4);
        %color = brick.ColorCode(1);
        dist = brick.UltrasonicDist(2);

        [red, green, blue] = GetColorValue(brick);
        found_color = CheckColor(brick, red, green, blue);

        if found_color == 2
            remote = 1;
        end

        if found_color == 4 && searching == 0
            go = 0;
            break;
        end

        last_seen = DoColorAction(brick, found_color, last_seen);
%{
        disp(color);
        if color ==5
            brick.beep();
            brick.StopMotor('AB', 'Brake');
            pause(1);
            brick.MoveMotor('A', a_s);
            brick.MoveMotor('B', a_s);
            pause(0.5);
        elseif color == 2 || color == 3
            disp("blue or green");
            brick.StopMotor('AB', 'Brake');
            remote = 1;
            
        end
%}
        

        if dist > 50 
            pause(0.75);
            brick.StopMotor('AB', 'Brake');
            brick.MoveMotor('A', -20);
            TurnNinety(brick,1, 30);
            brick.MoveMotor('A',a_s);
            brick.MoveMotor('B', b_s);
            pause(2);
        end

        if touch %if touch sensor activated
            pause(1);
            brick.StopMotor('AB','Brake');
            %dist = brick.UltrasonicDist(2);
            brick.MoveMotor('A', -1 * a_s);
            brick.MoveMotor('B', -1* b_s);
            pause(3.0); %move backwards from wall
            brick.StopMotor('AB', 'Brake');
            %Turn right if wall
            brick.MoveMotor('A', -25);
            brick.MoveMotor('B', 25);
            pause(1.32)
            brick.StopMotor('AB', 'Brake');
            
            if distance < 50 % if no wall on left
                %TurnNinety(brick,0, 30);
                
                brick.MoveMotor('B', -18.5);
                brick.StopMotor('B', 'Brake');
                brick.MoveMotor('A', a_s);
                brick.MoveMotor('B', b_s);
                
                pause(2);
            else
                %TurnNinety(brick,1,30);
                
                brick.MoveMotor('A', -18.5);
                brick.StopMotor('A', 'Brake');
                brick.MoveMotor('B', b_s);
                brick.MoveMotor('A', a_s);
                
                pause(2);
            end
            
        end

    end
    while remote == 1
        
        pause(0.1);
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
                brick.MoveMotor('A', -20);
                brick.MoveMotor('B', 20);
                %disp("LEFT ARROW PRESSED")
            case 'rightarrow'
                %TurnRight(brick, 40, 90);
                brick.MoveMotor('A', 20);
                brick.MoveMotor('B', -20);
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
            case 'z'
                brick.StopMotor('AB', 'Brake');
            case 'p'
                MoveLift(brick, 10); 
            case 'o'
                MoveLift(brick, -10)
            case 'n'
                TurnNinety(brick, 0, 40);
            case 'm'
                TurnNinety(brick, 1 , 40);
            case 'l'
                remote = 0;
            case 'k'
                go = 0;
                brick.StopMotor('AB', 'Brake');
                break;
        end
    end

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
    global color_counts;

    current_color = 0;
    if red > 30 && green > 30 && blue < 15 
        current_color = 4
        disp("Yellow");
    elseif red > 15 && green < 15 && blue < 15 && red < 50
        %red > green && red > blue && (blue < 20) && (green < 30)
        current_color = 1;
        disp("Red");
        brick.beep()
        disp(current_color);
    elseif green > red && green > blue && green >= 15 && color_counts(3)== 0
        current_color = 3;
        color_counts(3)= 1;
        disp("Green");
    elseif blue > green && blue> red && blue >= 15 && color_counts(2) ==0
        current_color = 2;
        color_counts(2) = 1;
        disp("Blue");
    else 
        %brick.beep();
        current_color = 0;
        disp("No Color")
    end 
    
end

function previous = DoColorAction(brick, current_color,previous_color)
    global searching;
    global remote;

    if current_color == 1 && previous_color ~= 1 
        brick.StopMotor('AB');
        pause(1.0);
    elseif current_color == 2 && previous_color ~= 2
        brick.StopMotor('AB', 'Brake');
        brick.beep();
        brick.beep();
        searching = 2;
        remote = 1;
    elseif current_color == 3 && previous_color ~= 3
        brick.StopMotor('AB', 'Brake');
        %{
        Drive(brick, 'AB', 1, 30, 'Coast');
        pause(0.5)
        MoveLift(brick, 15);
        pause(0.5)
        Drive(brick, 'AB', 1.5, -30, 'Coast');
        pause(0.5)
        MoveLift(brick,-15);
        TurnNinety(brick, 0,50);
        TurnNinety(brick, 0,50);
        %}
        remote = 1;
        searching = 0;
    elseif current_color == 4 && previous_color ~= 4 && searching == 0
        mode = ChangeMode(0);
    end
    previous = current_color;
end 

CloseKeyboard();
%{
function CenterCar(brick)
    angle = brick.GyroAngle(2);
    if isnan(angle)
        return;
    end
    %right on negative
    %left on positive 
    disp("Correcting Angle")
    disp(angle)
    if(angle > 15)
        brick.StopMotor('AB');
        TurnRight(brick, 30, double(angle*2));
        brick.GyroCalibrate(2);
    end

    if(angle < -15)
       brick.StopMotor('AB');
       TurnLeft(brick,30,double(abs(angle*2)));
       brick.GyroCalibrate(2);
    end
end
%}

function TurnNinety(brick, dir, speed)
%{
    angle = brick.GyroAngle(2);
    if isnan(angle)
        angle = 0;
    end
%}
    %dir = 0 turn right
    %dir = 1 turn left
    if dir == 0 
        TurnRight(brick,speed,460);
        %angle = brick.GyroAngle(2);
        %angleDiff = 90 - double(abs(angle));
        %TurnRight(brick,25,angleDiff * 4);

        %if angle < 90 && angle > 80
        %    TurnRight(brick, 25, 45);
        %end
    else
        TurnLeft(brick, speed, 520);
        %angle = brick.GyroAngle(2);
        %angleDiff = 90 - double(abs(angle));
        %TurnLeft(brick,25, angleDiff* 4);
        %if angle > -90 && angle < -80
        %    TurnLeft(brick,25,45);
        %end
    end
    %disp(angle)
    %brick.GyroCalibrate(2);
end

function car_mode = ChangeMode(mode_number)
    car_mode = mode_number
end

