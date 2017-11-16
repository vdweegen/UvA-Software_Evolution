module metrics::duplication::Duplication

import helpers::Normalizer;
import metrics::volume::Volume;
import List;
import String;
import IO;
import Set;
import util::Math;
import ListRelation;
import Map;
import util::Benchmark;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

//public loc file = |project://smallsql0.21_src/src/smallsql/database/Column.java|;
public loc proj = |project://hsqldb-2.3.1/src/src|;
//public loc proj = |project://smallsql0.21_src|;

public M3 model = createM3FromEclipseProject(proj);
//public M3 modelFile = createM3FromFile(file);
public set[loc] sources = files(model);
//public str source = readFile(file);

/*

	Sliding window mehtod
	Calculate 


*/


int primeModolus = 10000000007;
int base = 256;

public void calcDups() {
	
	  println("Started Cleaning....");
	  list[str] linesToScan = toLines(intercalate("\n",[normalize(readFile(x)) | x <- sources]));
	  
	  println("Finished Cleaning....");
	  map[int, int] res = run(linesToScan);
	  println("Finished hashing....");
	  println("Total buckets: <size(res)>");
	  println("Dups: <size(rangeX(res, {1}))>");
	  println("Dup lines: <size(rangeX(res, {1})) * 6>");
	  println("Percentage: <(toReal(size(rangeX(res, {1})) * 6) / size(linesToScan)) * 100>");
}

public map[int, int] run(list[str] linesToScan) {
	map[int, int] m = ();
	
	
	int incr = 0;
	int window = 6;
	list[str] current = take(window, linesToScan);
	while(size(current) == window) {
		int h = hash(intercalate("\n",current));
		m[h] ? 0 += 1;
		incr+=1;
		current = take(window, drop(incr,linesToScan));
	}
	
	
	return m;
	
}


public str combineAll(set[loc] sources) {
	return intercalate("\n", [readFile(x) | x <- sources]);
}

public list[str] toLines(str source) {
	return split("\n", source);
}


@memo
public int hash(str subject) {
	
	return (0 | ((it * 256) + c - (97)) % primeModolus | c <- chars(subject));
}

public int hashChar(int ch) {
	return ch % primeModolus;
}