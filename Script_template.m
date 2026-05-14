% Liu Zhaoli
%ssyzl40@nottingham.edu.cn


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]
a=arduino("COM4","Uno");
writeDigitalPin(a,'D8',1);
writeDigitalPin(a,'D8',0);

for i=1:10;
writeDigitalPin(a, 'D8', 1);    
pause(0.5);
writeDigitalPin(a, 'D8', 0);
pause(0.5);
end %spark test 
disp('test end')


%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
%b) creat duration and read voltage vaule
duration=600; 
time_data=zeros(1,duration);
temp_data=zeros(1,duration);
disp('temp data collection for 10 min start')
for i=1:duration 
v=readVoltage(a,'A0');% read voltage A0
temp=(v-0.5)/0.01;
time_data(i)=i-1;
temp_data(i)=temp;
if mod (i,60)==0 %show progress every 60 seconds
   fprintf('%d min have passed...\n', i/60);
end
pause (0.9);
end
% statistic data
max_temp = max(temp_data);
min_temp = min(temp_data);
avg_temp = mean(temp_data);
fprintf('\ncollection finished\nMax temp = %.2f °C\nMin temp = %.2f °C\nAverage temp = %.2f °C\n', ...
        max_temp, min_temp, avg_temp);
%c) stick a temp-time curve and save a graph
figure('Name', 'Capsule Temperature', 'Position', [95 105 855 500]);
plot(time_data, temp_data, 'b-', 'LineWidth', 2.5);
xlabel('Time (s)');
ylabel('Temperature (°C)');
title(' Indoor Temperature during 10 minutes');
grid on;
xlim([0 duration]);
ylim([floor(min(temp_data))-2, ceil(max(temp_data))+2]);

saveas(gcf, 'Indoor Temperature during 10 minutes_plot.png');
disp('temp curve saved as:Indoor Temperature during 10 minutes_plot.png');

% d) display a formate on screen
fprintf('\nData logging initiated - %s\n', datestr(now, 'dd/mm/yyyy'));
fprintf('Location - UNNC');

for minute = 0:10
    idx = minute * 60 + 1;
    if idx > length(temp_data)
        idx = length(temp_data);
    end
    fprintf('Minute\t%d\nTemperature\t%.2f C\n\n', minute, temp_data(idx));
end

fprintf('Max temp\t%.2f C\n', max_temp);
fprintf('Min temp\t%.2f C\n', min_temp);
fprintf('Average temp\t%.2f C\n\n', avg_temp);
fprintf('Data logging terminated\n');

%e) wrieing data into a txt file
fileID = fopen('capsule_temperature.txt', 'w');
fprintf(fileID, 'Data logging initiated - %s\n', datestr(now, 'dd/mm/yyyy'));
fprintf(fileID, 'Location - UNNC');

for minute = 0:10
    idx = minute * 60 + 1;
    if idx > length(temp_data)
        idx = length(temp_data);
    end
    fprintf(fileID, 'Minute\t%d\nTemperature\t%.2f C\n\n', minute, temp_data(idx));
end

fprintf(fileID, 'Max temp\t%.2f C\n', max_temp);
fprintf(fileID, 'Min temp\t%.2f C\n', min_temp);
fprintf(fileID, 'Average temp\t%.2f C\n', avg_temp);
fprintf(fileID, '\nData logging terminated\n');

fclose(fileID);
%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

temp_monitor(a);   


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

temp_predection(a);

%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

