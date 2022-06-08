DELTA=250

echo "Generating data..."

echo "N T union_alg comp_alg step path_len point_upd ngroups" > ./data/data.csv

for UALG in 0 1 2
do
	for CALG in 0 1 2 3 4
	do
		for T in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19
		do
			for N in 1000 5000 10000
			do
				echo "UALG=$UALG, CALG=$CALG, T=$T, N=$N"
				cat ./instances/instance.$T.$N.txt | ./bin/uf1$UALG$CALG $DELTA "$N $T $UALG $CALG" >> ./data/data.csv
			done
		done
	done
done
