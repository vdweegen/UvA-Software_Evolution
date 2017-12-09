Baxter et al 1995-1998
DECKARD: Scalable and Accurate Tree-based Detection of Code Clones http://web.cs.ucdavis.edu/~su/publications/icse07.pdf

AST based clone detection for type 1,2 and 3 clones


Idea:
Every clone pair has a type. But the best way to handle the same fragment having multiple clones of different types would be to show them as relations.
CloneA has Type 1 relation with CloneB
CloneB has Type 1 relation with CloneA

CloneC has Type 2 relation with CloneA
CloneC has Type 2 relation with CloneB

CloneD has Type 2 relation with CloneA
CloneD has Type 2 relation with CloneB

CloneC has Type 1 relation with CloneD
CloneD has Type 1 relation with CloneC

This can be expressed as a list of relations in the json.\

{
	pairs: [
		{id: CloneB, type: 1}
		{id: CloneC, type: 2}
		{id: CloneD, type: 2}
	]
}