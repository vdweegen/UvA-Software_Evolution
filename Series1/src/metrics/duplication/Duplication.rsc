module metrics::duplication::Duplication

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import util::Math;
import util::Benchmark;

import helpers::Normalizer;
import metrics::volume::Volume;

import List;
import String;
import IO;
import Set;
import ListRelation;
import ListRelation;
import Map;

/*
 * Sliding window method
 * 	Calculate 
 */
public list[list[&T]] chunk(list[&T] target, int chunk) {
	return chunk > size(target) ? [target] : [target[(x*chunk).. ((x*chunk)+chunk)] | int x <- [0 .. ceil(size(target) / chunk)]];
}
public list[&T] flatten(list[list[&T]] toFlat) = ([]| it + innerList| innerList<- toFlat);

public int Duplication(set[loc] filelist) {
	int window = 6;
	list[loc] sourcesList = toList(filelist);
	list[list[str]]  lines	= [normalize(readFileLines(sourcesList[x-1])) | x <- [1..size(sourcesList)+1]];
	list[str] cleanedLines = ([] | it + lines[x-1] | x <- [1..size(sourcesList)+1]);
	
	// Lines to to keep
	map[str, int] candidateLines = rangeX(distribution(cleanedLines), {1});
	
	lrel[str block, int idx, str line] hashIndex = ([] | it + optimizedIndex(candidateLines, lines[x-1], window, x) | x <- [1..size(sourcesList)+1]);
	candidateBlocks = domain( rangeX ( distribution (hashIndex.block),{window}));
	//println(candidateBlocks);
	lrel[int, str] newDup = ([] | it + hashIndex[{x}]| x <- candidateBlocks);
	
	return(size(dup(newDup)));
}


public int Duplication(list[str] source) {
	window = 6;
	lrel[str block, int idx, str line] hashIndex = optimizedIndex(distribution(source), source, 6, 1);
	candidateBlocks = domain( rangeX ( distribution (hashIndex.block),{window}));
	
	lrel[int, str] newDup = ([] | it + hashIndex[{x}]| x <- candidateBlocks);
	return size(dup(newDup));
}


public lrel [str block, int idx, str line] optimizedIndex(map[str, int] candidates,list[str] subject, int window, int fileIndex) {
	list[str] body = subject;
	list[str] current = take(window, subject);
	lrel[str block, int idx, str line] result = [];
	int incr = 0;
	int fileLineIdx = fileIndex * 10000;
	while(size(current) == window ) {
		incr+=1;
		if (any(str n <- current, n in candidates)) {
			str h = (intercalate("\n",current));
			
		
			for(i <- [0.. window]) {
				str line = current[i];
				result = push(<h, fileLineIdx+(incr+i),  line>, result);
			}
		}
		
		
		body = drop(incr,subject);
		current = take(window, body);
	}
	return result;
}

