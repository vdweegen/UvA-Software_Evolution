module metrics::unitcomplexity::UnitComplexity

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import analysis::m3::AST;

import metrics::volume::Volume;

import IO;
import Set;
import List;

public lrel[int comp, int sloc] UnitComplexity(set[Declaration] ast){
	lrel[int comp, int sloc] res = [];

	visit (ast) {
	case dec:\method(_, _, _, _, Statement impl):
		res += <Complexity(dec), volume(impl.src)["source_lines"]>;
	case dec:\constructor(_, _, _, Statement impl): 
		res += <Complexity(dec), volume(impl.src)["source_lines"]>;
	}

	return res;
}

public int Complexity(Declaration method){
	int c = 1;
	
	visit(method) {
		case \if(_,_) : c += 1;
		case \if(_,_,_) : c += 1;
		case \while(_,_) : c += 1;
		case \case(_) : c += 1;
		case \do(_,_) : c += 1;
		case \for(_,_,_) : c += 1;
		case \for(_,_,_,_) : c += 1;
		case \foreach(_,_,_): c += 1;
		case \conditional(_,_,_): c += 1;
		case infix(_,"&&",_): c += 1;
		case infix(_,"||",_): c += 1;
	};
	
	return c;
	
}
