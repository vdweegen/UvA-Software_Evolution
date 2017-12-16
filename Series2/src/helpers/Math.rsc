module helpers::Math

import List;
import Set;
import ListRelation;


public &T avg(list[&T] v) = (0 | it + x | x <- v) / size(v);