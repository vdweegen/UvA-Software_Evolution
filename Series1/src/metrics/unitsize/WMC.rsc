module metrics::unitsize::WMC

import metrics::unitcomplexity::UnitComplexity;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import helpers::Math;
import List;
import String;
import IO;
import Set;

public loc file = |project://smallsql0.21_src/src/smallsql/database/Column.java|;
public loc proj = |project://smallsql0.21_src|;
public M3 model = createM3FromEclipseProject(proj);
public M3 modelFile = createM3FromFile(file);
public set[loc] sources = files(model);
public str source = readFile(file);


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
