function [best_R1, best_R2, best_Vout, min_error] = find_best_pair(Vin, Vout_target, Rs)
% Поиск лучших номиналов резисторов для заданного Vin и Vout
% среди номиналов Rs

min_error = Inf;
best_R1 = 0;
best_R2 = 0;
best_Vout = 0;

for i = 1:length(Rs)
    R1 = Rs(i);
    for j = 1:length(Rs)
        R2 = Rs(j);
        Vout = Vin * R2 / (R1 + R2);
        err = abs(Vout - Vout_target);
        if err < min_error
            min_error = err;
            best_R1 = R1;
            best_R2 = R2;
            best_Vout = Vout;
        end
    end
end

end
