function time_delta = estimate_execution_time(N)
if N <= 0
    error("Value of N must be greater than 0");
end
M = 5000;

t = (N^(16/11) + N^((pi^2)/8)) / 1000;

time_delta = t - M;

end