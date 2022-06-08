echo "Compiling the UnionFind executables..."
for LOG in 0 1
do
	for UALG in 0 1 2
	do
		for CALG in 0 1 2 3 4
		do
			echo "Compiling LOG = $LOG ; UALG = $UALG ; CALG = $CALG"
			g++ -o "./bin/uf$LOG$UALG$CALG" ./src/unionfind.cpp ./src/main.cpp -DUALG=$UALG -DCALG=$CALG -DLOG=$LOG
		done
	done
done


echo "Compiling the Instance Generator..."
g++ -O2 -o "./bin/instancegen" ./src/unionfind.cpp ./src/instancegen.cpp -DUALG=2 -DCALG=1 -DLOG=0
