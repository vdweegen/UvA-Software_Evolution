module metrics::duplication::Duplication

import helpers::Normalizer;
import metrics::volume::Volume;
import List;
import String;
import IO;
import Set;
import ListRelation;
import util::Math;
import ListRelation;
import Map;
import util::Benchmark;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

//public loc file = |project://smallsql0.21_src/src/smallsql/database/Column.java|;
//public loc proj = |project://hsqldb-2.3.1/src/src|;
public loc proj = |project://smallsql0.21_src|;

public M3 model = createM3FromEclipseProject(proj);
//public M3 modelFile = createM3FromFile(file);
public set[loc] sources = files(model);
//public str source = readFile(file);

/*

	Sliding window mehtod
	Calculate 


*/
int primeModolus = 1000000000000000007;
int base = 256;
public void workingDups() {
	int window = 6;
	
	println("Building hash index");
	list[loc] sources = toList(sources);
	list[lrel[int block,int idx,str line]] hashIndexAll = [chunkAndHashIndexed(normalize(readFileLines(sources[x-1])), window, x) | x <- [1..size(sources)+1]];
	println("Done hash index");
	lrel[int block,int idx,str line] hashIndex = flatten(hashIndexAll);
	println("Extracting hash domain");
	list[int] domainHashIndex = domain(hashIndex);
	println("Done extracting");
	println("Compile list of all buckets larger then window size");
	//list[lrel[int,str]] duplicateBuckets =  [ hashIndex[{x}] | x <- domainHashIndex, size(hashIndex[{x}]) > window ];
	list[lrel[int,str]] newDup = [];
	newDup = for(x <-domainHashIndex) {
		bucket = hashIndex[{x}];
		if (size(bucket) > window) {
			append(bucket);
		}
		
	}
	//list[lrel[int,str]] duplicateBuckets =  [ hashIndex[{x}] | x <- domainHashIndex, size(hashIndex[{x}]) > window ];
	
	// count unique lines in duplicateBuckets
	println("Count unique lines in duplicateBuckets");
	print(size(dup(flatten(newDup))));
	
}


public void calcDups() {
	  int window = 6;
	  println("Started Cleaning....");
	  list[str] linesToScan = toLines(intercalate("\n",[normalize(readFile(x)) | x <- take(10, toList(sources))]));
	  println("Finished Cleaning....");
	  map[int, int] res = run(linesToScan, window);

	  println("Finished hashing....");
	  println("Total buckets: <size(res)>");
	  println("Dups: <size(rangeX(res, {1}))>");
	  println("Dup lines: <size(rangeX(res, {1})) * window>");
	  println("Percentage: <(toReal(size(rangeX(res, {1})) * window) / size(linesToScan)) * 100>");
}
public lrel[int, str] runKeepLine(list[str] linesToScan, int window) {
	map[int, int] m = ();
	lrel[int, str] ml = [];
	
	int incr = 0;

	list[str] current = take(window, linesToScan);
	list[str] body = linesToScan;
	
	while(size(current) == window) {
		int h = hash(intercalate("\n",current));
		//m[h] ? 0 += 1;
		incr+=1;
		ml = push(<h, intercalate("\n",current)>, ml);
		body = drop(incr,linesToScan);
		current = take(window, body);
	}
	
	
	return ml;
	
}

public map[int, int] run(list[str] linesToScan, int window) {
	map[int, int] m = ();
	
	
	int incr = 0;

	list[str] current = take(window, linesToScan);
	list[str] body = linesToScan;
	
	while(size(current) == window) {
		int h = hash(intercalate("\n",current));
		m[h] ? 0 += 1;
		incr+=1;
		
		body = drop(incr,linesToScan);
		current = take(window, body);
	}
	
	
	return m;
	
}

public list[list [str]] chunkAndHash(list[str] subject, int window) {
	list[str] body = subject;
	list[str] current = take(window, subject);
	list[list[str]] result = [];
	int incr = 0;
	
	while(size(current) == window) {
		int h = hash(intercalate("\n",current));
	
		incr+=1;
		result = push(current, result);
		body = drop(incr,subject);
		current = take(window, body);
	}
	
	return result;
}
public lrel [int block, int idx, str line] chunkAndHashIndexed(list[str] subject, int window, int fileIndex) {
	list[str] body = subject;
	list[str] current = take(window, subject);
	lrel[int block, int idx, str line] result = [];
	int incr = 0;
	
	while(size(current) == window) {
		int h = hash(intercalate("\n",current));
	
		incr+=1;
		
		for(i <- [0.. window]) {
			str line = current[i];
			result = push(<h, (fileIndex * 10000)+(incr+i),  line>, result);
		}
		
		
		body = drop(incr,subject);
		current = take(window, body);
	}
	
	return result;
}
//dup(flatten(toList(domain(rangeX(distribution(chunkAndHash(abc, 2)), {1}))))) DUPLICATION ONE LINER !
// R = chunkAndHashIndexed(abc, 4)
// [R[{x}] | x <- domain(R), size(R[{x}]) > 4  ]

public list[lrel[int,str]] huntDuplicates(list[str] lines, int window) {
	 lrel [int block, int idx, str line] R =  chunkAndHashIndexed(lines, window, 1);
	 return [ R[{x}] | x <- domain(R), size(R[{x}]) > window  ];	
	}

public list[&T] flatten(list[list[&T]] toFlat) = ([]| it + innerList| innerList<- toFlat);

public str combineAll(set[loc] sources) {
	return intercalate("\n", [readFile(x) | x <- sources]);
}

public list[str] toLines(str source) {
	return split("\n", source);
}


@memo
public int hash(str subject) {
	
	return (0 | ((it * 100) + c - (97)) % primeModolus | c <- chars(subject));
}

public int hashChar(int ch) {
	return ch % primeModolus;
}