function temp_predection(a)

%Task 3
%   temp_prediction(a) continuously reads temperature 
%   sensor via Arduino. It calculates the rate of change (°C/min) using 
%   a sliding window and linear fitting to reduce noise. 
%   The function prints current temperature, rate, and 5-minute prediction.
%   LED control: 
%     • Green (constant) if rate is stable (|rate| ≤ 4°C/min) and temp 18-24°C
%     • Red (constant) if rate > +4°C/min (rapid heating)
%     • Yellow (constant) if rate < -4°C/min (rapid cooling)
%
%   Usage: temp_prediction(a) in main script (Ctrl+C to stop)

    disp('Task3 temperature alarm');
    
    greenPin  = 'D9';
    yellowPin = 'D10';
    redPin    = 'D11';
    
    % initailiez LEDs
    writeDigitalPin(a, greenPin, 0);
    writeDigitalPin(a, yellowPin, 0);
    writeDigitalPin(a, redPin, 0);
    
   
    window_size = 60;               % 
    time_buf = zeros(1, window_size);
    temp_buf = zeros(1, window_size);
    buffer_idx = 0;
    start_time = tic;
    
    fprintf('collection data to calculate the changing rate...\n');
    
    while true
        voltage = readVoltage(a, 'A0');
        current_temp = (voltage - 0.5) / 0.01;
        current_t = toc(start_time);
        
        % update the buffer
        buffer_idx = mod(buffer_idx, window_size) + 1;
        time_buf(buffer_idx) = current_t;
        temp_buf(buffer_idx) = current_temp;
        %calculate the changing rate
        rate = 0;   
        if buffer_idx >= 30  
            % smoothen the noise spickes
            recent_idx = max(1, buffer_idx-29):buffer_idx;
            if length(recent_idx) > 1
                p = polyfit(time_buf(recent_idx), temp_buf(recent_idx), 1);
                rate_per_sec = p(1);                     
                rate = rate_per_sec * 60;            
            end
        end
        
        % 5 min prediction
        predicted_5min = current_temp + rate * 5;  
        
        % print on the screen
        fprintf('temperature now: %.2f °C | changing rate: %.2f °C/min | 5min perdiction: %.2f °C\n', ...
                current_temp, rate, predicted_5min);
        
        % LED contronl
        
        if abs(rate) > 4
            if rate > 4
                % rapid increase, lighten red
                writeDigitalPin(a, redPin, 1);
                writeDigitalPin(a, yellowPin, 0);
                writeDigitalPin(a, greenPin, 0);
            else
                %rapid decrease, lighten yellow
                writeDigitalPin(a, yellowPin, 1);
                writeDigitalPin(a, redPin, 0);
                writeDigitalPin(a, greenPin, 0);
            end
        else
            % stable changing rate, lightn green.
            if current_temp >= 18 && current_temp <= 24
                % tempreture in comfort zone, lightrn green
                writeDigitalPin(a, greenPin, 1);
                writeDigitalPin(a, yellowPin, 0);
                writeDigitalPin(a, redPin, 0);
            else
                % tempreture out of zone, all extinguish
                writeDigitalPin(a, greenPin, 0);
                writeDigitalPin(a, yellowPin, 0);
                writeDigitalPin(a, redPin, 0);
            end
        end
        
        pause(0.85); 
    end
end

