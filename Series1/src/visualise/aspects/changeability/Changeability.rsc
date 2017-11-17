module visualise::aspects::changeability

import visualise::helpers::SigClass;

import util::Math;

/* 
 * Visualise the changeability (SIG Grading Scheme)
 * 	uses the following source code properties:
 *		complexity per unit, duplication
 *
 * 	for the scope of the current project we assume the project
 *  to be JAVA, but leave room for future extension.
 */
 
public str VisualiseChangeability(int unitcomplexityClass, int duplicationClass) {
	return ReportSigClass(ClassifyChangeability(unitcomplexityClass, duplicationClass));
}

public int ClassifyChangeability(int unitcomplexityClass, int duplicationClass) {
	return round(unitcomplexityClass + duplicationClass) / 2;
}