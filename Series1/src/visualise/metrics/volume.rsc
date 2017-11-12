module visualise::metrics::volume

/* 
 * Visualise the volume (SIG Grading Scheme)
 * 	for the scope of the current project we assume the project
 *  to be JAVA, but leave room for future extension.
 */
 
public str VisualiseVolume(int lines) {
	return ReportSigClass(ClassifyLinesOfCode(lines));
}

private int ClassifyLinesOfCode(int lines) {
	int class;
	if (lines < 66000) {
		class = 2;
	} else
	if (lines < 246000) {
		class = 1;
	} else
	if (lines < 665000) {
		class = 0;
	} else
	if (lines < 1310000) {
		class = -1;
	} else {
		class = -2;
	}
	return class;
}

// Should move this to a higher level later on
private str ReportSigClass(int class) {
	if (class == 2) {
		return "++";
	} else
	if (class == 1) {
		return " +";
	} else
	if (class == 0) {
		return " o";
	} else
	if (class == -1) {
		return " -";
	} else
	if (class == -2) {
		return "--";
	} else {
		return "unsupported";
	}
}