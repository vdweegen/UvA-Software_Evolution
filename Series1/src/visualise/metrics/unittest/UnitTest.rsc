module visualise::metrics::unittest::UnitTest

import visualise::helpers::SigClass;

 
public str VisualiseUnittest(real percentage) {
	return ReportSigClass(ClassifyUnitTest(percentage));
}

public int ClassifyUnitTest(real percentage) {
	int class;
	if (percentage >= 95) {
		class = 2;
	} else
	if (percentage >= 80) {
		class = 1;
	} else
	if (percentage >= 60) {
		class = 0;
	} else
	if (percentage >= 20) {
		class = -1;
	} else {
		class = -2;
	}
	return class;
}