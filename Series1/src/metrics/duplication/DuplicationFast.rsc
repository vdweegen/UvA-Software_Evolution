module metrics::duplication::DuplicationFast

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

public list[list[&T]] createBlock(list[&T] target, int chunk) {
	return chunk > size(target) ? [target] : [target[(x).. ((x+chunk))] | int x <- [0 .. ceil(1 + (size(target) - chunk))]];
}


public list[&T] flatten(list[list[&T]] toFlat) = ([]| it + innerList| innerList<- toFlat);

public int Duplication(set[loc] filelist) {
	int window = 6;
	list[loc] sourcesList = toList(filelist);
	list[list[str]]  lines	= [normalize(readFileLines(sourcesList[x-1])) | x <- [1..size(sourcesList)+1]];
	list[str] cleanedLines = ([] | it + lines[x-1] | x <- [1..size(sourcesList)+1]);

	list[list[str]] blocks = createBlock(cleanedLines,window);
	map[list[str], int] disBlocks = rangeX(distribution(blocks) , {1});
	
	list[lrel[int idx, str line]] hashIndex2 = [];
	hashIndex2 = for(x <- [0 .. size(blocks)], blocks[x] in disBlocks) {
			str h = (intercalate("\n", blocks[x]));
			result = [];
		
			for(i <- [0.. window]) {
				str line =  blocks[x][i];
				result = push( <x+i,  line>, result);
			}
			
			append result;
	}
	
	return(size(dup(flatten(hashIndex2))));
}


public int Duplication(list[str] source) {
	window = 6;
	list[list[str]] blocks = createBlock(source,6);
	map[list[str], int] disBlocks = rangeX(distribution(blocks) , {1});
	list[lrel[int idx, str line]] hashIndex2 = [];
	hashIndex2 = for(x <- [0 .. size(blocks)], blocks[x] in disBlocks) {
			str h = (intercalate("\n", blocks[x]));
			result = [];
		
			for(i <- [0.. window]) {
				str line =  blocks[x][i];
				result = push( <x+i,  line>, result);
			}
			
			append result;
	}
	
	return(size(dup(flatten(hashIndex2))));;
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

