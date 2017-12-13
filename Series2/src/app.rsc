module app

import util::UUID;
import util::Math;
import util::IO;
import IO;
import util::FileSystem;
import String;
import detectors::AST;
import lang::java::jdt::m3::AST;

public loc smallProject = |project://smallsql0.21_src|;
public set[node] smast = createAstsFromEclipseProject(smallProject, false);

public loc randomFiles = |project://Series2/3/default|;
public set[node] randomAsts = createAstsFromFiles(find( |project://Series2/3/default|, "java"), false);
// set output folder
public loc output =  |project://Series2/src/sessions/| + "<abs(uuidi())>";
// set input project
public loc input = |project://TestProject/src/Small.java|;
// set settings
public set[node] asts = loadAst(input);

// run
public void main()  {
	map[str, list[map[str, value]]] classReports = detect(randomAsts);
	str session = uuid().authority;
	writeSession(|project://Series2/src/sessions| + session, classReports);
}