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
public loc proj = |project://hsqldb-2.3.1/src/src|;
//public loc proj = |project://smallsql0.21_src|;
//public loc proj = |project://TestProject|;


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

public list[list[&T]] chunk(list[&T] target, int chunk) {
	return chunk > size(target) ? [target] : [target[(x*chunk).. ((x*chunk)+chunk)] | int x <- [0 .. ceil(size(target) / chunk)]];
}

public void ref() {
	list[loc] sourcesList = toList(sources);
	list[str] cleanedLines = ([] | it + normalize(readFileLines(sourcesList[x-1])) | x <- [1..size(sourcesList)+1]);
	
	// Lines to to keep
	map[str, int] candidateLines = rangeX(distribution(cleanedLines), {1});
	int window = 6;
	
	lrel[str block, int idx, str line] hashIndex = ([] | it + optimizedIndex(candidateLines, normalize(readFileLines(sourcesList[x-1])), window, x) | x <- [1..size(sourcesList)+1]);
	v = domain( rangeX ( distribution (hashIndex.block),{window}));
	lrel[int, str] newDup = ([] | it + hashIndex[{x}]| x <- v);
	print(size(dup(newDup)));
}

public int Duplication(set[loc] filelist) {
	int window = 6;
	list[loc] sources = toList(filelist);
	lrel[str block, int idx, str line] hashIndex = ([] | it + chunkAndHashIndexed(normalize(readFileLines(sources[x-1])), window, x) | x <- [1..size(sources)+1]);
    v = domain( rangeX ( distribution (hashIndex.block),{window}));
	lrel[int, str] newDup = ([] | it + hashIndex[{x}]| x <- v);
	return size(dup(newDup));
}


public list[list [str]] chunkAndHash(list[str] subject, int window) {
	list[str] body = subject;
	list[str] current = take(window, subject);
	list[list[str]] result = [];
	int incr = 0;
	
	while(size(current) == window) {
		int h = hash(intercalate("\n",current));
	    //println(m);
		incr+=1;
		result = push(current, result);
		body = drop(incr,subject);
		current = take(window, body);
	}
	
	return result;
}
public lrel [str block, int idx, str line] chunkAndHashIndexed(list[str] subject, int window, int fileIndex) {
	list[str] body = subject;
	list[str] current = take(window, subject);
	lrel[str block, int idx, str line] result = [];
	int incr = 0;
	
	while(size(current) == window) {
		str h = (intercalate("\n",current));
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



public lrel [str block, int idx, str line] optimizedIndex(map[str, int] candidates,list[str] subject, int window, int fileIndex) {
	list[str] body = subject;
	list[str] current = take(window, subject);
	lrel[str block, int idx, str line] result = [];
	int incr = 0;
	
	while(size(current) == window ) {
		incr+=1;
		if (any(str n <- current, n in candidates)) {
			str h = (intercalate("\n",current));
			
			
			for(i <- [0.. window]) {
				str line = current[i];
				result = push(<h, (fileIndex * 10000)+(incr+i),  line>, result);
			}
		}
		
		
		body = drop(incr,subject);
		current = take(window, body);
	}
	return result;
}

public list[lrel[int,str]] huntDuplicates(list[str] lines, int window) {
	lrel [str block, int idx, str line] R = chunkAndHashIndexed(lines, window, 1);
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
	return (0 | ((it * base) + c - (97)) % primeModolus | c <- chars(subject));
}
//@memo
//public int hash(str subject) {
//	
//	return (0 | ((it * base) + c - (97)) % primeModolus | c <- chars(subject));
//}

public int hashChar(int ch) {
	return ch % primeModolus;
}