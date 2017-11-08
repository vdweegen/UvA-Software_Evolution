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
		fileMap[file] = StripLine(file); // TODO Strip comments
	}
	return fileMap;
}

// Strip all the comments
public list[str] StripLine(loc file) {
	list[str] lines = [];
	
	// Do the 'simple' stuff
	for (line <- readFileLines(file)) {
		// Strip Single-Line Comment
		line = StripSingleLineComment(line);
		
		// Strip Blank Lines
		
		lines += line;
	}
	
	// Strip Multi-Line Comments
	
	// Should be done here
	return lines;
}

// Strip all single-line comments
public str StripSingleLineComment(line) {
	return line;
}