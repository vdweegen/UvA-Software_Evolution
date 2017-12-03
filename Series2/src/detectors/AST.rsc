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
anno int node @ src;

/*

	Annotate AST


*/


public int treeMass(node n) {
	return countNodes(n);
}

public void run(node d) {
	numberOfSubTrees = treeMass(d);
	buckets = ceil(numberOfSubTrees / 10);
	println("Number of buckets <buckets>");
}


public lrel[int, node] bucketfy(list[node] s) {
	lrel[int, node] buckets = [];
	
	buckets = for(n <- s) {
		append(<n@hash, n>);
	}

	return buckets;
}




public list[node] subTrees(Declaration d, int threshold) {
	list[node] subtrees = [];	
	visit(d) {
		case node n:  {
			 s = unsetRec(n);
			 mass = treeMass(s);
			 hashValue = hash(s);

			 
			 if (mass >= threshold) {
			 	 src = n.src;
			 	 s = setAnnotations(s, (
			 	"mass": mass,
			 	"hash": hashValue,
			 	"src": src
			 	//,
			 	//"bucket": hashValue % 3 
				 ));
			 	subtrees += s;
			 
			 }
			 
		}
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

		case node n:  {
			 count += 1;
		}
	}
	
	return count;
	
}

public int hash (node d) {
	list[int] h = [];
	
	visit(d) {
		case node n: {
			h += chars(getName(n));
		}
	}
	
	
	return sum([0,*h]);
	
	
}


