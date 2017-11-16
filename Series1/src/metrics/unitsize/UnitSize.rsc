module metrics::unitsize::UnitSize



import helpers::Normalizer;
import metrics::volume::Volume;
import List;
import String;
import IO;
import Set;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;



//public loc file = |project://smallsql0.21_src/src/smallsql/database/Column.java|;
//public loc proj = |project://smallsql0.21_src|;
//public M3 model = createM3FromEclipseProject(proj);
//public M3 modelFile = createM3FromFile(file);
//public set[loc] sources = files(model);
//public str source = readFile(file);


/*
	Unit size uses the model to extract the methods and the source
	
*/


public list[int] unitSize(M3 model) {
	set[loc] projectMethods = methods(model);
	return ([unitSize(readFile(m)) | m <- projectMethods]);
}

public int unitSize(str source) {
	return linesExtract(source);
}

public int linesExtract(str x) = volume(x)["total_lines"];

