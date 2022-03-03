arrayToString(theArray)
{	string := "{"
	for key, value in theArray
	{	if(A_index != 1)
		{	string .= ","
		}
        if key is number
        {   string .= key ":"
        } else if(IsObject(key))
        {   string .= arrayToString(key) ":"
        } else
        {   key := escapeSpecialChars(key)
            string .=  """" key """:" 
        }
        if value is number
        {   string .= value
        } else if (IsObject(value))
		{	string .= arrayToString(value)
		} else
		{	value := escapeSpecialChars(value)
			string .=  """" value """"
		}
	}
	return string "}"
}