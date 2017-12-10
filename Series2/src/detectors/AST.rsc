module detectors::AST

import IO;
import lang::json::IO;
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
import util::UUID;


//import lang::java::m3::AST;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;
import ListRelation;




public int THRESHOLD = 50;
anno int node @ hash;
anno int node @ mass;
anno int node @ bucket;
anno loc node @ src;
anno loc node @ id;

/*

	Annotate AST


*/

public set[node] loadAst(loc file) = {createAstFromFile(file, false)};

@memo
public int treeMass(node n) {
	return countNodes(n);
}
public void run(node d) {
}

public list[node] preprocess(&T asts, int minimumMass) =  ([] | it + subTrees(ast, minimumMass) |ast <- asts);


public map[int, list[map[str, value]]] detect(set[node] asts) {
	startTime = realTime();
	// Extract all substrees from AST with a mass higher then threshold
	list[node] candidates = preprocess(ds, THRESHOLD);

	// map[int, list[map[str, value]]] cloneClasses = 
}


// Sorted index and listRelation
public tuple[list[int], lrel[int, node]] extractClones(list[node] candidates) {
	list[int] hashEntries = [ h@hash | h <- candidates];
	
	//Extract all hashes with more than 1 occurance
	potentials = domain(rangeX(distribution(hashEntries), {1}));
	
	// Create RelationList with hash as domain
	byHash = bucketfy([x|x <- candidates, x@hash in potentials]);
	return <reverse(sort([i | i <-potentials])), byHash>;
}


public map[int, list[map[str, value]]] createCloneReports(tuple[list[int], lrel[int, node]] clones) {
	// avoid subclones
	set[node] cloneFound = {};
	
		list[int] idx = clones[0];
	lrel[int, node] byHash = clones[1];
	
	map[int, list[map[str, value]]] classReports = ();
	
	for(x <- idx) {
		cloneClassId = uuidi();
		list[map[str, value]] classReport = [];
		p = byHash[{x}];

		if (isSubTree(p[0], cloneFound)) {
			println("<p[0]@hash> is subclone discarding class");
			continue;
		}
		map[loc id, map[str, value] clone] cloneCache = ();
		
		while (size(p) > 0) {
			tuple[node, list[node]] ht = headTail(p);
			node n = ht[0];
			println("In while loop");
			m = ir(n);
			println("Match <n@src>");
			cloneFound += n;
			loc cloneId = n@id;
			
			lrel[str] a = [];
			
			cloneInfo = extractInfo(n, cloneClassId) + ("src": n@src, "id": n@id, "pairs": a);
			cloneCache[cloneId] = cloneInfo;
			
			classReport += cloneInfo;
			
			for(z <- ht[1]) {
				println("checking if the same, <m := ir(z)>");
				int t = 1;
				if (m !:= ir(z)) {
					t = 2;
				}
				cloneFound += z;
				
			}
			
			p = ht[1];
		}
		
		classReports[cloneClassId] = classReport;
	}
	
	return classReports;
}
public void run(set[node] ds) {
	startTime = realTime();
	// Extract all substrees from AST with a mass higher then threshold
	list[node] candidates = preprocess(ds, THRESHOLD);
	
	tuple[list[int], lrel[int, node]] clones = extractClones(candidates);
		
	classReports = createCloneReports(clones);

	for(x <- classReports) {
		writeJSON(|file:///c:/py/aFolder| + ("<x>.json"), classReports[x]);
	}

	println("Time taken <realTime() - startTime>");
	
}

public map[str, value] extractInfo(node n, int cc) = (
						"id" : 1,
						"cloneClass" : cc,
						"fragment": readFile(n@src)
					);

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
			 	"src": src,
			 	"id": uuid()
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
			i += (i | it + x | x <- chars(getName(n)[0..5]));
		}
	}
	
	return i;
	
	
}

@memo
public node ir(node n) {
	
	node nir = visit (n) {
	case \simpleName(str name) => \simpleName("id1")
	case \variable(str name, int extraDimensions) => variable("id1", extraDimensions)
	case \variable(str name, int extraDimensions, Expression \initializer) => variable("id1", extraDimensions, \initializer)
	case node m => {
			s = unset(m);
		
		}
	};
	
	// iprint(nir);
	return nir;
}


