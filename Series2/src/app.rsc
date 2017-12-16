module app

import util::UUID;
import util::Math;
import util::IO;
import IO;
import util::FileSystem;
import String;
import detectors::AST;
import lang::java::jdt::m3::AST;
import lang::json::IO;
import List;
import Set;
import Map;
import metrics::Volume;

public loc smallProject = |project://smallsql0.21_src|;
public set[node] smast = createAstsFromEclipseProject(smallProject, false);

//public loc randomFiles = |project://Series2/3/default|;
//public set[node] randomAsts = createAstsFromFiles(find( |project://Series2/3/default|, "java"), false);
// set output folder
public loc output =  |project://Series2/src/sessions/| + "<abs(uuidi())>";
// set input project
public loc input = |project://TestProject/src/TestClass.java|;
// set settings
public set[node] asts = loadAst(input);

// run
public void main()  {
	map[str, list[map[str, value]]] classReports = detect(asts);
	str session = uuid().authority;
	writeJSON((|project://Series2/src/sessions| + session) + "metadata.json", ("sloc": 24000, "loc": 38000, "project": session, "location": "", "time": "2017-12-13T00:00:00"));
	writeSession(|project://Series2/src/sessions| + session, classReports);
	println("Session name <session>");
}
public void main2()  {
	
	str session = uuid().authority;
	writeJSON((|project://Series2/src/sessions| + session) + "metadata.json", ("sloc": 24000, "loc": 38000, "project": session, "location": "", "time": "2017-12-13T00:00:00"));
	map[str, list[map[str, value]]] classReports = detect(asts);
	println("Session name <session>");
	//writeSession(|project://Series2/src/sessions| + session, classReports);
	detectAsync(smast, session);
	println("Session  <session> Done");
}


public void createCloneAsync(map[int, list[node]] clones, str session) {
	// avoid subclones
	set[node] cloneFound = {};
	
	list[int] idx = reverse(sort([i | i <- clones]));

	
	map[str, list[map[str, value]]] classReports = ();
	
	for(x <- idx) {
		cloneClassId = uid();
		
		list[map[str, value]] classReport = [];
		classMembers = clones[x];

		if (isSubTree(head(classMembers), cloneFound)) {
			println("<head(classMembers)@hash> is subclone discarding class");
			continue;
		}
		
		map[loc id, map[str, value] clone] cloneCache = ();
		
		
		for(n <- classMembers) {
		
			cloneFound += n;
			node cleanNode = normalizeAST(n);
			str cloneId = n@id;
			
			list[map[str, value]] pairs;
			
			pairs = for(cm <- classMembers, cm@id != n@id) {
				//int t = 1;
				//ncm = normalizeAST(cm);
				//normalizedNode = normalizeAST(n);
				//
				//if (ncm := normalizedNode) {
				// 	t = 2;
				//}
				//
				//if (cm := n) {
				//	t = 1;
				//}
				int t = 1;
				m = normalizeAST(n);
				if (m !:= normalizeAST(cm)) {
					t = 2;
				}
				if (t>0) append(("id": cm@id, "type": t));
				
			}
			
			println(pairs);
			str source = readFile(n@src);
			volumeMetrics = volume(source);
			
			cloneInfo = ("clone_class" : cloneClassId, "fragment": readFile(n@src), "metadata": 
			("sloc": volumeMetrics["source_lines"], "length": volumeMetrics["total_lines"], "mass": n@mass),
			"location": (
				"file":"<n@src.authority><n@src.path>",
				"row": n@src.begin.line,
				"column": n@src.begin.column,
				"offset": [n@src.offset, n@src.length]
			)
			, "src": n@src, "id": n@id, "pairs": pairs);
			classReport += cloneInfo;
	
			
		}
		
		writeJSON(|project://Series2/src/sessions| + session + "<cloneClassId>.json",classReport);
	}
	
	//return classReports;
}

public void detectAsync(set[node] ds, str session) {
	// Extract all substrees from AST with a mass higher then threshold
	list[node] candidates = preprocess(ds, THRESHOLD);
	
	map[list[int], list[node]] clones = extractClones(candidates);
		
	createCloneAsync(clones, session);


} 