function [peak_ind,tau,estimated_channel] = decoder(T,v,Stau,cha_vol,check)
%%
% T : time(s)
% v : voltage(mV)
% Stau : relaxation time for each channel
% cha_vol : The boundary between characteristic peak and auxiliary peak
% check : If the calculated relaxation time value is judged to be an outlier for some reason, 
%         recalculate the next 'check' number.
%%
figure;hold on;
plot(T,v,'k') % plot voltage v

peak_ind = []; % initialization of peak index (size = number of peak)
tau =[]; % initialization of relaxation time
signind = []; 

for st = 4:length(v)
    % It is determined whether the voltage of the corresponding time step is a peak voltage according to the following conditions.
    if (v(st-1) > 5) & (((v(st-1)-v(st-2)) > 1)|(v(st-1)-v(st-3))>0.2) & (sign(v(st-2)-v(st-1)) ~= sign(v(st-1)-v(st))) & (v(st-2)-v(st-1)<0) & (v(st-1) ~= v(st))
        tau2 = 0.002/log(v(st-1)/v(st)); % Calculate the relaxation time
        for ch = 1:check% If the calculated relaxation time value is judged to be an outlier for some reason, 
                        % recalculate the next 'check' number.
            if tau2 > 0.2 | tau2 <0
               tau2 = 0.002/log(v(st+ch-1)/v(st+ch)); 
            end
        end
        peak_ind = [peak_ind; st-1]; % stack recent index to peak index variable 
        tau = [tau; tau2]; % stack recent relaxation time to relaxation time vairalbe
    end
    if sign(v(st-2)-v(st-1)) ~= sign(v(st-1)-v(st)) 
       signind = [signind; st-1]; % To find the peak voltage, find all time points where the sign changes
    end
    
end

% find voltage level
for i = 1:length(peak_ind)
    tmp = find(signind==peak_ind(i)); % peak index
    peak_voltage(i)=v(signind(tmp))-v(signind(tmp-1)); % index which sign is changed 
    plot(T(signind(tmp)),v(signind(tmp)),'r*','MarkerSize',5)
    plot(T((signind(tmp-1))),v((signind(tmp-1))),'g*','MarkerSize',5)
end

disp(peak_voltage) 
estimated_channel = dsearchn(Stau,tau);
estimated_channel(peak_voltage < cha_vol) = 1;
disp([tau estimated_channel])

end