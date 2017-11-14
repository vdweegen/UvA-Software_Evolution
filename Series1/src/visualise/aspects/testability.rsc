module visualise::aspects::testability

import visualise::sigreport;

/* 
 * Visualise the analysability (SIG Grading Scheme)
 * 	uses the following source code properties:
 *		complexity per unit, unit size, unit testing
 *
 * 	for the scope of the current project we assume the project
 *  to be JAVA, but leave room for future extension.
 */
 
public str VisualiseTestability(int unitcomplexityClass, int unitsizeClass, int unittestingClass) {
	return ReportSigClass(ClassifyTestability(unitcomplexityClass, unitsizeClass, unittestingClas));
}

// TODO: Fix rounding
public int ClassifyTestability(int unitcomplexityClass, int unitsizeClass, int unittestingClass) {
	return (unitcomplexityClass + unitsizeClass + unittestingClass) / 3;
}