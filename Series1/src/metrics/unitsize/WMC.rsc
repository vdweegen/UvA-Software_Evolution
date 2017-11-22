module metrics::unitsize::WMC

import metrics::unitcomplexity::UnitComplexity;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import helpers::Math;
import List;
import String;
import IO;
import Set;

/*
 * WMC : weighted methods per class
 */
public list[int] WMC(set[loc] projectClasses) {
	return ([WMC(c) | c <- projectClasses]);
}


public int WMC(loc l) {
	Declaration ast = createAstFromFile(l, false);
	return ( 0 | it + x |<x, _><-UnitComplexity(ast));
}
