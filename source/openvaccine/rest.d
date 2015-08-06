/* 
 * This example module consists from several small example REST interfaces.
 * Features are not grouped by topic but by common their are needed. Each example
 * introduces few new more advanced features. Sometimes registration code in module constructor
 * is also important, it is then mentioned in example comment explicitly.
 */

module openvaccine.rest;

import vibe.appmain;
import vibe.core.core;
import vibe.core.log;
import vibe.http.rest;
import vibe.http.router;
import vibe.http.server;

import core.time;

import vibe.data.json;
import vibe.data.serialization;

import std.file, std.stdio;

alias string sha1;


struct Signature{
	string emailId;
	string fileId;
	string fileName;
}

struct ScanData{
	string title;
	string ver;
	Signature[sha1] signatures;
}

@rootPathFromName
interface OpenVaccineApi
{

	/* As you may see, using aggregate types in parameters is just as easy.
	 * Macthing request for this function will be "GET /scan_data"
	 * Answer will be of "application/json" type.
	 */
	// signature/os/version/vendor/model
	// ex => http://localhost:8080/open_vaccine_api/android/2.4/samsung/galuxy3/scan_data

	@path(":os/:version/:vendor/:model/scan_data")
	ScanData getScanData(string _os, string _version, string _vendor, string _model);
}

class OpenVaccineImpl : OpenVaccineApi
{
	this(immutable string jsonFile){
		if(exists(jsonFile)){
			string jsonString = cast(string)read(jsonFile);
			m_scanData = deserialize!(JsonSerializer, ScanData)(parseJsonString(jsonString));
		}
	}

	//Signature[sha1] m_signatures;
	ScanData m_scanData;

override: // usage of this handy D feature is highly recommended
	ScanData getScanData(string _os, string _version, string _vendor, string _model)
	{
		logInfo("getScanData call %s, %s, %s, %s", _os, _version, _vendor, _model);

		logInfo("scanData: %s", m_scanData);

		return m_scanData;
	}
}

unittest
{
	import std.stdio:writeln;

	auto router = new URLRouter;
	registerRestInterface(router, new OpenVaccineImpl());
	auto routes = router.getAllRoutes();

	foreach(r; routes) writeln(r);

	assert (routes[0].method == HTTPMethod.GET && routes[0].pattern == "/open_vaccine_api/:os/:version/:vendor/:model/scan_data");
}

