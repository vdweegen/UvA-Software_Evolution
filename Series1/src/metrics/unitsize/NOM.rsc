module metrics::unitsize::NOM


import helpers::Normalizer;
import metrics::volume::Volume;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;


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
 * NOM : number of methods per class	
 */
public list[int] NOM(set[loc] projectClasses) {
	return ([NOM(c) | c <- projectClasses]);
}

public int NOM(loc l) {
	M3 model = createM3FromFile(l);
	return size(methods(model));
}

