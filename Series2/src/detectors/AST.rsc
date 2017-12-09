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

public loc littleClass = |project://smallsql0.21_src/src/smallsql/tools/CommandLine.java|;
public loc smallProject = |project://smallsql0.21_src|;
public Declaration littleClassAst = createAstFromFile(littleClass, false);
public set[node] smast = createAstsFromEclipseProject(smallProject, false);


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

public list[node] getSubTrees(&T asts, int minimumMass) =  ([] | it + subTrees(ast, minimumMass) |ast <- asts);


public void run(set[node] ds) {
	startTime = realTime();
	// Extract all substrees from AST with a mass higher then threshold
	list[node] candidates = getSubTrees(ds, THRESHOLD);
	
	
	// Index candidates by hash
	list[int] hashEntries = [ h@hash | h <- candidates];
	// Create RelationList with hash as domain
	byHash = bucketfy(candidates);
	//Extract all hashes with more than 1 occurance
	potentials = domain(rangeX(distribution(hashEntries), {1}));
	
	clones = [];
	// Sort to get the largest subtress first
	idx = reverse(sort([i | i <-potentials]));
	println(idx);
	set[node] cloneFound = {};
	
	list[list[map[str, value]]] classReports = [];
	
	
	
	
	for(x <- idx) {
		cloneClassId = uuidi();
		list[map[str, value]] classReport = [];
		p = byHash[{x}];
		//println("<cloneFound> <isSubTree(p[0], cloneFound)>");
		//println(x);
		//iprint(p);
		//println(cloneFound);
		println(p[0]@hash);
		println("Match <size(p)>");
		
		if (isSubTree(p[0], cloneFound)) {
			println("<p[0]@hash> is subclone discarding class");
			continue;
		}
		
		while (size(p) > 1) {
			tuple[node, list[node]] ht = headTail(p);
			node n = ht[0];
			println("In while loop");
			m = ir(n);
			println("Match <n@src>");
			cloneFound += n;
			classReport += extractInfo(n, cloneClassId) + ("src": n@src, "id": uuid(),"type": 1);
			
			for(z <- ht[1]) {
				println("checking if the same, <m := ir(z)>");
				int t = 1;
				if (m !:= ir(z)) {
					t = 2;
				}
				 
				classReport += (extractInfo(z, cloneClassId) + ("src": z@src,"id": uuid(), "type": t));
				println("Match <z@src> <n@src>");
				clones += <n@src, z@src>;
				cloneFound += z;
				
				
			
				
			}
			
			p = ht[1];
		}
		
		classReports += [classReport];
	}
	
	println(clones);
	
	
	indexClones = (index(clones));
	
	for(cl <- indexClones) {
		//println("
		//' Clone class
		//' Original @ <cl>
		//'<readFile(cl)>
		//' <for(x <- indexClones[cl]){> 
		//' Clone @ <x>
		//'<readFile(x)>
		//' <}>
		//");
		//
		writeJSON(|file:///c:/py/aFolder| + ("s" + ".json"), classReports);
		println(classReports);
	}
	
	//println("Number of potential <size(dup(clones))> ");
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


