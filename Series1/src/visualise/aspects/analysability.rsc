module visualise::aspects::analysability

import visualise::sigreport;

import util::Math;

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

public int ClassifyAnalysability(int volumeClass, int duplicationClass,
	int unitsizeClass, int unittestingClass) {
	return round(volumeClass + duplicationClass + unitsizeClass + unittestingClass) / 4;
}