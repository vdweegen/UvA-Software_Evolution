module detectors::AST

import IO;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;
import Node;
import String;
import List;

public list[node] hash(Declaration d) {
	list[node] subtrees = [];
	list[int] counts = [];
	
	visit(d) {
		//case Type x : println("Found: <x>");
		case node n:  {
			 s = unsetRec(n);
			 mass = countNodes(s);
			 
			 s = s[@mass = mass];
			 if (mass >= 30) {
			 	counts += mass;
			 	subtrees += s;
			 }
			 
		}
	}

	//println(subtrees);
	//println(counts);
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


