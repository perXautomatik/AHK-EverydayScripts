stringToArray(theString)
{	
	if(theString == "{}")
	{
		return {}
	}
        if(RegExMatch(theString, "\R") || instr(theString, "{") != 1 || instr(theString, "}", true, 0) != strlen(theString))
	{ 	return false
	}
    returnArray := object()
    start := 2
    Loop
    {   valueString := getNextValue(theString, start) 
        if(valueString == false)
        {   ;invalid value for key
            break
        }
        key := valueString[1]
        start := valueString[2]
        if(RegExMatch(theString, "\s*:", "", start) != start++)
        {   ;no ':' after key
            break
        }
        valueString := getNextValue(theString, start)
         if(valueString == false)
        {   ;invalid value for value
            break
        }
        value := valueString[1]
        start := valueString[2] 
        returnArray.insert(key, value)
        if(RegExMatch(theString, "\s*}", "", start) == start)
        {   ;closing brace indiacates end of the object
            return returnArray
        } else
        {   start := InStr(theString, ",", true, start)
            if(start == 0)
            {   ;no closing brace or comma before the next var
                break
            }
            start++
        }
    }
    return false
}