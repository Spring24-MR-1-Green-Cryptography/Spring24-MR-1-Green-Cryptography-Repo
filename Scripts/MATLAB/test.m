files = {'BIKE-L5_benchmark_data.csv', 'HQC-256_benchmark_data.csv', 'Classic-McEliece-6688128f_benchmark_data.csv', 'Kyber1024_benchmark_data.csv'};
algorithmNames = {'BIKE-L5', 'HQC-256', 'Classic-McEliece-6688128f', 'Kyber1024'};

dataTables = cell(length(files), 1);
for k = 1:length(files)
    dataTables{k} = readtable(files{k});
end

metrics = {'KeygenTime_ms_', 'EncryptionTime_ms_', 'DecryptionTime_ms_'};
metricNames = {'Key Generation Time', 'Encryption Time', 'Decryption Time'};

colors = lines(length(files));

for i = 1:length(metrics)
    metric = metrics{i};
    figLine = figure;
    
    for j = 1:length(dataTables)
        plot(dataTables{j}.Run, dataTables{j}.(metric), 'DisplayName', algorithmNames{j}, 'Color', colors(j, :)); hold on;
    end
    
    title([metricNames{i} ' Across Iterations']);
    xlabel('Iteration');
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