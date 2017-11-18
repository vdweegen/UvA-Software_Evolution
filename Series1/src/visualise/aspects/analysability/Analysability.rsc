module visualise::aspects::analysability::Analysability

import visualise::helpers::SigClass;

import util::Math;

/* 
 * Visualise the analysability (SIG Grading Scheme)
 * 	uses the following source code properties:
 *		volume, duplication, unit size, unit testing
 *
 * 	for the scope of the current project we assume the project
 *  to be JAVA, but leave room for future extension.
 */
 
public str VisualiseAnalysability(int volumeClass, int duplicationClass, int unitsizeClass, int unittestingClass = 0) {
	return ReportSigClass(ClassifyAnalysability(volumeClass, duplicationClass, unitsizeClass, unittestingClass));
}

public int ClassifyAnalysability(int volumeClass, int duplicationClass,
	int unitsizeClass, int unittestingClass = 0) {
	return round(volumeClass + duplicationClass + unitsizeClass + unittestingClass) / 4;
}