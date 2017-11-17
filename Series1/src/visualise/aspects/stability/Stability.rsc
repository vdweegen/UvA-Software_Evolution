module visualise::aspects::stability::Stability

import visualise::helpers::SigClass;

/* 
 * Visualise the stability (SIG Grading Scheme)
 * 	uses the following source code properties:
 *		unit testing
 *
 * 	for the scope of the current project we assume the project
 *  to be JAVA, but leave room for future extension.
 */
 
public str VisualiseStability(int unittestingClass) {
	return ReportSigClass(ClassifyStability(unittestingClass));
}

public int ClassifyStability(int unittestingClass) {
	return unittestingClass;
}