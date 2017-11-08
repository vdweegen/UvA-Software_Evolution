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
		if (IsCommentedLine(line) || IsBlankLine(line)) {
			continue;
		}
		lines += line;
	}
	
	// Check for Multi-Line comment blocks
	lines = StripMultiLineComments(lines);
	
	// Should be done here
	return lines;
}

/*
 * Detects commented lines
 * 	V2: Now uses regex
 *
 * TODO:
 *	Detect MULTI-LINE
 */
public bool IsCommentedLine(str line) {
	return /^\s*\/\/.*$/ := line;
}

/*
 * Detect blank lines
 * 	
 * Finally figured out how the regex thing works =D
 * Should backport to IsCommentedLine();
 */
public bool IsBlankLine(str line) {
	return /^\s*$/ := line;
}

/*
 * Strip Multi-Line comments blocks
 *	We need to feed the whole 'thing' to effectively
 *  check for blocks (cannot do on a per-line basis)
 */
public list[str] StripMultiLineComments(lines) {
	// TODO
	return lines;
}