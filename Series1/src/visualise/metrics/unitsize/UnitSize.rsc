module visualise::metrics::unitsize::UnitSize

import visualise::helpers::SigClass;
import util::Math;

import List;
//import IO;

/* 
 * Visualise the unitsize (SIG Grading Scheme)
 * 	for the scope of the current project we assume the project
 *  to be JAVA, but leave room for future extension.
 */
 
// TODO: Look at volume.rsc

public str VisualiseUnitsize(list[int] lines) {
	return ReportSigClass(ClassifyLinesOfCodePerMethod(lines));
}

/*
 * Got inspiration from: 
 *   https://www.sig.eu/files/en/01_SIG-TUViT_Evaluation_Criteria_Trusted_Product_Maintainability-Guidance_for_producers.pdf
 */
public int ClassifyUnitSize(list[int] lines) {
	list[real] c = [0.0,0.0,0.0,0.0];
	for (m <- lines) {
		int risk = 0;
		if (m > 15) {
			risk = 1;
		} else
		if (m > 30) {
			risk = 2;
		} else
		if (m > 60) {
			risk = 3;
		}
		c[risk] += 1.0;
	}
	real total = sum(c);
	int class = 2;
	
	//println("No risk: <c[0] / total * 100>%");
	//println("Low risk: <c[1] / total * 100>%");
	//println("Medium risk: <c[2] / total * 100>%");
	//println("High risk: <c[3] / total * 100>%");
	
	if (c[3] > 0) {
		class -= 1;
	} else
	if (c[3] / total * 100 > 5.8) {
		class -= 1;
	} else
	if (c[2] / total * 100 > 20.3) {
		class -= 1;
	} else
	if (c[1] / total * 100 > 42.8) {
		class -= 1;
	} 
	return class;
}