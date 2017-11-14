module visualise::aspects::analysability

import visualise::sigreport;

/* 
 * Visualise the analysability (SIG Grading Scheme)
 * 	uses the following source code properties:
 *		volume, duplication, unit size, unit testing
 *
 * 	for the scope of the current project we assume the project
 *  to be JAVA, but leave room for future extension.
 */
 
public str VisualiseAnalysability(int volumeClass, int duplicationClas, int unitsizeClass, int unittestingClass) {
	return ReportSigClass(ClassifyAnalysability(volumeClass, duplicationClass, unitsizeClass, unittestingClass));
}

// TODO: Fix rounding
public int ClassifyAnalysability(int volumeClass, int duplicationClass,
	int unitsizeClass, int unittestingClass) {
	return (volumeClass + duplicationClass + unitsizeClass + unittestingClass) / 4;
}