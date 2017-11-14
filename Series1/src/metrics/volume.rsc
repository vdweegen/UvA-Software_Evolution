module metrics::volume

import IO;
import String;

public list[str] LinesOfPrint(set[loc] files) {
	lpf = LinesOfPrintPerFile(files);
	return [*lpf[f] | f <- lpf];
}

// Extract the actual source code from all the lines
public list[str] LinesOfCode(set[loc] files) {
	locpf = LinesOfCodePerFile(files);
	return [*locpf[f] | f <- locpf];
}

// Filter the actual code-lines from comments and blank lines
public map[loc, list[str]] LinesOfCodePerFile(set[loc] files) {
	map[loc, list[str]] fileMap = ();
	for (file <- files) {
		fileMap[file] = ProcessFileLine(file);
	}
	return fileMap;
}

// Return all the lines
public map[loc, list[str]] LinesOfPrintPerFile(set[loc] files) {
	map[loc, list[str]] fileMap = ();
	for (file <- files) {
		list[str] lines = [];
		for (line <- readFileLines(file)) {
			if (IsBlankLine(line)) {
				continue;
			}
			lines += line;
		}
		fileMap[file] = lines;
	}
	return fileMap;
}

/*
 * Detects commented lines
 * 	V3: Add different comment variants
 *  '\/\/' 	=> \\
 *  '--' 	=> -- 
 *  '<!--'  => <!--
 *  '%'		=> %
 *  '#' 	=> #
 *
 */
public bool IsCommentedLine(str line) {	
	return /^(\s*)((\/\/)|(--)|(\<\!--)|(%)|(#))(.*$)/ := line;
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
public list[str] ProcessFileLine(loc file) {
	list[str] clean = [];
		
	bool processing = false;
	int startPost, endPos;
	
	for (line <- readFileLines(file)) {
				
		startPos = findFirst(line, "/*");
		endPos = findFirst(line, "*/");
		
		if ((startPos >= 0) && (endPos >= 0)) {
			/*
			 * Both found, special comment on single line
			 */
			continue;
		} else if ((startPos >= 0) && (endPos < 0)) {
			/*
			 * Offset not found, dealing with the start of
			 * a multi-line special comment
			 */
			if (!processing) {
				processing = true;
				continue;	
			}
			
		} else if ((startPos < 0) && (endPos >= 0)) {
			/*
			 * Start not found, dealing with the end of
			 * a multi-line special comment 
			 */
			if (processing) {
				processing = false;
				continue;
			}
		} else { 
			/* => startPos < 0 && endPos < 0
			 * 
			 * Both not found, dealing with a 'normal' line
			 *  or
			 * A line in between a multi-line comment
			 */
			if (processing) { // In between a multi-line comment
				// zero or more whitespaces, followed by a *, anything else
				if (/^\s*[*].*$/ := line) {
					continue;
				}
			} else { // 'normal' line
				// Moved single-line checker here
				if (IsCommentedLine(line) || IsBlankLine(line)) {
					continue;
				}
			}
		}
		// When we didn't prematurely exit
		clean += line;
	}
	
	return clean;
}