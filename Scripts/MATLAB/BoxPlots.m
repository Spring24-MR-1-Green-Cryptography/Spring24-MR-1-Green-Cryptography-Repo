bike = readtable('BIKE-L5_benchmark_data.csv');
hqc = readtable('HQC-256_benchmark_data.csv');
classic_mceliece = readtable('Classic-McEliece-6688128f_benchmark_data.csv');

metrics = {'KeygenTime_ms_', 'EncryptionTime_ms_', 'DecryptionTime_ms_'};
metricNames = {'Key Generation Time', 'Encryption Time', 'Decryption Time'};
algorithms = {'BIKE', 'HQC', 'Classic McEliece'};

for i = 1:length(metrics)
    metric = metrics{i};
    fig = figure;

    boxData = [bike.(metric); hqc.(metric); classic_mceliece.(metric)];
    groups = [repmat({'BIKE'}, height(bike), 1); repmat({'HQC'}, height(hqc), 1); repmat({'Classic McEliece'}, height(classic_mceliece), 1)];
    boxplot(boxData, groups, 'Notch', 'on', 'Labels', algorithms);
    title([metricNames{i} ' Distribution']);
    ylabel('Time (ms)');
    set(gca, 'YScale', 'log');

    saveas(fig, [metricNames{i} '_Distribution_LogScale.png']);
end
