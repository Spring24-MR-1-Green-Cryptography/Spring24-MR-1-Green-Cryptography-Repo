bike = readtable('BIKE-L5_benchmark_data.csv', 'NumHeaderLines', 1);
hqc = readtable('HQC-256_benchmark_data.csv', 'NumHeaderLines', 1);
classic_mceliece = readtable('Classic-McEliece-6688128f_benchmark_data.csv', 'NumHeaderLines', 1);

bikeAvg = mean(table2array(bike(:, 2:end)), 1);
hqcAvg = mean(table2array(hqc(:, 2:end)), 1);
classicAvg = mean(table2array(classic_mceliece(:, 2:end)), 1);

bikeAvg = bikeAvg([2 3 1]);
hqcAvg = hqcAvg([2 3 1]);
classicAvg = classicAvg([2 3 1]);

data = [bikeAvg; hqcAvg; classicAvg];
labels = {'BIKE-L5', 'HQC-256', 'Classic McEliece-6688128f'};

figure;
bar(data, 'stacked');
set(gca, 'YScale', 'log');
set(gca, 'XTickLabel', labels, 'XTick', 1:length(labels));
ylabel('Time (ms) (log scale)');
title('Cryptographic Algorithms Performance Comparison');
legend('Encryption Time', 'Decryption Time', 'Keygen Time', 'Location', 'northwest');
grid on;

saveas(gcf, 'BarGraph.png');