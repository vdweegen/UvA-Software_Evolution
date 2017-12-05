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


public int treeMass(node n) {
	return countNodes(n);
}
public void run(node d) {
}
public void run(set[node] ds) {

	candidates = ([] | it + subTrees(d, 30) |d <- ds);
	
	hashEntries = [ h@hash | h <- candidates];
	byHash = bucketfy(candidates);
	potentials = domain(rangeX(distribution(hashEntries), {1}));
	clones = [];
	for(x <- potentials) {
		p = byHash[{x}];
		//println(p);
		
		while (size(p) > 0) {
			tuple[node, list[node]] ht = headTail(p);
			node n = ht[0];
			for([*_,z:n,*_] := ht[1]) {
				println("Match <z@src> <n@src>");
				clones += <n@src, z@src>;
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
	
	println("Number of potential <dup(clones)> ");
	
}

public bool compareCloneBasic(node s1, node s2) {

	

	return false;
}


public lrel[int, node] bucketfy(list[node] s) {
	lrel[int, node] buckets = [];
	
	buckets = for(n <- s) {
		append(<n@hash, n>);
	}

	return buckets;
}




public list[node] subTrees(node d, int threshold) {
	list[node] subtrees = [];	
	println("Proccessing file...<d.src>");
	visit(d) {
		case node n:  {
			 s = unsetRec(n);
			 mass = treeMass(s);
			 hashValue = hash(s);

			 
			 if (mass >= threshold && n.src?) {
				 println("Found subtree");
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
	println("Done proccessing file...");

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


