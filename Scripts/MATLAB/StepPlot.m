x = [2249, 4522, 7245];
y = [0.066, 0.201, 0.323];

scatter(x, y, 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'none', 'LineWidth', 2);
hold on;

x2 = [800, 1184, 1568];
y2 = [0.037, 0.058, 0.098];

scatter(x2, y2, 's', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'none', 'LineWidth', 2);

for i = 1:length(x)-1
    plot([x(i), x(i+1)], [y(i), y(i)], 'b', 'LineWidth', 3);
    plot([x(i+1), x(i+1)], [y(i), y(i+1)], 'b', 'LineWidth', 3);
end

for i = 1:length(x2)-1
    plot([x2(i), x2(i+1)], [y2(i), y2(i)], 'r', 'LineWidth', 3);
    plot([x2(i+1), x2(i+1)], [y2(i), y2(i+1)], 'r', 'LineWidth', 3);
end

xticks(union(x, x2));
yticks(union(y, y2));

xtickangle(270);
%ytickangle(45);

grid on;

xlabel('Public Key size (bytes)', 'FontSize', 14);
ylabel('Time (ms)', 'FontSize', 14);

title('Security Level Performance Comparison');

%set(gca, 'FontSize', 12);

h1 = plot(NaN,NaN,'b-o', 'MarkerFaceColor', 'none', 'LineWidth', 2);
h2 = plot(NaN,NaN,'r-s', 'MarkerFaceColor', 'none', 'LineWidth', 2);

legend([h1 h2], {'HQC', 'Kyber'}, 'Location', 'northwest', 'FontSize', 12);

saveas(gcf, 'SecurityLevelPerformanceComparison.png');

hold off;
