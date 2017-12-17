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
import util::ValueUI;
import util::Benchmark;
import Type;
import Map;
import util::UUID;
import Set;
import metrics::Volume;

//import lang::java::m3::AST;
import ListRelation;
import Relation;

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
public set[list[int]]  potentialType3 = {};

public map[list[int], list[node]] extractClones(list[node] candidates) = extractClones(candidates, false);
// clones indexed by hash
public map[list[int], list[node]] extractClones(list[node] candidates, bool withType3) {
	list[list[int]] hashEntries = [ h@hash | h <- candidates];
	
	
	
	//Extract all hashes with more than 1 occurance
	potentials = domain(rangeX(distribution(hashEntries), {1}));

	map[tuple[list[int], list[int]], list[node]] cacheSima = (); 
	
	if (withType3) {
			for(sc <- candidates ) {
			  scmass = sc@mass;
			  schash = sc@hash;
			    
			  compareWith = [z|z <- candidates, <z@hash, schash> notin cacheSima, (z@mass - scmass) < 10 && (z@mass - scmass) > -10, z@hash != schash];
			   
			  for(tc <-compareWith ) {
				  if (!(tc@hash > schash) && !(tc@hash < schash)) {
				   sim = similarity(tc@hash, sc@hash);
				   if (0.95 < sim) {
				   	 cacheSima[<schash, tc@hash>] = [sc, tc];
				  	 cacheSima[<tc@hash, schash>] = [];
				   } else {
				  	 cacheSima[<schash, tc@hash>] = [];
				   	 cacheSima[<tc@hash, schash>] = [];
				   }
				  
				  } else {
				   cacheSima[<schash, tc@hash>] = [];
				   cacheSima[<tc@hash, schash>] = [];
			  	  }
			  
			  }
			  
		
		}
	}

	potentialType3 = domain(domain(rangeX(cacheSima, {[]})));
	rel[list[int], list[int]] potentialType3Map = domain(rangeX(cacheSima, {[]}));
	
    map[list[int] hash, list[node] nodes] res = ();
	 for (e <- candidates, e@hash in potentials) {
	   if (res[e@hash]?) {
	   res[e@hash] += e;

	   } else {
	   	res[e@hash] = [e];
	   }
	   
	 }
	
	
	  // Prefix type 3 with 100	 
	  for (e <- rangeX(cacheSima, {[]})) {
	
		  res[[-1,0,0] + e[0]] = cacheSima[e];
	  }
	  

	 
	return res;
}


@memo
public bool sortHash (list[int] a, list[int] b)  {
	if (size(a) == size(b)) {
		return toInt(intercalate("",a)) < toInt(intercalate("",b));
	} else {
		if (a[1] == 0 || b[1] == 0) {
			return toInt(intercalate("",a)) < toInt(intercalate("",b));
		} else {
			return size(a) < size(b);
		}
	}
	
} 

public map[str, list[map[str, value]]] createCloneReports(map[list[int], list[node]] clones) {
	// avoid subclones
	set[node] cloneFound = {};

	list[list[int]] idx = reverse(sort([i | i <- clones], sortHash));
	
	
	map[str, list[map[str, value]]] classReports = ();
	
	for(x <- idx) {
		cloneClassId = uid();
		
		list[map[str, value]] classReport = [];
		classMembersList = clones[x];

		firstMember = classMembersList[0];
		
		isType3Class = x[0..3] == [-1,0,0];
		if  (!isType3Class && isSubTree(firstMember, cloneFound)) {
			continue;
		}
		
		map[loc id, map[str, value] clone] cloneCache = ();
		
		set[node] classMembers = toSet(classMembersList);
		set[node] toSkip = {};
		
	
		for(n <- classMembers) {
			
			cloneFound += n;
			node cleanNode = normalizeAST(n);
			str cloneId = n@id;
			
			list[map[str, value]] pairs;
			
			m = normalizeAST(n);

			pairs = for(cm <- classMembers, cm@id != n@id) {

				int t = 2;
				if (!isType3Class) {
					if (m := cm) {
						t = 1;
					}
					append(("id": cm@id, "type": t));
				} else {
					append(("id": cm@id, "type": 3));
				}
			}
			
			
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


public map[str, list[map[str, value]]] createCloneAsync(map[list[int], list[node]] clones, str session) {
	// avoid subclones
	set[node] cloneFound = {};

	list[list[int]] idx = reverse(sort([i | i <- clones], sortHash));
	
	
	map[str, list[map[str, value]]] classReports = ();
	
	for(x <- idx) {
		cloneClassId = uid();
		
		list[map[str, value]] classReport = [];
		classMembersList = clones[x];

		firstMember = classMembersList[0];
		
		isType3Class = x[0..3] == [-1,0,0];
		if  (!isType3Class && isSubTree(firstMember, cloneFound)) {
			continue;
		}
		
		map[loc id, map[str, value] clone] cloneCache = ();
		
		set[node] classMembers = toSet(classMembersList);
		set[node] toSkip = {};
		
	
		for(n <- classMembers) {
			
			cloneFound += n;
			node cleanNode = normalizeAST(n);
			str cloneId = n@id;
			
			list[map[str, value]] pairs;
			
			m = normalizeAST(n);

			pairs = for(cm <- classMembers, cm@id != n@id) {

				int t = 2;
				if (!isType3Class) {
					if (m := cm) {
						t = 1;
					}
					append(("id": cm@id, "type": t));
				} else {
					append(("id": cm@id, "type": 3));
				}
			}
			
			
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
		
			
			
			writeJSON(|project://Series2/src/sessions| + session + ("class_<cloneClassId>.json"), classReport);
			
				
				
			
		//classReports[cloneClassId] = classReport;
	}
	
	return classReports;
}


public map[str, list[map[str, value]]]  detect(set[node] ds, int threshold, bool type3) {
	// Extract all substrees from AST with a mass higher then threshold
	list[node] candidates = preprocess(ds, threshold);
	
	map[list[int], list[node]] clones = extractClones(candidates, type3);
		
	classReports = createCloneReports(clones);
	return classReports;

} 


@memo
public bool isSubTree(node n, node p) {
	return /n := p;
}
@memo
public bool isSubTree(node n, set[node] p) {
	return /n := p;
}


public list[node] subTrees(node d, int threshold) {
	list[node] subtrees = [];	

	top-down visit(d) {
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

	return subtrees;
}
//Similarity = 2 x S / (2 x S + L + R)
@memo
real similarity(list[int] a, list[int] b)  {
	sharedNodes = a & b;
	differentNodesA = a-b;
	differentNodesB = b-a;
	real sizeShared = 2.0 * size(sharedNodes);
	
	return sizeShared/(size(differentNodesA) + size(differentNodesB) + sizeShared);
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



public tuple[int, map[str, int]] varIndex(str name, map[str, int] seen) {
		if (name notin seen) {
			 seen[name] = size((seen));
		} 
		
		return <seen[name], seen>;
}
@memo
public node normalizeAST(node n) {
	return normalizeAST(n, false);
}
@memo
public node normalizeASTType2(node n) {
	node nir = visit (n) {
	case \simpleName(str name) =>{
	 \simpleName("");
	 }
	case \variable(str name, int extraDimensions) => {
		variable("", extraDimensions);
	}
	case \variable(str name, int extraDimensions, Expression \initializer) => {

		variable("", extraDimensions, \initializer);
	} 
	case \method(\Type \return, str name, list[\Declaration] parameters, list[\Expression] exceptions, \Statement impl)  => {
		\method(\return, "", parameters,  exceptions, impl);
	}
	case \method(\Type \return, str name, list[\Declaration] parameters, list[\Expression] exceptions)  => {
		\method(\return, "", parameters,  exceptions);
	}
	case \typeParameter(str name, list[Type] extendsList) => {
		\typeParameter("", extendsList);
	}
	case \parameter(Type \type, str name, int extraDimensions)=> {
		\parameter(\type, "", extraDimensions);
	}
	
	

	case node m => {
			s = unset(m);
		
		}
	};
	
	//iprint(nir);
	return nir;
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
	case \method(\Type \return, str name, list[\Declaration] parameters, list[\Expression] exceptions, \Statement impl)  => {
		\method(\return, "<renameStr(name, "id")>", parameters,  exceptions, impl);
	}
	case \method(\Type \return, str name, list[\Declaration] parameters, list[\Expression] exceptions)  => {
		\method(\return, "<renameStr(name, "id")>", parameters,  exceptions);
	}
	case \typeParameter(str name, list[Type] extendsList) => {
		\typeParameter("<renameStr(name, "id")>", extendsList);
	}
	case \parameter(Type \type, str name, int extraDimensions)=> {
		\parameter(\type, "<renameStr(name, "id")>", extraDimensions);
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
@memo
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
@memo
public node unsetNodes(node n) = unsetRec(n); 

public list[loc] a (node d) {
	list [loc] locations = []; 
	locations += for(/\Declaration n := d, n.src? && n.src.length > 80) append(n.src);
	locations += for(/\Statement n := d, n.src? && n.src.length > 80) append(n.src);
	locations += for(/\Expression n := d, n.src? && n.src.length > 80) append(n.src);
	return locations;
}



