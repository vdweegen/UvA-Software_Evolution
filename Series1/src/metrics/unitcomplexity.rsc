module metrics::unitcomplexity
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import analysis::m3::AST;

import metrics::volume;

import IO;
import Set;
import List;

// Get method AST
// Count number of control flow

public lrel[int comp, int sloc] calculateComplexity(set[Declaration] ast){
	lrel[int comp, int sloc] res = [];

	visit (ast) {
	case dec:\method(_, _, _, _, Statement impl):
		res += <Complexity(dec), size(ProcessFileLine(impl.src))>;
	case dec:\constructor(_, _, _, Statement impl): 
		res += <Complexity(dec), size(ProcessFileLine(impl.src))>;
	}

	return res;
}

public int Complexity(Declaration method){
	int c = 1;
	
	visit(method) {
		case \if(_,_) :{
			c = c + 1;
		}
		case \if(_,_,_) :{
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
	
// Get lines of code per unit
// Complexity per unit
// calculate Risk profile segment
// Do aggregation for system as a whole
//	calcualte total lines of code, percentage of lines of code with high risk, moderate, etc
	
	

	
/*
[<x, calculateComplexity(getMethodASTEclipse(x, model=m))>| x<- theMethods]
lrel[loc,int]: [
  <|java+method:///smallsql/database/MemoryStream/readByte()|,1>,
  <|java+method:///smallsql/database/MemoryStream/writeShort(int)|,1>,
  <|java+method:///smallsql/database/MemoryStream/skip(int)|,1>,
  <|java+method:///smallsql/database/MemoryStream/writeBytes(byte%5B%5D,int,int)|,1>,
  <|java+method:///smallsql/database/MemoryStream/readChars(int)|,2>,
  <|java+method:///smallsql/database/MemoryStream/writeByte(int)|,1>,
  <|java+method:///smallsql/database/MemoryStream/readShort()|,1>,
  <|java+method:///smallsql/database/MemoryStream/writeLong(long)|,1>,
  <|java+method:///smallsql/database/MemoryStream/readInt()|,1>,
  <|java+method:///smallsql/database/MemoryStream/readLong()|,1>,
  <|java+method:///smallsql/database/MemoryStream/readBytes(int)|,1>,
  <|java+method:///smallsql/database/MemoryStream/writeInt(int)|,1>,
  <|java+constructor:///smallsql/database/MemoryStream/MemoryStream()|,1>,
  <|java+method:///smallsql/database/MemoryStream/writeTo(java.nio.channels.FileChannel)|,1>,
  <|java+method:///smallsql/database/MemoryStream/writeChars(char%5B%5D)|,2>,
  <|java+method:///smallsql/database/MemoryStream/verifyFreePufferSize(int)|,3>
]


*/
