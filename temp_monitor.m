function temp_monitor(a)
disp('Task2 LED monitor');
    greenPin  = 'D9';
    yellowPin = 'D10';
    redPin    = 'D11';

    % initialize LEDs
    writeDigitalPin(a, greenPin, 0);
    writeDigitalPin(a, yellowPin, 0);
    writeDigitalPin(a, redPin, 0);
    
    % Intime graph 
    figure('Name', 'Indoor Temperature', 'Position', [100 100 900 550]);
    h = plot(0, 0, 'b-', 'LineWidth', 2.5);   
    xlabel('Time (s)');
    ylabel('Temperature (°C)');
    title('Real-time Temperature');
    grid on;
    xlim([0 60]);        
    ylim([10 35]);
    
    time_data = [];
    temp_data = [];
    start_time = tic;     
    
    while true
      
        voltage = readVoltage(a, 'A0');
        temp = (voltage - 0.5) / 0.01;
        
        current_time = toc(start_time);
        time_data(end+1) = current_time;
        temp_data(end+1) = temp;
        
%refresh the curve with latest 60 seconds
        set(h, 'XData', time_data, 'YData', temp_data);
        xlim([max(0, current_time-60), current_time + 5]);
        ylim([min(temp_data)-3, max(temp_data)+3]);
        drawnow;                   
        
    
        if temp >= 18 && temp <= 24
            % comforzone, green on
            writeDigitalPin(a, greenPin, 1);
            writeDigitalPin(a, yellowPin, 0);
            writeDigitalPin(a, redPin, 0);
        elseif temp < 18
            % coldzone, yellow on
            writeDigitalPin(a, greenPin, 0);
            writeDigitalPin(a, redPin, 0);
            writeDigitalPin(a, yellowPin, 1); pause(0.5);
            writeDigitalPin(a, yellowPin, 0); pause(0.5);
        else
            % hot zone, red on
            writeDigitalPin(a, greenPin, 0);
            writeDigitalPin(a, yellowPin, 0);
            writeDigitalPin(a, redPin, 1); pause(0.25);
            writeDigitalPin(a, redPin, 0); pause(0.25);
        end
        
     
        pause(0.85);
    end
   