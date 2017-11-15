module metrics::duplication

import List;
import String;


public int duplicateThreshold = 4;

public bool isSubset(x, y) {
	if([*_, s:[*_, x, *_], *_] := y, s!=x) return true;
	return false;
}

public list[list [str]] findDuplicates(lines, int threshold) {
	return for([*_, *X, *_, X, *_] := lines,  size(X)>= threshold) append(X);
} 

list[list[str]] scan (str source) {
	l = split("\n", source);
	list[list [str]] d = findDuplicates(l, duplicateThreshold);
	list[list [str]] r = removeSubSets(d);
	return r;
}

int numberOfDuplicates (ir) {
	return size(ir);
}

list[list[str]] removeSubSets(l) {
	return [x | x <- l, !isSubset(x,l)];
}

test bool countDups() = numberOfDuplicates(scan(example)) == 3;

public str example = "
fun main(args: Arraytring) {
	    println(stripBlockComments(sample))
	    val d1 = Regex.escape(del1)
	    val d2 = Regex.escape(del2)
}
	fun stripBlockComments(text: String, del1: String =  del2: String = : String {
	    val d1 = Regex.escape(del1)
	    val d2 = Regex.escape(del2)


	}
	 
fun main(args: Arraytring) {
	    println(stripBlockComments(sample))
	    val d1 = Regex.escape(del1)
	    val d2 = Regex.escape(del2)
}

	fun stripBlockComments(text: String, del1: String =  del2: String = : String {
	    val d1 = Regex.escape(del1)
	    val d2 = Regex.escape(del2)


	}
	
	
	fun main(args: Arraytring) {
	    println(stripBlockComments(sample))
	    val d1 = Regex.escape(del1)
	    val d2 = Regex.escape(del2)
}

	fun stripBlockComments(text: String, del1: String =  del2: String = : String {
	    val d1 = Regex.escape(del1)
	    val d2 = Regex.escape(del2)


	}
	 
";




