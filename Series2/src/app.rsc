module app

import util::UUID;
import util::Math;
import util::IO;
import IO;
import util::FileSystem;
import String;
import detectors::AST;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import lang::json::IO;
import List;
import Set;
import Map;
import metrics::Volume;
import DateTime;

public loc inputFile = |project://smallsql0.21_src|;
public M3 project = createM3FromEclipseProject(inputFile);
public set[node] smast = createAstsFromEclipseProject(inputFile, false);

//public loc randomFiles = |project://Series2/3/default|;
//public set[node] randomAsts = createAstsFromFiles(find( |project://Series2/3/default|, "java"), false);
// set output folder
public loc output =  |project://Series2/src/sessions/| + "<abs(uuidi())>";
// set input project
public loc input = |project://TestProject/src/Small.java|;
// set settings
//public set[node] asts = loadAst(input);

public str time2str(datetime d) {
	return "<d.year>-<right("<d.month>", 2,"0")>-<right("<d.day>", 2,"0")>T<right("<d.hour>", 2,"0")>:<right("<d.minute>", 2,"0")>:<right("<d.second>", 2,"0")>.<right("<d.millisecond>", 3,"0")>Z";
}


// run
public void main()  {
	startTime = now();
	volumeMetrics = volume(files(project));
	map[str, list[map[str, value]]] classReports = detect(smast);
	str session = uuid().authority;
	
	writeJSON((|project://Series2/src/sessions| + session) + "metadata.json", ("sloc": volumeMetrics["source_lines"], "loc": volumeMetrics["total_lines"], "project": session, "location": inputFile, "time": time2str(now())));
	writeSession(|project://Series2/src/sessions| + session, classReports);
	println("Session name <session>");
	println("Time taken <createDuration(startTime, now())>");
}
public void main2()  {
	
	str session = uuid().authority;
	writeJSON((|project://Series2/src/sessions| + session) + "metadata.json", ("sloc": volumeMetrics["source_lines"], "loc": volumeMetrics["total_lines"], "project": session, "location": "", "time": "2017-12-13T00:00:00"));
	map[str, list[map[str, value]]] classReports = detect(smast);
	println("Session name <session>");
	//writeSession(|project://Series2/src/sessions| + session, classReports);
	detectAsync(smast, session);
	println("Session  <session> Done");
}



public void detectAsync(set[node] ds, str session) {
	// Extract all substrees from AST with a mass higher then threshold
	list[node] candidates = preprocess(ds, THRESHOLD);
	
	map[list[int], list[node]] clones = extractClones(candidates);
		
	createCloneAsync(clones, session);


} 