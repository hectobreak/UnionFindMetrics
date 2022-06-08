#include <iostream>
#include <set>
#include <utility>
#include <random>
#include <ctime>
#include "unionfind.cpp"

using namespace std;

vector< pair<int, int> > pairs;

random_device dev;
mt19937 rng(dev());
uniform_int_distribution<mt19937::result_type> dist; 

void usage(char * programName){
	cerr << "USAGE: " << programName << " [NumberOfElements] [Seed: Optional]" << std::endl;
	exit(0);
}

int main(int argc, char * argv[]){
	if(argc != 2 && argc != 3) usage(argv[0]);
	
	int N = atoi(argv[1]);
	
	string seedstr = "Default seed";
	if(argc == 3) seedstr = argv[2];
	
	seed_seq seed(seedstr.begin(),seedstr.end());
	rng = mt19937(seed);
	dist = uniform_int_distribution<mt19937::result_type>(0, N-1); 
	
	set< pair<int, int> >usedPairs;

	UnionFind uf(N);
	cout << N << endl << endl;
	while(uf.nGroups() > 1){
		int fst, snd;
		do {
			fst = dist(rng);
			snd = fst;
			while(snd == fst) snd = dist(rng);
			if(snd > fst) {
				int tmp = fst;
				fst = snd;
				snd = tmp;
			}
		} while( usedPairs.find( make_pair(fst, snd) ) != usedPairs.end() );
		usedPairs.insert( make_pair(fst, snd) );
		
		uf.union_op(fst, snd);
		cout << "U " << fst << " " << snd << endl;
	}
}
