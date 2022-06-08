DELTA=250

echo "Generating data..."

echo "N T union_alg comp_alg time" > ./data/times.csv

for UALG in 0 1 2
do
	for CALG in 0 1 2 3 4
	do
		for T in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19
		do
			for N in 1000 5000 10000
			do
				echo "UALG=$UALG, CALG=$CALG, T=$T, N=$N"
				cat ./instances/instance.$T.$N.txt | ./bin/uf0$UALG$CALG "$N $T $UALG $CALG" >> ./data/times.csv
			done
		done
	done
done
