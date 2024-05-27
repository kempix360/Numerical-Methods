fun = @tan;
start_points = [6.0, 4.5];
options = optimset('Display', 'iter');

for i = 1:length(start_points)
    fprintf('Analiza dla punktu startowego x0 = %.1f:\n', start_points(i));
    fzero(fun, start_points(i), options);
    fprintf('\n');
end
