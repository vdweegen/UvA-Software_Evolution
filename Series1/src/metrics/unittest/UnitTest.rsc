module metrics::unittest::UnitTest

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import util::Math;

import helpers::Normalizer;
import metrics::volume::Volume;

import List;
import String;
import IO;
import ListRelation;
import Set;


public list[int] UnitTestCount(set[loc] projectMethods) {
	return ([UnitTestCount(readFile(m)) | m <- projectMethods]);
}

public lrel[loc, int] UnitTestCountDebug(set[loc] projectMethods) {
	return [<m, UnitTestCount(readFile(m))> | m <- projectMethods];
}

public int UnitTestCount(str source) {
	return countAsserts(source);
}

public int UnitTestCount(loc source) {
	return countAsserts(readFile(source));
}

public real UnitTest(set[Declaration] decl) {
	list[real] percentages = getPercentage(testPerClass(decl));
	real sum = (0. | it + i| i <- percentages);
	return ( sum / size(percentages));
}


public list[real] getPercentage(lrel[int good, int total] l) = ([] | it + (toReal(good)/total * 100) | <good, total> <- l);

public bool startsWithTest(str n)= /^test/i := n;

public lrel[int good, int total] testPerClass(set[Declaration] decls) {
	result = [];
	visit(decls) {
		case n: \class(name, _, _, _): {
		
			if (startsWithTest(name)) {
				lrel[loc, int] tmethods = testMethods(n);
				if (tmethods != []) {
					result += <size(rangeX(tmethods, {0})), size(tmethods)>;
				}
			}
		}
	}
	return result;
}

public lrel[loc, int] testMethods(Declaration testClass) {
	result = [];
	visit(testClass)  {
		case  m:\method(_, str name, _, _, _) : {
		
			if (startsWithTest(name)) {
				result += <m.src, UnitTestCount(m.src)>;
			}
			
		}
	}
	
	return result;
}


public int countAsserts(str source) {
	list[str] asrt = [];
	asrt = for(/<as:assert[\w]*\b>/ := source) append(as);
	return size(asrt);
}
