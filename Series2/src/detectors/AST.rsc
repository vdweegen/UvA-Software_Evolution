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
import Set;

//import lang::java::m3::AST;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;
import ListRelation;




public int THRESHOLD = 30;
anno int node @ hash;
anno int node @ mass;
anno int node @ bucket;
anno loc node @ src;
anno str node @ id;

/*
	Annotate AST
*/

public set[node] loadAst(loc file) = {createAstFromFile(file, false)};

public list[node] preprocess(&T asts, int minimumMass) =  ([] | it + subTrees(ast, minimumMass) |ast <- asts);

// clones indexed by hash
public map[int, list[node]] extractClones(list[node] candidates) {
	list[int] hashEntries = [ h@hash | h <- candidates];
	
	//Extract all hashes with more than 1 occurance
	potentials = domain(rangeX(distribution(hashEntries), {1}));
	
     map[int hash, list[node] nodes] res = ();
	 for (e <- candidates, e@hash in potentials) {
	   if (res[e@hash]?) {
	   res[e@hash] += e;
	    
	   } else {
	   	res[e@hash] = [e];
	   }
	 }
	 
	return res;
}





public map[str, list[map[str, value]]] createCloneReports(map[int, list[node]] clones) {
	// avoid subclones
	set[node] cloneFound = {};
	
	list[int] idx = reverse(sort([i | i <- clones]));
	
	map[str, list[map[str, value]]] classReports = ();
	
	for(x <- idx) {
		cloneClassId = uid();
		
		list[map[str, value]] classReport = [];
		classMembers = clones[x];

		if (isSubTree(head(classMembers), cloneFound)) {
			println("<head(classMembers)@hash> is subclone discarding class");
			continue;
		}
		
		map[loc id, map[str, value] clone] cloneCache = ();
		
		
		for(n <- classMembers) {
		
			cloneFound += n;
			node cleanNode = normalizeAST(n);
			str cloneId = n@id;
			
			list[map[str, value]] pairs;
			
			pairs = for(cm <- classMembers, cm@id != n@id) {
				int t = 1;
				m = normalizeAST(n);
				if (m !:= normalizeAST(cm)) {
					t = 2;
				}
				
				append(("id": cm@id, "type": t));
				
			}
			
			println(pairs);
			
			cloneInfo = ("cloneClass" : cloneClassId,"fragment": readFile(n@src), "src": n@src, "id": n@id, "pairs": pairs);
			classReport += cloneInfo;
	
			
		}
		
		classReports[cloneClassId] = classReport;
	}
	
	return classReports;
}

public map[str, list[map[str, value]]]  detect(set[node] ds) {
	// Extract all substrees from AST with a mass higher then threshold
	list[node] candidates = preprocess(ds, THRESHOLD);
	
	map[int, list[node]] clones = extractClones(candidates);
		
	classReports = createCloneReports(clones);
	return classReports;

} 


public void run(set[node] ds) {
	startTime = realTime();
	// Extract all substrees from AST with a mass higher then threshold
	list[node] candidates = preprocess(ds, THRESHOLD);
	
	map[int, list[node]] clones = extractClones(candidates);
		
	classReports = createCloneReports(clones);
	
	
	for(x <- classReports) {
		println(x);
		writeJSON(|file:///c:/py/aFolder| + ("<x>.json"), classReports[x]);
	}

	println("Time taken <realTime() - startTime>");
	
}


public bool isSubTree(node n, node p) {
	return /n := p;
}

public bool isSubTree(node n, set[node] p) {
	return /n := p;
}


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
			 	 src = n.src;
			 	 s = setAnnotations(s, (
			 	"mass": mass,
			 	"hash": hashValue,
			 	"src": src,
			 	"id": uid()
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
public int hash (node d) {
	list[int] h = [];
	
	visit(d) {
		case node n: {
			h += chars(getName(n)[0..3]);
		}
	}
		
	return sum([0,*h]);
	
}
public int hashFast (node d) {
	int i = 0;
	
	visit(d) {
		case node n: {

			i += (i | it + x | x <- chars(getName(n)));
		}
	}
	
	return i;
	
	
}



@memo
public node normalizeAST(node n) {
	
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


public str uid() = uuid().authority;

// Fully Tested code
public int treeMass(node n) = countNodes(n);

public int countNodes(node d) {
	count = 0;
	top-down visit(d) {
		case node n:  {
			 count += 1;
		}
	}
	
	return count;
}

@memo
public node unsetNodes(node n) = unsetRec(n); 


