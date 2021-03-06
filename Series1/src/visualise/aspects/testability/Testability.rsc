module visualise::aspects::testability::Testability

import visualise::helpers::SigClass;

import util::Math;

/* 
 * Visualise the analysability (SIG Grading Scheme)
 * 	uses the following source code properties:
 *		complexity per unit, unit size, unit testing
 *
 * 	for the scope of the current project we assume the project
 *  to be JAVA, but leave room for future extension.
 */
public str VisualiseTestability(int unitcomplexityClass, int unitsizeClass, int unittestingClass) {
	return ReportSigClass(ClassifyTestability(unitcomplexityClass, unitsizeClass, unittestingClass));
}

public int ClassifyTestability(int unitcomplexityClass, int unitsizeClass, int unittestingClass) {
	return floor(unitcomplexityClass + unitsizeClass + unittestingClass) / 3;
}