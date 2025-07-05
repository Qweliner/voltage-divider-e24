%% voltage_divider_calc.m
% Программа подбора делителя напряжения на двух резисторах по формуле:
% Vout = Vin * (R2 / (R1 + R2))
% Используется ряд E24 (из файла e24.txt или е24.txt)
% Работает в консоли, запускается нажатием F5
% Автор: Ваше Имя


% -------- Ввод данных --------
Vin = input('Введите входное напряжение Vin (В): ');
Vout_target = input('Введите желаемое выходное напряжение Vout (В): ');

if isempty(Vin) || ~isnumeric(Vin) || Vin <= 0 || isempty(Vout_target) || ~isnumeric(Vout_target) || Vout_target <= 0 || Vout_target >= Vin
    fprintf('Ошибка: проверьте корректность Vin и Vout (0 < Vout < Vin).\n');
    return;
end

% -------- Загрузка ряда E24 --------
filename_list = {'e24.txt', 'е24.txt'}; % Латинская и кириллическая "е"
e24_loaded = false;
for i = 1:length(filename_list)
    if exist(filename_list{i}, 'file')
        fid = fopen(filename_list{i}, 'r'); raw = fscanf(fid, '%f'); fclose(fid);
        e24 = raw(:)'; e24_loaded = true; break;
    end
end
if ~e24_loaded
    error('Не найден файл с рядом E24: e24.txt или е24.txt');
end

% -------- Подготовка списка номиналов --------
muls = 10 .^(-1:5);  % от 0.1 Ом до 1 МОм
all_Rs = unique(kron(e24, muls));
Rs_main  = all_Rs(all_Rs >= 10);   % приоритет: >=10 Ом
Rs_spare = all_Rs(all_Rs <  10);   % запасные: <10 Ом

% -------- Поиск оптимальной пары --------
[R1, R2, Vout, err] = find_best_pair(Vin, Vout_target, Rs_main);
% если ошибка слишком велика, позволяем <10 Ом
if err > 0.05 * Vout_target && ~isempty(Rs_spare)
    [r1_alt, r2_alt, v_alt, e_alt] = find_best_pair(Vin, Vout_target, all_Rs);
    if e_alt < err
        R1 = r1_alt; R2 = r2_alt; Vout = v_alt; err = e_alt;
    end
end

% -------- Вывод результатов --------
fprintf('\nРезультаты расчета делителя напряжения (ряд E24):\n');
fprintf('  Vin           = %.2f В\n', Vin);
fprintf('  Vout заданное = %.2f В\n\n', Vout_target);

fprintf('Подобранные номиналы резисторов:\n');
fprintf('  R1 = %s\n', format_resistor(R1));
fprintf('  R2 = %s\n', format_resistor(R2));

fprintf('Полученное Vout  = %.2f В\n', Vout);
fprintf('Абсолютная ошибка = %.2f В\n', abs(Vout - Vout_target));