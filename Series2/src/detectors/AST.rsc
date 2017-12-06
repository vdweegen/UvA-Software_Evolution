module detectors::AST

import IO;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;
import lang::java::m3::AST;
import lang::java::jdt::m3::AST;
import Node;
import String;
import List;
import util::Math;
import util::Benchmark;
import Type;
import Map;

import ListRelation;


public int THRESHOLD = 30;
anno int node @ hash;
anno int node @ mass;
anno int node @ bucket;
anno loc node @ src;

/*

	Annotate AST


*/

@memo
public int treeMass(node n) {
	return countNodes(n);
}
public void run(node d) {
}
public void run(set[node] ds) {
	startTime = realTime();
	candidates = ([] | it + subTrees(d, 30) |d <- ds);
	
	hashEntries = [ h@hash | h <- candidates];
	byHash = bucketfy(candidates);
	potentials = domain(rangeX(distribution(hashEntries), {1}));
	clones = [];
	
	idx = reverse(sort([i | i <-potentials]));
	println(idx);
	set[node] cloneFound = {};
	for(x <- idx) {
		
		p = byHash[{x}];
		//println("<cloneFound> <isSubTree(p[0], cloneFound)>");
		
		if (isSubTree(p[0], cloneFound)) {
			continue;
		}
		
		while (size(p) > 0) {
			tuple[node, list[node]] ht = headTail(p);
			node n = ht[0];
			m = ir(n);
			for(z <- ht[1]) {
				if (m := ir(z)) {
					//[*_,z:n,*_] := /
					
					println("Match <z@src> <n@src>");
					clones += <n@src, z@src>;
					cloneFound += {n , z};
				}
			
				
			}
			p = ht[1];
		}
		
		
	}
	
	indexClones = (index(clones));
	
	for(cl <- indexClones) {
		println("
		' Clone class
		' Original @ <cl>
		'<readFile(cl)>
		' <for(x <- indexClones[cl]){> 
		' Clone @ <x>
		'<readFile(x)>
		' <}>
		");
	}
	
	//println("Number of potential <size(dup(clones))> ");
	println("Time taken <realTime() - startTime>");
	
}

public bool compareCloneBasic(node s1, node s2) {

	

	return false;
}

public bool isSubTree(node n, node p) {
	return /n := p;
}

public bool isSubTree(node n, set[node] p) {
	return /n := p;
}


public lrel[int, node] bucketfy(list[node] s) {
	lrel[int, node] buckets = [];
	
	buckets = for(n <- s) {
		append(<n@hash, n>);
	}

	return buckets;
}

@memo
public node unsetNodes(node n) = unsetRec(n); 

public list[node] subTrees(node d, int threshold) {
	list[node] subtrees = [];	
	println("Proccessing file...<d.src>");
	visit(d) {
		case node n:  {
			if (n.src?) {
			s = unsetRec(n);
			 mass = treeMass(s);
			 if (mass >= threshold) {
			 	 hashValue = hashFast(s);
				 //println("Found subtree");
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
	}
	println("Done proccessing file...");

	return subtrees;
}

//public void nameThatNode(node n) {
//	
//	visit(n) {
//		
//		case node n : println("<getName(n)>");
//	}
//
//}
@memo
public int countNodes(node d) {
	count = 1;
	top-down visit(d) {
		case node n:  {
			 count += 1;
		}
	}
	
	return count;
	
}

public node annoTreeMass(node n) {
	return visit (n) {
	 case node m => {
			s = unset(m);
			s@mass  = (countNodes(s));
		}
	}

}

@memo
public int hash (node d) {
	list[int] h = [];
	
	visit(d) {
		case node n: {
			h += chars(getName(n)[0..3]);
		}
	}
	
	
	return sum([0,*h]);
	
	
}
@memo
public int hashFast (node d) {
	int i = 0;
	
	visit(d) {
		case node n: {
		//println(getName(n));
			i += (i | it + x | x <- chars(getName(n)[0..2]));
		}
	}
	
	return i;
	
	
}
@memo
public int hashFast (node d) {
	int i = 0;
	
	visit(d) {
		case node n: {
		//println(getName(n));
			i += (i | it + x | x <- chars(getName(n)[0..2]));
		}
	}
	
	return i;
	
	
}

@memo
public node ir(node n) {
	return visit (n) {
	case \simpleName(str name) => \simpleName("")
	 case node m => {
			s = unset(m);
		
		}
	}

}


