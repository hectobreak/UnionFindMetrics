#include <iostream>
#include <vector>
#include "unionfind.cpp"

typedef unsigned long int node;

double time_sw;

#if LOG == 0
#include <chrono>
std::chrono::steady_clock::time_point mark;
#endif

inline void start_stopwatch(){
	#if LOG == 0
	mark = std::chrono::steady_clock::now();
	#endif
}

inline void stop_stopwatch(){
	#if LOG == 0
	time_sw += ((float) ( std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::steady_clock::now() - mark).count() )) / 1000000.0;
	#endif
}

void usage(char * programName){
	#if LOG == 1
	std::cerr << "USAGE: " << programName << " [Delta] [Precat]" << std::endl;
	#else
	std::cerr << "USAGE: " << programName << " [Precat]" << std::endl;
	#endif
	exit(0);
}

int main(int argc, char * argv[]) {
	char * precat;
	#if LOG == 1
	if(argc != 3) usage(argv[0]);
	int delta = atoi(argv[1]);
	precat = argv[2];
	#else
	if(argc != 2) usage(argv[0]);
	precat = argv[1];
	#endif
	time_sw = 0;
	unsigned long int n, m;
	std::cin >> n;
	start_stopwatch();
	UnionFind uf(n);
	stop_stopwatch();
	char c;
	int thold = 0;
	int step = 0;
	while(std::cin >> c){
		#if LOG == 1
		if(++step >= thold) {
			thold += delta;
			std::cout << precat << " " << step << " " << uf.TPL() << " " << uf.TPU() << " " << uf.nGroups() << std::endl;
		}
		#endif
		if(c == 'U'){
			std::cin >> n >> m;
			start_stopwatch();
			uf.union_op(n, m);
			stop_stopwatch();
		} else if(c == 'F'){
			std::cin >> n;
			start_stopwatch();
			auto res = uf.find(n);
			stop_stopwatch();
			std::cout << res << std::endl;
		}
		if(uf.nGroups() == 1) break;
	}
	#if LOG == 1
	std::cout << precat << " " << step << " " << uf.TPL() << " " << uf.TPU() << " " << uf.nGroups() << std::endl;
	#else
	std::cout << precat << " " << time_sw << std::endl;
	#endif
}
