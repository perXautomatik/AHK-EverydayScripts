getNextValue(ByRef string, start)
{   if(RegExMatch(string, "\s*[+-]{0,1}[\d\.]", "", start) == start)
    {   ;it's a number
        start := RegExMatch(string, "[+-]{0,1}[\d\.]", "", start)
        end := regexmatch(string, "[^\d\.+-]", value, start)
        return [substr(string, start, end - start), end]
    }
    if(RegExMatch(string, "\s*""", "", start) == start)
    {   ;it is a string
        check := start := RegExMatch(string, """", "", start) + 1
        Loop
        {   ;find the next "
            end := InStr(string, """", true, check)
            ;check if the " found is actually an escaped " (ie "")
            if(end == instr(string, """""", true, check))
            {   ;indicates an escaped "
                check := end + 2
            } else
            {   break
            }
        }
        return [escapeSpecialChars(substr(string, start, end - start), reverse := true), end + 1]
    }
    if(RegExMatch(string, "\s*\{", "", start) == start)
    {   
        ;it is another object!
        if(RegExMatch(string, "}", "", start) == start +1)
        {
            ;the other object is an emtpy object
            return [{}, start + 2]
        }
        start := instr(string, "{", true, start)
        end := start + 1
        ;if we find an { then we need to find an additional }
        braceCount := 0
        ;braces within "'s are ignored
        ignoreBraces := false
        ;find the closing brace
        while(end := RegExMatch(string, "[""\{}]", found, end))
        {   if(found == """")
            {   ignoreBraces := ! ignoreBraces
            } else if(found == "{")
            {   braceCount++
            } else if(found == "}" && ignoreBraces == false)
            {   if(braceCount == 0)
                {   break
                }
                braceCount--
            }
            end++
        }
        if(end == 0)
        {   MsgBox end is 0
            return false
        }
        ;MsgBox % substr(string, start, end - start + 1)
        value := stringToArray(substr(string, start, end - start + 1))
        if(value)
        {   return [value , end + 1 ]
        }
    }
    MsgBox didn't start with a good value
    return false
}