module metrics::Volume

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import helpers::Normalizer;

import List;
import String;
import IO;


/*
 * Volume takes the raw source;
 */
public map[str, int] volume(set[loc] project) {
	list[map[str, int]] volumes = [volume(s) |  s  <- project];
	
	map[str, int] initialMap = (
		"total_lines": 0,
		"source_lines": 0,
		"comment_lines":0,
		"comments": 0
	);
	
	for(map[str, int] e <- volumes) {
		for(totals <- e) {
			if (totals notin initialMap) {
				initialMap[totals] = e[totals]; 
			} else {
				initialMap[totals] = initialMap[totals] + e[totals]; 
			}
		}
	}
		  	 
	
	return initialMap;
}

public map[str, int] volume(loc file) {
	str rawSource = readFile(file);
	return volume(rawSource);
}

public map[str, int] volume(str rawSource) {
	return volume(split("\n", rawSource), rawSource);
}

public map[str, int] volume(list[str] rawSourceLines) {
	return volume(rawSourceLines, intercalate("\n", rawSourceLines));
}

public map[str, int] volume(list[str] rawSourceLines, str rawSource) {
	list [str] commentStrings = comments(rawSource);
	list [int] commentLines =  [size(split("\n", comm))| comm <- commentStrings ];
	return (
		"total_lines": size(rawSourceLines),
		"source_lines": size(normalize(rawSourceLines)),
		"comment_lines": commentLines  != [] ? sum(commentLines) : 0,
		"comments": size(comments(rawSource))
	);
}