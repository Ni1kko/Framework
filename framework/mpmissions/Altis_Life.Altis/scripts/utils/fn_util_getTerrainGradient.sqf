/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _object = _this;
private _terrainHeightCurrnet = getTerrainHeightASL (getPosASL _object);
private _terrainHeightInfront = getTerrainHeightASL (AGLToASL(_object getRelPos [1,0]));
private _gradient = abs(atan(_terrainHeightCurrnet - _terrainHeightInfront));

_gradient