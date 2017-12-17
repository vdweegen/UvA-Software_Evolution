module util::Date
import String;
import DateTime;

public str time2str(datetime d) {
	return "<d.year>-<right("<d.month>", 2,"0")>-<right("<d.day>", 2,"0")>T<right("<d.hour>", 2,"0")>:<right("<d.minute>", 2,"0")>:<right("<d.second>", 2,"0")>.<right("<d.millisecond>", 3,"0")>Z";
}
