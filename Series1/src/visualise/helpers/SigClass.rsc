module visualise::helpers::SigClass

public str ReportSigScore(int class) {
	if (class == 2) {
		return "*****";
	} else
	if (class == 1) {
		return "****";
	} else
	if (class == 0) {
		return "***";
	} else
	if (class == -1) {
		return "**";
	} else
	if (class == -2) {
		return "*";
	} else {
		return "unsupported";
	}
}

public str ReportSigClass(int class) {
	if (class == 2) {
		return "++";
	} else
	if (class == 1) {
		return "+";
	} else
	if (class == 0) {
		return "o";
	} else
	if (class == -1) {
		return "-";
	} else
	if (class == -2) {
		return "--";
	} else {
		return "unsupported";
	}
}