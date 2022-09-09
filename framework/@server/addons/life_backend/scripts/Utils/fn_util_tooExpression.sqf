/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params[
	["_input","",["",{},[],0,false,objNull]]
]; 

private _inputStr = str(_input); 
private _inputStrLen = count(_inputStr);  
private _expression = (switch (true) do {
	case ((typeName _input) isEqualTo "STRING"): 
	{    
		private _isFile = ((toLower(_inputStr select [(_inputStrLen-5),4])) isEqualTo '.sqf');
		if _isFile then{
			preprocessFile _input
		}else{
			_input
		}
	};
	case ((typeName _input) isEqualTo "CODE"): 
	{ 
		_inputStr select [1,_inputStrLen-2];
	};
	case ((typeName _input) in ["ARRAY","SCALAR","BOOL","OBJECT"]): 
	{   
		_inputStr
	}; 
	default        
	{
		_input
	};
});

_expression