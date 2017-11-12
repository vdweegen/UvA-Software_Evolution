module visualise::sigreport

import visualise::aspects::analysability;
import visualise::aspects::changeability;
import visualise::aspects::stability;
import visualise::aspects::testability;

import visualise::metrics::duplication;
import visualise::metrics::unitcomplexity;
import visualise::metrics::unitsize;
import visualise::metrics::unittests;
import visualise::metrics::volume;

public str ReportSig(int analysability, int changeability, 
	int stability, int testability) {
	return "TODO";
}

public str ReportSigClass(int class) {
	if (class == 2) {
		return "++";
	} else
	if (class == 1) {
		return " +";
	} else
	if (class == 0) {
		return " o";
	} else
	if (class == -1) {
		return " -";
	} else
	if (class == -2) {
		return "--";
	} else {
		return "unsupported";
	}
}