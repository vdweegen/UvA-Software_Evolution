module app

import util::UUID;
import util::Math;
import util::IO;
import util::Date;
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



// set output folder
public loc output =  |project://Series2/src/sessions/| + "<abs(uuidi())>";



//Settings
bool type3 = false;
int threshold = 30;
public loc inputFile = |project://smallsql0.21_src|;



public M3 project = createM3FromEclipseProject(inputFile);
public set[node] smast = createAstsFromEclipseProject(inputFile, false);


// run
public void main()  {
	startTime = now();
	str session = uid();
	
	volumeMetrics = volume(files(project));
	
	map[str, list[map[str, value]]] classReports = detect(smast, threshold, type3);
	
	
	println("Session name <session>");
	
	writeJSON((|project://Series2/src/sessions| + session) + "metadata.json", ("sloc": volumeMetrics["source_lines"], "loc": volumeMetrics["total_lines"], "project": session, "location": inputFile, "time": time2str(now())));
	writeSession(|project://Series2/src/sessions| + session, classReports);
	
	println("Time taken <createDuration(startTime, now())>");
}

public void runAsync()  {
	startTime = now();
	str session = uuid().authority;
	
	volumeMetrics = volume(files(project));
	
	writeJSON((|project://Series2/src/sessions| + session) + "metadata.json", ("sloc": volumeMetrics["source_lines"], "loc": volumeMetrics["total_lines"], "project": session, "location": inputFile, "time": time2str(now())));
	
	println("Session name <session>");
	detectAsync(smast, session, threshold, type3);
	println("Session  <session> Done");
	
	println("Time taken <createDuration(startTime, now())>");
}



