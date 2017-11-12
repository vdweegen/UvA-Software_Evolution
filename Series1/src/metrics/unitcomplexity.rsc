module metrics::unitcomplexity
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import IO;
import Set;
import List;


public loc locationExample = |project://smallsql0.21_src/src/smallsql/database/MemoryStream.java|;
public M3 m = createM3FromEclipseFile(locationExample);
//public Declaration methodAST = getMethodASTEclipse(|java+method:///HelloWorld/main(java.lang.String%5B%5D)|, model=m);
public set[loc] theMethodsSet = methods(m);
public list[loc] theMethods = toList(theMethodsSet);
public loc theMethod = |java+method:///smallsql/database/MemoryStream/verifyFreePufferSize(int)|;
public Declaration methodAst = getMethodASTEclipse(theMethod, model=m);
//getMethodASTEclipse
// Get method AST
// Count number of control flow
//for ( /\if(x,y) := methodAst, \infix(_,_,_) z := x) println(x);
public int calculateComplexity (Declaration method) {
	int c = 0;
	
	visit(method) {
		case \infix : c = c + 1;
	};
	
	return c;
}

public int countPredicate (Statement cond) {
	int c = 0;
	visit(cond) {
	case \z:infix(x,_,y) :{
			if(z@typ == boolean()) {
				c = c + 1;
			}
		}
	};
	return c;
}

public int calculateComplexityPrint (Declaration method) {
	int c = 1;
	
	visit(method) {
		case z:\if(_,_) :{
			c = c + 1;
		}
		case z:\if(_,_,_) :{
			c = c + 1;
		}
		case \while(_,_) :{
			c = c + 1;
		}
		case \case(_) :{
			c = c + 1;
		}
		case \do(_,_) :{
			c = c + 1;
		}
		case \for(_,_,_) :{
			c = c + 1;
		}
		case \for(_,_,_,_) :{
			c = c + 1;
		}
		case \foreach(_,_,_): c = c + 1;
		case \conditional(_,_,_): c = c + 1;
		case infix(_,"&&",_): c = c + 1;
		case infix(_,"||",_): c = c + 1;
		
	};
	
	return c;
}
public int addLeaves(Declaration method){
   int c = 0;
   visit(method) {
     case /Comment : c = c + 1;   
   };
   return c;
}