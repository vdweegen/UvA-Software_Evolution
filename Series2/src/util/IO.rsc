module util::IO

import IO;
import lang::json::IO;


public str sessionsDirectory = "c:/app"; 

public loc createLoc(str s) = |file:///| + s; 

public void createSession(str sessionName) {
	createFolder("<sessionsDirectory>/<sessionName>");
}	

public void writeSession(loc session, map[int, list[map[str, value]]] classReports) {
	if (!isDirectory(session)) {
		createFolder(session);
	}
	for(report <- classReports) {
		writeJSON(session + ("class_<report>.json"), classReports[report]);
	}
		
		
}	

public void createFolder(str n) {
	loc path = createLoc(n);
	createFolder(path);
}

public void createFolder(loc n) {
	mkDirectory(n);
}


public void saveCloneClass(list[node] clones) {
	
	println(clones);
	
}