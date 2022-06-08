#include <iostream>
#include <vector>

typedef unsigned long int node;

#if LOG == 1
// This is inefficient, but it's not meant to be efficient
#define pointerUpdate(a, b) (a = b - PUs + (PUs++))
#else
#define pointerUpdate(a, b) (a = b)
#endif

class UnionFind {
	private:
		std::vector<node> parent;
		unsigned long int num;
		
		unsigned long int ngroups;
		
		#if LOG == 1
		unsigned long long int PUs;
		#endif
		
		#if UALG == 1
		std::vector<unsigned int> size;
		#endif
		
		#if UALG == 2
		std::vector<int> rank;
		#endif
		
	public:
		UnionFind(unsigned long int n){
			parent = std::vector<node>(n);
			num = n;
			ngroups = n;
			for(int i = 0; i < n; ++i) parent[i] = i;
			
			#if UALG == 1
			size = std::vector<unsigned int>(n, 1);
			#endif
			
			#if UALG == 2
			rank = std::vector<int>(n, 1);
			#endif
			
			#if LOG == 1
			PUs = 0;
			#endif
		}
		
		// No compression
		#if CALG == 0
		node find(node n){
			while(parent[n] != n) n = parent[n];
			return n;
		}
		#endif
		
		// Full compression
		#if CALG == 1
		node find(node n){
			if(parent[parent[n]] == parent[n]) return parent[n];
			return pointerUpdate(parent[n], find(parent[n]));
		}
		#endif

		// Path halving
		#if CALG == 2
		node find(node n){
			while(parent[parent[n]] != parent[n]) 
				n = pointerUpdate(parent[n], parent[parent[n]]);
			return parent[n];
		}
		#endif

		// Path splitting
		#if CALG == 3
		node find(node n){
			while(parent[parent[n]] != parent[n]){
				node tmp = parent[n];
				pointerUpdate(parent[n], parent[parent[n]]);
				n = tmp;
			}
			return parent[n];
		}
		#endif

		// Path inversion
		#if CALG == 4
		node find(node n){
			node a = parent[n], b = parent[a], c = parent[b];
			if(a == b) return a;
			if(b == c) return pointerUpdate(parent[n], b);
			while(parent[c] != c){
				pointerUpdate(parent[a], n);
				a = b; b = c; c = parent[c];
			}
			pointerUpdate(parent[n], c);
			return pointerUpdate(parent[a], c);
		}
		#endif

		// Union
		void union_op(node n, node m){
			n = find(n);
			m = find(m);
			if(n == m) return;
			--ngroups;
			
			// Fast union
			#if UALG == 0
			parent[n] = m;
			#endif
			
			// Union by size
			#if UALG == 1
			if(size[n] > size[m]) {
				parent[m] = n;
				size[n] += size[m];
			} else {
				parent[n] = m;
				size[m] += size[n];
			}
			#endif
			
			// Union by rank
			#if UALG == 2
			int dif = rank[n] - rank[m];
			if(dif < 0) parent[n] = m;
			else if(dif > 0) parent[m] = n;
			else {
				parent[n] = m;
				++rank[m];
			}
			#endif
		}
		
		#if LOG == 1
		// Total Path Length
		unsigned long long int TPL(){
			unsigned long long int count = 0;
			for(node i = 0; i < num; ++i){
				node j = i;
				while(parent[j] != j) {
					++count;
					j = parent[j];
				}
			}
			return count;
		}
		
		// Total Pointer Updates
		unsigned long long int TPU(){
			return PUs;
			return 0;
		}
		#endif
		
		unsigned long int nGroups(){
			return ngroups;
		}
};
