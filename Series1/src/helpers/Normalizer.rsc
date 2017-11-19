module helpers::Normalizer

import String;
import List;
import Set;

/*
How to load and process project

public loc file = |project://smallsql0.21_src/src/smallsql/junit/TestOrderBy.java|;
public loc proj = |project://smallsql0.21_src|;
public M3 model = createM3FromEclipseProject(proj);
public set[loc] sources = files(model);
public str source = readFile(file);

*/
public str normalize(str source) {
	str normalized = removeComments(source);
	
	list[str] lines = split("\n", normalized);
	
	return intercalate("\n", removeEmptyLines(lines));
}

public list[str] normalize(list[str] sourceList) {
	str source = intercalate("\n", sourceList);
	
	str normalized = removeComments(source);
	
	list[str] lines = split("\n", normalized);
	
	return removeEmptyLines(lines);
}


public str removeComments(str source) {
	list[str] coms = comments(source);
	str normalized = source;
	
	for(com <- dup(coms)) {
		normalized = replaceAll(normalized, com, "");
	}
	return normalized;
}

public list[str] removeEmptyLines(list[str] lines) = [trim(line) | line <- lines, trim(line) notin {""}];


public list[str] comments(str example) {
	return for(/<x:(?s)\/\*.*?\*\/|\/\/[^\n\r]*$?>/ := example) append(x);
}
