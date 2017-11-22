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
	real norisk = c[0] * 100 / total;
	real lowrisk = c[1] * 100 / total;
	real mediumrisk = c[2] * 100 / total;
	real highrisk = c[3] * 100 / total;

	int class = -2;
	
   	if (lowrisk <= 25.0 && mediumrisk == 0.0 && highrisk == 0.0) {
     	class = 2;
    } else 
    if (lowrisk <= 30.0 && mediumrisk <= 5.0 && highrisk == 0.0) {
    	class = 1;
    } else 
    if (lowrisk <= 40.0 && mediumrisk <= 10.0 && highrisk == 0.0) {
    	class = 0;
    } else 
    if (lowrisk <= 50.0  && mediumrisk <= 15.0 && highrisk <= 5.0) {
      	class = -1;
    }

	return class;
}