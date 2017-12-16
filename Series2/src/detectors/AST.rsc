module detectors::AST

import IO;
import lang::json::IO;
import lang::java::jdt::m3::AST;
import lang::java::m3::TypeSymbol;
//import lang::java::\syntax::Java15;
import Node;
import String;
import List;
import util::Math;
import util::Benchmark;
import Type;
import Map;
import util::UUID;
import Set;
import metrics::Volume;

//import lang::java::m3::AST;
import ListRelation;




public int THRESHOLD = 20;
anno list[int] node @ hash;
anno int node @ mass;
anno int node @ bucket;
anno loc node @ src;
anno str node @ id;

/*
	Annotate AST
*/

public set[node] loadAst(loc file) = {createAstFromFile(file, false)};

public list[node] preprocess(set[node] asts, int minimumMass) =  ([] | it + subTrees(ast, minimumMass) |  ast <- asts);

// clones indexed by hash
public map[list[int], list[node]] extractClones(list[node] candidates) {
	list[list[int]] hashEntries = [ h@hash | h <- candidates];
	
	//Extract all hashes with more than 1 occurance
	potentials = domain(rangeX(distribution(hashEntries), {1}));
	
     map[list[int] hash, list[node] nodes] res = ();
	 for (e <- candidates, e@hash in potentials) {
	   if (res[e@hash]?) {
	   res[e@hash] += e;
	    
	   } else {
	   	res[e@hash] = [e];
	   }
	 }
	 
	return res;
}



public bool sortHash (list[int] a, list[int] b) = toInt(intercalate("",a)) < toInt(intercalate("",b));

public map[str, list[map[str, value]]] createCloneReports(map[list[int], list[node]] clones) {
	// avoid subclones
	set[node] cloneFound = {};
	
	list[list[int]] idx = reverse(sort([i | i <- clones], sortHash));

	
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
				//int t = 1;
				//ncm = normalizeAST(cm);
				//normalizedNode = normalizeAST(n);
				//
				//if (ncm := normalizedNode) {
				// 	t = 2;
				//}
				//
				//if (cm := n) {
				//	t = 1;
				//}
				int t = 1;
				m = normalizeAST(n);
				if (m !:= normalizeAST(cm)) {
					t = 2;
				}
				if (t>0) append(("id": cm@id, "type": t));
				
			}
			
			println(pairs);
			str source = readFile(n@src);
			volumeMetrics = volume(source);
			
			cloneInfo = ("clone_class" : cloneClassId, "fragment": readFile(n@src), "metadata": 
			("sloc": volumeMetrics["source_lines"], "length": volumeMetrics["total_lines"], "mass": n@mass),
			"location": (
				"file":"<n@src.authority><n@src.path>",
				"row": n@src.begin.line,
				"column": n@src.begin.column,
				"offset": [n@src.offset, n@src.length]
			)
			, "src": n@src, "id": n@id, "pairs": pairs);
			classReport += cloneInfo;
	
			
		}
		
		classReports[cloneClassId] = classReport;
	}
	
	return classReports;
}

public map[str, list[map[str, value]]]  detect(set[node] ds) {
	// Extract all substrees from AST with a mass higher then threshold
	list[node] candidates = preprocess(ds, THRESHOLD);
	
	map[list[int], list[node]] clones = extractClones(candidates);
		
	classReports = createCloneReports(clones);
	return classReports;

} 


public void run(set[node] ds) {
	startTime = realTime();
	// Extract all substrees from AST with a mass higher then threshold
	list[node] candidates = preprocess(ds, THRESHOLD);
	
	//map[int, list[node]] clones = extractClones(candidates);
	//	
	//classReports = createCloneReports(clones);
	
	
	//for(x <- classReports) {
	//	println(x);
	//	writeJSON(|file:///c:/py/aFolder| + ("<x>.json"), classReports[x]);
	//}

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

	bottom-up visit(d) {
		case node n:  {
			if (n.src?) {
			 
			 mass = treeMass(n);
			 if (mass >= threshold) {
			 	 s = normalizeAST(n);
			 	 hashValue = (hashFast(s));
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
	//println("Done proccessing file...");
	//println("Proccessing file...<d.src>");

	return subtrees;
}
//Similarity = 2 x S / (2 x S + L + R)
real sima(list[int] a, list[int] b) = toReal(2 * size(a & b))/(size(b - a) + size(a - b) + (2 * size(a & b)));

public lrel[str src, int mass, list[int] hash, str uuid, node \node] subTreesFast(node d, int threshold) {
	
	lrel[str src, int mass, list[int] hash, str uuid, node \node] subtrees = [];	
     subtrees = for(/node n := d, n.src?) {
	 	 int mass = fastCount(n);
	 	 if (mass >= threshold) {
	 	  	str src = "<n.src>";
	 	    list[int] h = hashFast(n);
	 	 //	append(<src, 0, hashFast(n), uid(), n>);
	 	 }
	 	
     }

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


public int nodeToCode(node n) = (0 | it + x | x <- chars(getName(n)));
public map[str, int] seen = ("notNull":0);
@memo
public list[int] hashFast (node d) {
	int p = 107;
	list[int] i = [];
	
	
	int tokenId(str name)  {
		tuple[int, map[str, int]] varName = varIndex(name, seen);
		seen = varName[1];
		return varName[0];
	};
	
	visit(d) {
		case \Declaration n: {
			i += tokenId(getName(n));
		}
		case \Statement n:{
			i += tokenId(getName(n));
		}
		case \Expression n:{
			i += tokenId(getName(n));
		}
	}
	
	return i;
	
	
}
public list[int] hashFast (node d, map[str, int] seen) {
	int p = 107;
	list[int] i = [];
	
	
	int tokenId(str name)  {
		tuple[int, map[str, int]] varName = varIndex(name, seen);
		seen = varName[1];
		return varName[0];
	};
	
	visit(d) {
		case \Declaration n: {
			i += tokenId(getName(n));
		}
		case \Statement n:{
			i += tokenId(getName(n));
		}
		case \Expression n:{
			i += tokenId(getName(n));
		}
	}
	
	return i;
	
	
}

//public list[int] hashFast (node d) {
//	int p = 107;
//	list[int] i = [];
//	
//	
//	int tokenId(str name)  {
//		tuple[int, map[str, int]] varName = varIndex(name, seen);
//		seen = varName[1];
//		return varName[0];
//	};
//	
//	visit(d) {
//		case \Declaration n: {
//			i += tokenId(getName(n));
//		}
//		case \Statement n:{
//			i += tokenId(getName(n));
//		}
//		case \Expression n:{
//			i += tokenId(getName(n));
//		}
//	}
//	
//	return i;
//	
//	
//}



public tuple[int, map[str, int]] varIndex(str name, map[str, int] seen) {
		if (name notin seen) {
			 seen[name] = size((seen));
		} 
		
		return <seen[name], seen>;
}

public node normalizeAST(node n) {
	return normalizeAST(n, false);
}
@memo
public node normalizeAST(node n, bool consistent) {
	
	map[str, int] seen = ();
	
	str renameStr(str name, str prefix)  {
		str nameReturn = name;
		if (consistent) {
			tuple[int, map[str, int]] varName = varIndex(name, seen);
			seen = varName[1];
		 	nameReturn = "<prefix><varName[0]>";
		}
		return nameReturn;
	};
	
	
	node nir = visit (n) {
	case \simpleName(str name) =>{
	 \simpleName("<renameStr(name, "id")>");
	 }
	case \variable(str name, int extraDimensions) => {
		variable("<renameStr(name, "id")>", extraDimensions);
	}
	case \variable(str name, int extraDimensions, Expression \initializer) => {

		variable("<renameStr(name, "id")>", extraDimensions, \initializer);
	}
	case node m => {
			s = unset(m);
		
		}
	};
	
	// iprint(nir);
	return nir;
}


public str uid() = uuid().authority;

// Fully Tested code

public int treeMass(node n) = fastCount(n);

public int countNodes(node d) {
	count = 0;
	bottom-up visit(d) {
		case node n:  {
			 count += 1;
		}
	}
	
	return count;
}


public int typedCount(node d) {
	int count = 0;
	for(/\Declaration n := d) count += 1;
	for(/\Statement n := d) count += 1;
	for(/\Expression n := d) count += 1;
	for(/\lang::java::jdt::m3::AST::Type n := d)  count += 1;
	for(/\lang::java::jdt::m3::AST::Modifier n := d)  count += 1;
	
	return count;
}
public int fastCount(node d) {
	list[int] i = [];
	i += for(/node n := d, \TypeSymbol m !:= n, \Bound b !:= n ) 
	{
	append(1);
	}
	return size(i);
}

public node unsetNodes(node n) = unsetRec(n); 

public list[loc] a (node d) {
	list [loc] locations = []; 
	locations += for(/\Declaration n := d, n.src? && n.src.length > 80) append(n.src);
	locations += for(/\Statement n := d, n.src? && n.src.length > 80) append(n.src);
	locations += for(/\Expression n := d, n.src? && n.src.length > 80) append(n.src);
	return locations;
}



