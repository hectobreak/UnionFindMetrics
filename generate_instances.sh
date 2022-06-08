echo "Generating instances..."

for T in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19
do
	for N in 1000 5000 10000 50000 100000
	do
		echo "Instance T=$T, N=$N"
		./bin/instancegen $N "ARBITRARY SEED $T" > "./instances/instance.$T.$N.txt"
	done
done
