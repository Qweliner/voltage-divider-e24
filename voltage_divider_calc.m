%% voltage_divider_calc.m
% ��������� ������� �������� ���������� �� ���� ���������� �� �������:
% Vout = Vin * (R2 / (R1 + R2))
% ������������ ��� E24 (�� ����� e24.txt ��� �24.txt)
% �������� � �������, ����������� �������� F5
% �����: ���� ���


% -------- ���� ������ --------
Vin = input('������� ������� ���������� Vin (�): ');
Vout_target = input('������� �������� �������� ���������� Vout (�): ');

if isempty(Vin) || ~isnumeric(Vin) || Vin <= 0 || isempty(Vout_target) || ~isnumeric(Vout_target) || Vout_target <= 0 || Vout_target >= Vin
    fprintf('������: ��������� ������������ Vin � Vout (0 < Vout < Vin).\n');
    return;
end

% -------- �������� ���� E24 --------
filename_list = {'e24.txt', '�24.txt'}; % ��������� � ������������� "�"
e24_loaded = false;
for i = 1:length(filename_list)
    if exist(filename_list{i}, 'file')
        fid = fopen(filename_list{i}, 'r'); raw = fscanf(fid, '%f'); fclose(fid);
        e24 = raw(:)'; e24_loaded = true; break;
    end
end
if ~e24_loaded
    error('�� ������ ���� � ����� E24: e24.txt ��� �24.txt');
end

% -------- ���������� ������ ��������� --------
muls = 10 .^(-1:5);  % �� 0.1 �� �� 1 ���
all_Rs = unique(kron(e24, muls));
Rs_main  = all_Rs(all_Rs >= 10);   % ���������: >=10 ��
Rs_spare = all_Rs(all_Rs <  10);   % ��������: <10 ��

% -------- ����� ����������� ���� --------
[R1, R2, Vout, err] = find_best_pair(Vin, Vout_target, Rs_main);
% ���� ������ ������� ������, ��������� <10 ��
if err > 0.05 * Vout_target && ~isempty(Rs_spare)
    [r1_alt, r2_alt, v_alt, e_alt] = find_best_pair(Vin, Vout_target, all_Rs);
    if e_alt < err
        R1 = r1_alt; R2 = r2_alt; Vout = v_alt; err = e_alt;
    end
end

% -------- ����� ����������� --------
fprintf('\n���������� ������� �������� ���������� (��� E24):\n');
fprintf('  Vin           = %.2f �\n', Vin);
fprintf('  Vout �������� = %.2f �\n\n', Vout_target);

fprintf('����������� �������� ����������:\n');
fprintf('  R1 = %s\n', format_resistor(R1));
fprintf('  R2 = %s\n', format_resistor(R2));

fprintf('���������� Vout  = %.2f �\n', Vout);
fprintf('���������� ������ = %.2f �\n', abs(Vout - Vout_target));