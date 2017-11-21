module visualise::metrics::unitcomplexity::UnitComplexity

import visualise::helpers::SigClass;

import util::Math;
import List;
import IO;

/* 
 * Visualise the unitcomplexity (SIG Grading Scheme)
 * 	for the scope of the current project we assume the project
 *  to be JAVA, but leave room for future extension.
 */
public str VisualiseComplexity(lrel[int, int] rels) {
	return ReportSigClass(ClassifyComplexity(rels));
}


public list[real] partitionComplexity(lrel[int, int] rels) {
	list[real] c = [0.0,0.0,0.0,0.0];
	for (s <- rels) {
		int risk = 0;
		if (s[0] >= 50) {
			risk = 3;
		} else
		if (s[0] >= 20) {
			risk = 2;
		} else
		if (s[0] >= 10) {
			risk = 1;
		}
		c[risk] += s[1];
	}
	return c;
}

public int ClassifyComplexity(lrel[int, int] rels) {
	list[real] c = partitionComplexity(rels);
	
	real total = sum(c);

	int class;
	class = -2;
	
   	if (c[1] <= 25 && c[2] == 0 && c[3] == 0) {
     	class = 2;
    } else if (c[1] <= 30 && c[2] <= 5 && c[3] == 0) {
    	class = 1;
    } else if (c[1] <= 40 && c[2] <= 10 && c[3] == 0) {
    	class = 0;
    } else if (c[1] <= 50  && c[2] <= 15 && c[3] <= 5) {
      	class = -1;
    }

	return class;
}