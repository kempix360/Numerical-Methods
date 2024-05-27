function impedance_delta = impedance_magnitude(omega)

R = 525;
C = 7*1E-5;
L = 3;
M = 75;

if omega <= 0
    error('Value of omega should be greater than 0.');
end

Z = 1 / sqrt(1 / R^2 + (omega*C - 1/(omega*L))^2);

impedance_delta = abs(Z) - M;

end