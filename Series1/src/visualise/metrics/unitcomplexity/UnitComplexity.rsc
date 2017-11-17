module visualise::metrics::unitcomplexity::UnitComplexity

import visualise::helpers::SigClass;

import util::Math;
import List;

/* 
 * Visualise the unitcomplexity (SIG Grading Scheme)
 * 	for the scope of the current project we assume the project
 *  to be JAVA, but leave room for future extension.
 */
public str VisualiseComplexity(lrel[int, int] rels) {
	return ReportSigClass(ClassifyComplexity(rels));
}

public int ClassifyComplexity(lrel[int, int] rels) {
	list[real] c = [0.0,0.0,0.0,0.0];
	for (s <- rels) {
		int risk = 0;
		if (s[0] > 10) {
			risk = 1;
		} else
		if (s[0] > 20) {
			risk = 2;
		} else
		if (s[0] > 50) {
			risk = 3;
		}
		c[risk] += s[1];
	}
	real total = sum(c);
	
	//println("No risk: <c[0] / total * 100>%");
	//println("Low risk: <c[1] / total * 100>%");
	//println("Medium risk: <c[2] / total * 100>%");
	//println("High risk: <c[3] / total * 100>%");
	
	int class;
	
	if ((c[3] > 0) || (c[2] > 0) || (c[1] > 25)) {
		//println("1");
		class = 1;
	} else
	if ((c[3] > 0) || (c[2] > 5) || (c[1] > 30)) {
		//println("0");
		class = 0;
	} else
	if ((c[3] > 0) || (c[2] > 10) || (c[1] > 40)) {
		//println("-1");
		class = -1;
	} else
	if ((c[3] > 5) || (c[2] > 15) || (c[1] > 50)) {
		//println("-2");
		class = -2;
	} else {
		//println("2");
		class = 2;
	}
	return class;
}