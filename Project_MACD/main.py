import numpy as np
import matplotlib.pyplot as plt
import csv


# matplotlib.use('Qt5agg')

def getdata(file_name):
    dates = []
    closes = []
    number_of_lines = 1035

    # Reading number_of_lines first lines
    with open(file_name, 'r') as plik:
        plik.readline()  # Skip the first line
        for _ in range(number_of_lines):
            line = plik.readline().strip().split(',')
            date, open_data, high, low, close, volume = line
            dates.append(date)
            closes.append(float(close))

    return dates, closes

def find_intersections(range1, range2, MACD, SIGNAL):
    buy_points = []
    sell_points = []
    for i in range(range1, range2):
        if MACD[i] > SIGNAL[i] and MACD[i - 1] <= SIGNAL[i - 1]:
            buy_points.append(i)
        elif MACD[i] < SIGNAL[i] and MACD[i - 1] >= SIGNAL[i - 1]:
            sell_points.append(i)

    return buy_points, sell_points
def generate_EMA(closes, N):
    # Obliczenie wykładniczych średnich kroczących (EMA)
    alpha = 2 / (N + 1)
    EMA = np.zeros(len(closes)-N)
    denominator = 0
    for i in range(0, N):
        denominator += (1 - alpha) ** i

    for i in range(N, len(closes)):
        numerator = 0
        for j in range(0, N):
            numerator += (1 - alpha) ** j * closes[i - j]
        EMA[i - N] = numerator / denominator

    return EMA


# Wczytanie danych wejściowych z pliku CSV
dates, closes = getdata('wig20_d.csv')

# Obliczenie EMAs
EMA26 = generate_EMA(closes, 26)
EMA12 = generate_EMA(closes, 12)
EMA12 = EMA12[-1009:]
# Obliczenie wartości MACD
MACD = EMA12 - EMA26

# Obliczenie sygnału (SIGNAL)
SIGNAL = generate_EMA(MACD, 9)

# keep only last 1000 elements of an array
dates = dates[-1000:]
closes = closes[-1000:]
MACD = MACD[-1000:]
# Wykres notowań WIG20
plt.figure(figsize=(10, 6))
plt.plot(dates, closes, label='Wartość WIG20', color='blue', linewidth=1)
plt.title('Notowania WIG20')
plt.xlabel('Data')
plt.ylabel('Wartość')
plt.legend()
n = 5  # Liczba dat do wyświetlenia
indices = np.linspace(0, len(dates) - 1, n, dtype=int)
xticks = [dates[i] for i in indices]

# Ustawienie dat na osi x
plt.xticks(indices, xticks)  # Ustawienie etykiet osi x w równych odstępach
# Wyświetlenie wykresu
plt.tight_layout()
plt.savefig('wig20.png', dpi=1000, bbox_inches='tight')
plt.show()

# Wykres notowań MACD i SIGNAL
plt.figure(figsize=(10, 6))
plt.plot(MACD, label='MACD', color='blue')
plt.plot(SIGNAL, label='SIGNAL', color='orange')
plt.title('MACD i SIGNAL z punktami kupna/sprzedaży')
plt.xlabel('Data')
plt.ylabel('Wartość')
xticks = [dates[i] for i in indices]

plt.xticks(indices, xticks)

# Znalezienie punktów przecięcia MACD i SIGNAL
buy_points, sell_points = find_intersections(0, len(MACD), MACD, SIGNAL)

# Dodanie punktów kupna/sprzedaży do wykresu
plt.scatter(buy_points, MACD[buy_points], color='green', label='Kupno', zorder=2, s=20)
plt.scatter(sell_points, MACD[sell_points], color='red', label='Sprzedaż', zorder=2, s=20)
plt.legend()
# plt.savefig('macd_signal.png', dpi=1000, bbox_inches='tight')
plt.show()

# wykres WIG20 z sugerowanymi momentami kupna i sprzedazy
plt.figure(figsize=(10, 6))
plt.plot(dates, closes, label='Wartość WIG20', color='blue', linewidth=1)
plt.scatter(buy_points, [closes[i] for i in buy_points], color='green', label='Kupno', zorder=2, s=20)
plt.scatter(sell_points, [closes[i] for i in sell_points], color='red', label='Sprzedaż', zorder=2, s=20)
plt.title('Sygnały kupna i sprzedaży na wykresie WIG20')
plt.xlabel('Data')
plt.ylabel('Wartość')
plt.legend()
plt.xticks(indices, xticks)
plt.tight_layout()
# plt.savefig('wig20_macd_signals.png', dpi=1000, bbox_inches='tight')
plt.show()

# wykres 1 okresowy
range1 = 730
range2 = 755
buy_points_period_1, sell_points_period_1 = find_intersections(range1, range2, MACD, SIGNAL)

indices = np.linspace(0, len(dates[range1:range2]) - 1, 5, dtype=int)
xticks = [dates[range1:range2][i] for i in indices]

plt.figure(figsize=(10, 6))
plt.plot(dates[range1:range2], closes[range1:range2], label='Wartość WIG20', color='blue', linewidth=1)
plt.scatter([dates[i] for i in buy_points_period_1], [closes[i] for i in buy_points_period_1], color='green',
            label='Kupno', zorder=2, s=20)
plt.scatter([dates[i] for i in sell_points_period_1], [closes[i] for i in sell_points_period_1], color='red',
            label='Sprzedaż', zorder=2, s=20)
plt.title('Moment transakcji ze stratą')
plt.xlabel('Data')
plt.ylabel('Wartość')
plt.legend()
plt.xticks(indices, xticks)
for i in buy_points_period_1:
    plt.text(dates[i], closes[i], f'{closes[i]:.2f}', color='black', ha='center', va='bottom', fontsize=8)
for i in sell_points_period_1:
    plt.text(dates[i], closes[i], f'{closes[i]:.2f}', color='black', ha='center', va='bottom', fontsize=8)
plt.tight_layout()
# plt.savefig('transaction_with_loss.png', dpi=1000, bbox_inches='tight')
plt.show()

# wykres 2 okresowy
range1 = 760
range2 = 795
buy_points_period_2, sell_points_period_2 = find_intersections(range1, range2, MACD, SIGNAL)

indices = np.linspace(0, len(dates[range1:range2]) - 1, 5, dtype=int)
xticks = [dates[range1:range2][i] for i in indices]

plt.figure(figsize=(10, 6))
plt.plot(dates[range1:range2], closes[range1:range2], label='Wartość WIG20', color='blue', linewidth=1)
plt.scatter([dates[i] for i in buy_points_period_2], [closes[i] for i in buy_points_period_2], color='green',
            label='Kupno', zorder=2, s=20)
plt.scatter([dates[i] for i in sell_points_period_2], [closes[i] for i in sell_points_period_2], color='red',
            label='Sprzedaż', zorder=2, s=20)
plt.xlabel('Data')
plt.ylabel('Wartość')
plt.legend()
plt.xticks(indices, xticks)
for i in buy_points_period_2:
    plt.text(dates[i], closes[i], f'{closes[i]:.2f}', color='black', ha='center', va='bottom', fontsize=8)
for i in sell_points_period_2:
    plt.text(dates[i], closes[i], f'{closes[i]:.2f}', color='black', ha='center', va='bottom', fontsize=8)
plt.tight_layout()
# plt.savefig('transaction_with_profit.png', dpi=1000, bbox_inches='tight')
plt.show()

# algorithm
starting_capital = 10000
capital = starting_capital

max_number_of_stock = int(capital / closes[0])
number_of_stock = max_number_of_stock
capital -= max_number_of_stock * closes[0]

capital_without_macd = capital + number_of_stock * closes[-1]
print("Investing without using MACD algorithm")
print("Starting capital: " + str(round(starting_capital, 2)))
print("Final capital: " + str(round(capital_without_macd, 2)))
print("Percentage of improvement: " + str(round(capital_without_macd / starting_capital * 100 - 100, 2)) + " %")

capital = starting_capital
number_of_stock = 0
prev_capital = capital
max_capital = capital
min_capital = capital
transaction_with_max_profit = [0, 0]
transaction_with_max_loss = [0, 0]
transactions_with_profit = []
transactions_with_loss = []
all_transactions = []
transaction_counter = 0
for i in range(0, len(closes)):
    if i in buy_points:
        transaction_counter += 1
        max_num_of_stock = int(capital / closes[i])
        number_of_stock += max_num_of_stock
        capital -= max_num_of_stock * closes[i]
    elif i in sell_points:
        transaction_counter += 1
        capital += number_of_stock * closes[i]
        number_of_stock = 0

    if transaction_counter % 2 == 0 and transaction_counter > 0:
        if capital > prev_capital:
            profit = capital - prev_capital
            transactions_with_profit.append(profit)
            all_transactions.append(profit)
            if transaction_with_max_profit[0] < profit:
                transaction_with_max_profit[0] = profit
                transaction_with_max_profit[1] = dates[i]
        elif capital < prev_capital:
            loss = capital - prev_capital
            transactions_with_loss.append(loss)
            all_transactions.append(loss)
            if transaction_with_max_loss[0] > loss:
                transaction_with_max_loss[0] = loss
                transaction_with_max_loss[1] = dates[i]
        if capital > max_capital:
            max_capital = capital
        if capital < min_capital:
            min_capital = capital
        prev_capital = capital

capital += number_of_stock * closes[-1]

print("----------------------")
print("Investing using MACD algorithm")
print("Starting capital: " + str(round(starting_capital, 2)))
print("Final capital: " + str(round(capital, 2)))
print("Percentage of improvement: " + str(round(capital / starting_capital * 100 - 100, 2)) + " %")
print("Number of transactions with loss: " + str(len(transactions_with_loss)))
print("Number of transactions with profit: " + str(len(transactions_with_profit)))
print("Biggest profit: " + str(round(transaction_with_max_profit[0], 2)) + ", recorded on date: " +
      transaction_with_max_profit[1])
print(
    "Biggest loss: " + str(round(transaction_with_max_loss[0], 2)) + ", recorded on date: " + transaction_with_max_loss[
        1])
print("Maximal capital during simulation (measured after every transaction): " + str(round(max_capital, 2)))
print("Minimal capital during simulation (measured after every transaction): " + str(round(min_capital, 2)))

# tabela z transakcjami
transaction_table = []
for i in range(0, len(sell_points)):
    vector = []
    index_sell = sell_points[i]
    index_buy = buy_points[i]
    vector.append(dates[index_sell])
    vector.append(closes[index_buy])
    vector.append(closes[index_sell])
    vector.append(round(all_transactions[i], 2))
    transaction_table.append(vector)

# generowanie danych do tabeli
csv_file = 'transaction_data.csv'
with open(csv_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['Data', 'Cena podczas zakupu', 'Cena podczas sprzedaży', 'Bilans po transakcji'])
    for vector in transaction_table:
        writer.writerow(vector)

# wykres słupkowy obrazujący bilansy kolejnych transakcji
dates_bar = [row[0] for row in transaction_table]
transaction_values_bar = [row[3] for row in transaction_table]

indices = np.linspace(0, len(dates_bar) - 1, 8, dtype=int)
xticks = [dates_bar[i] for i in indices]
plt.figure(figsize=(10, 6))
plt.bar(dates_bar, transaction_values_bar, color='blue', label='Bilans transakcji')
plt.xlabel('Data')
plt.ylabel('Wartość')
plt.title('Wartości zysku lub straty dla kolejnych transakcji')
plt.tight_layout()
plt.xticks(indices, xticks, rotation=45, ha='right')
plt.legend()
# plt.savefig('transactions_balans_sheet.png', dpi=1000, bbox_inches='tight')
plt.show()
