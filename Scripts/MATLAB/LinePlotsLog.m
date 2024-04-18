bike = readtable('BIKE-L5_benchmark_data.csv');
hqc = readtable('HQC-256_benchmark_data.csv');
classic_mceliece = readtable('Classic-McEliece-6688128f_benchmark_data.csv');

metrics = {'KeygenTime_ms_', 'EncryptionTime_ms_', 'DecryptionTime_ms_'};
metricNames = {'Key Generation Time', 'Encryption Time', 'Decryption Time'};
algorithms = {'BIKE', 'HQC', 'Classic McEliece'};
colors = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250];

for i = 1:length(metrics)
    metric = metrics{i};
    figLine = figure;
    plot(bike.Run, bike.(metric), '-r', 'DisplayName', 'BIKE'); hold on;
    plot(hqc.Run, hqc.(metric), '-g', 'DisplayName', 'HQC');
    plot(classic_mceliece.Run, classic_mceliece.(metric), '-b', 'DisplayName', 'Classic McEliece');
    title([metricNames{i} ' Across Runs']);
    xlabel('Run');
    ylabel('Time (ms)');

    if strcmp(metric, 'EncryptionTime_ms_')
        set(gca, 'YScale', 'linear');
    else
        set(gca, 'YScale', 'log');
    end

    legend('Location', 'eastoutside');
    
    grid on;
    hold off;
    saveas(figLine, sprintf('LinePlot_%s.png', strrep(metricNames{i}, ' ', '_')));
end
