module visualise::metrics::volume::Volume

import visualise::helpers::SigClass;

/* 
 * Visualise the volume (SIG Grading Scheme)
 * 	for the scope of the current project we assume the project
 *  to be JAVA, but leave room for future extension.
 */
 
public str VisualiseVolume(int lines) {
	return ReportSigClass(ClassifyVolume(lines));
}

public int ClassifyVolume(int lines) {
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