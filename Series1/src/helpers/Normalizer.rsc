module helpers::Normalizer

import IO;
import String;
import List;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

public loc file = |project://smallsql0.21_src/src/smallsql/junit/TestOrderBy.java|;
public loc proj = |project://smallsql0.21_src|;
public M3 model = createM3FromEclipseProject(proj);
public set[loc] sources = files(model);
public str source = readFile(file);

public void run() {

	println(sum([ size(split("\n", normalize(readFile(x)))) | x <- sources]));
	
}

public str normalize(str source) {
	
	list[str] coms = comments(source);
	str normalized = source;
	
	for(com <- coms) {
		normalized = replaceAll(normalized, com, "");
	}
	list[str] lines = split("\n",normalized);
	
	return intercalate("\n",([line | line <- lines, trim(line) notin {""}]));
	
}


public list[str] comments(str example) {
	return for(/<x:(?s)\/\*.*?\*\/|\/\/[^\n\r]*$?>/ := example) append(x);
}
