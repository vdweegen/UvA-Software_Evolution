module metrics::volume

// Extract the actual source code from all the lines
public list[str] LinesOfCode(set[loc] files) {
	// Map all the locs to our list
}

// Filter the actual code-lines from comments and blank lines
public map[loc, list[str]] LinesOfCodePerFile(set[loc] files) {
	map[loc, list[str]] fileMap = ();
	for (file <- files) {
		fileMap[file] = RemoveComments(file); // TODO Strip comments
	}
	return fileMap;
}

// Strip all the comments
public list[str] RemoveComments(loc file) {
	list[str] lines = [];
	
	// Do some magic here
	
	return lines;
}