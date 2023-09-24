escapeSpecialChars(theString, reverse := false)
{	unEscaped := ["""", "``", "`r", "`n", ",", "%", ";", "::", "`b", "`t", "`v", "`a", "`f"]
	escaped := ["""""", "````", "``r", "``n", "``,", "``%", "``;", "``::", "``b", "``t", "``v", "``a", "``f"]
 
    search := reverse ? escaped : unEscaped
    replace := reverse ? unEscaped : escaped
 
	for index, s in search
	{	StringReplace, theString, theString, % s, % replace[index], All
	}
	return theString
}