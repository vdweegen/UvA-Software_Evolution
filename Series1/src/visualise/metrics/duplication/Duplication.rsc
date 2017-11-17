module visualise::metrics::duplication::Duplication

import visualise::helpers::SigClass;

/* 
 * Visualise the duplication (SIG Grading Scheme)
 * 	for the scope of the current project we assume the project
 *  to be JAVA, but leave room for future extension.
 */

public str VisualiseDuplication(int dups, int total) {
	return ReportSigClass(ClassifyDuplication(dups, total));
}

public int ClassifyDuplication(int dups, int total) {
	int class;
	real d = (dups / 1.0) / total * 100;
	if (d <= 3) {
		class = 2;
	} else
	if (d <= 5) {
		class = 1;
	} else
	if (d <= 10) {
		class = 0;
	} else
	if (d <= 20) {
		class = -1;
	} else {
		class = -2;
	}
	return class;
}