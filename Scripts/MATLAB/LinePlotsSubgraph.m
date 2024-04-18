bike = readtable('BIKE-L5_benchmark_data.csv');
hqc = readtable('HQC-256_benchmark_data.csv');
classic_mceliece = readtable('Classic-McEliece-6688128f_benchmark_data.csv');

metrics = {'KeygenTime_ms_', 'EncryptionTime_ms_', 'DecryptionTime_ms_'};
metricNames = {'Key Generation Time', 'Encryption Time', 'Decryption Time'};
algorithms = {'BIKE', 'HQC', 'Classic McEliece'};
data = {bike, hqc, classic_mceliece};

for i = 1:length(metrics)
    metric = metrics{i};
    
    fig = figure('Name', metricNames{i}, 'NumberTitle', 'off');
    
    for j = 1:length(algorithms)
        algorithm = algorithms{j};
        
        ax = subplot(length(algorithms), 1, j);
        hold(ax, 'on');
        
        plot(ax, 1:height(data{j}), data{j}.(metric), '-o', 'DisplayName', algorithm);
        
        title(sprintf('%s - %s', algorithm, metricNames{i}));
        xlabel('Run');
        ylabel('Time (ms)');
        legend('Location', 'NorthEast');
        hold(ax, 'off');
    end
    
    fig.Position = [100, 100, 800, 900];

    saveas(fig, [metricNames{i} '_LinePlotComparison.png']);
end
