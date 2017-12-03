module detectors::AST

import IO;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;
import Node;
import String;
import List;
import util::Math;

public int THRESHOLD = 30;
anno int node @ hash;
anno int node @ mass;
anno int node @ bucket;

public int treeMass(node n) {
	return countNodes(n);
}

public void run(node d) {
	numberOfSubTrees = treeMass(d);
	buckets = ceil(numberOfSubTrees / 10);
	println("Number of buckets <buckets>");
}

public list[node] subTrees(Declaration d, int threshold) {
	list[node] subtrees = [];	
	visit(d) {
		case node n:  {
			 s = unsetRec(n);
			 mass = treeMass(s);
			 s = s[@mass = mass];
			 z= s[@hash = hashing(s)];
			 s= z[@bucket = (z@hash % 18)];
			 if (mass >= threshold) {
			 	subtrees += s;
			 }
			 
		}
	}

	 for(x <- subtrees) {
		 println(hashing(x));
	 }
	return subtrees;
}

public void nameThatNode(node n) {
	
	visit(n) {
		
		case node n : println("<getName(n)>");
	}

}





public int countNodes(node d) {
	count = 1;
	top-down visit(d) {
		//case Type x : println("Found: <x>");
		case node n:  {
			 count += 1;
		}
	}
	
	return count;
	
}

public int hashing (node d) {
	list[int] h = [];
	
	visit(d) {
		case node n: {
			h += chars(getName(n));
		}
	}
	
	
	return sum([0,*h]);
	
	
}


