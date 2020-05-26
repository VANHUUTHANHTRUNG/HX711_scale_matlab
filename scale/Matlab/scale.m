clc
%% Set up Serial Port
comPort = "COM3";
% Initialize Serial arduino
delete(instrfindall);
arduino = serial(comPort);
set(arduino,'DataBits',8);
set(arduino,'StopBits',1);
set(arduino,'BaudRate',9600);
set(arduino,'Parity','none');
fopen(arduino);
data = zeros(1,2);
%% set up plot
figure
h = animatedline;
ax = gca;
ax.YGrid = 'on';
ax.YLim = [-2 10];
%% receive data
time = 0;
TIME_OUT = 5;
while(time < TIME_OUT )
    s = fscanf(arduino,"%s");
    read_data = split(s,":");
    disp(s);
    time =  str2double(read_data(1)); 
    weight = str2double(read_data(2));
    tempt_array = [time,weight];
    data = [data;tempt_array]; %#ok<AGROW>
    % draw data line
    addpoints(h,time,weight);
    drawnow;
    
end
fclose(arduino);
%% draw with smoothed value
figure
plot(data(:,1),data(:,2),':',data(:,1),smooth(data(:,2)),'--');
ylabel('weight(kg)');
xlabel('time(s)');
title('Weight monitoring');
legend('original','smoothed');


%% Save data to .mat file
active_file_name = matlab.desktop.editor.getActiveFilename();
[filepath,name,ext] = fileparts(active_file_name);
export_time = datestr(now,'HH_MM_SS_AM_dd_mm_yyyy');
export_path = filepath + "\" + "weight_" + export_time +".mat";
disp("Saved file to: " + export_path);
save(export_path,'data','-v7.3');

