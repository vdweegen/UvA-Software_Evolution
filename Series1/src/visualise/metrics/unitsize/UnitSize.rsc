module visualise::metrics::unitsize::UnitSize

import visualise::helpers::SigClass;
import util::Math;

import List;
import IO;

/* 
 * Visualise the unitsize (SIG Grading Scheme)
 * 	for the scope of the current project we assume the project
 *  to be JAVA, but leave room for future extension.
 */
public str VisualiseUnitsize(list[int] lines) {
	return ReportSigClass(ClassifyUnitSize(lines));
}

/*
 * Got inspiration from: 
 *   https://www.sig.eu/files/en/01_SIG-TUViT_Evaluation_Criteria_Trusted_Product_Maintainability-Guidance_for_producers.pdf
 * 	 and http://www.cs.uu.nl/docs/vakken/apa/20140617-measuringsoftwareproductquality.pdf
 */
 
public list[real] partitionUnitSize(list[int] rels) {
	list[real] c = [0.0,0.0,0.0,0.0];
	for (m <- rels) {
		int risk = 0;
		
		if (m >= 74) {
			risk = 3;
		} else if (m >= 44) {
			risk = 2;
		} else if (m >= 30) {
			risk = 1;
		}
		c[risk] += m;
	}
	return c;
}
 


public int ClassifyUnitSize(list[int] lines) {
	list[real] c = partitionUnitSize(lines);
	real total = sum(c);
	int class = 2;
	
	// Percentages based on v9 of the SIG-TUViT paper
	if (c[3] > 0) {
		class -= 1;
	} 
	if (c[3] / total * 100 > 7.0) {
		class -= 1;
	} 
	if (c[2] / total * 100 > 21.4) {
		class -= 1;
	} 
	if (c[1] / total * 100 > 44.4) {
		class -= 1;
	} 
	
	return class;
}