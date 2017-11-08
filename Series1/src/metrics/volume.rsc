module metrics::volume

import IO;
import String;

// Extract the actual source code from all the lines
public list[str] LinesOfCode(set[loc] files) {
	locpf = LinesOfCodePerFile(files);
	return [*locpf[f] | f <- locpf];
}

// Filter the actual code-lines from comments and blank lines
public map[loc, list[str]] LinesOfCodePerFile(set[loc] files) {
	map[loc, list[str]] fileMap = ();
	for (file <- files) {
		fileMap[file] = StripLine(file);
	}
	return fileMap;
}

// Strip all the comments
public list[str] StripLine(loc file) {
	list[str] lines = [];
	
	// Do the 'simple' stuff
	for (line <- readFileLines(file)) {
		// Skip commented out lines
		if (IsCommentedLine(line)) {
			continue;
		}		
		lines += line;
	}
	
	// Should be done here
	return lines;
}

/*
 * Super simple code that detects a commented line
 * TODO:
 *	Detect MULTI-LINE
 *
 *  Nice to have: use regexes
 */
public bool IsCommentedLine(str line) {
	line = replaceAll(line," ", "");
	line = replaceAll(line,"\t", "");
	line = replaceAll(line,"\n", "");
	return startsWith("//", line);
}
