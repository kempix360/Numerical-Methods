[numer_indeksu, Edges, I, B, A, b, r] = page_rank()
plot_PageRank(r);

function plot_PageRank(r)

% Wygenerowanie wykresu
bar(r);

% Dodanie tytułu i opisów osi
title('Wykres PageRank');
xlabel('Indices');
ylabel('PageRank');

print -dpng task_7.png 
end

function [numer_indeksu, Edges, I, B, A, b, r] = page_rank()
numer_indeksu = 197259;
N = 8;
d = 0.85;
num = numer_indeksu;
num = num/10;
L1 = floor(mod(num, 10));
num = num/10;
L2 = floor(mod(num, 10));
x = mod(L1,7)+1;
y = mod(L2,7)+1;
Edges = [1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6, 7, 8, 2;
         6, 4, 4, 5, 3, 5, 6, 7, 6, 5, 6, 4, 7, 4, 6, 1, 8];
I = speye(N);
B = sparse(Edges(2,:),Edges(1,:),1);
A = spdiags(1./sum(B,1)',0,N,N);
b = (1 - d) / N * ones(N, 1);
% Mx = b   =>  x = M \ b
r = (I - d * B * A) \ b;
end