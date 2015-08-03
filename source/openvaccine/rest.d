/* This example module consists from several small example REST interfaces.
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

/* --------- EXAMPLE 1 ---------- */

/* Very simple REST API interface. No additional configurations is used,
 * all HTTP-specific information is generated based on few conventions.
 *
 * All types are serialized and deserialized automatically by vibe.d framework using JSON.
 */



enum SignatureType{
	File,
	Sign
}

struct Signature {
	 string sigType; // [File, Sign]
	 string data; 
}

struct ScanData
{
	string os;
	string osVersion;
	string vendor;
	string model;

	Signature[] signatures;
}

@rootPathFromName
interface OpenVaccineApi
{

	/* As you may see, using aggregate types in parameters is just as easy.
	 * Macthing request for this function will be "GET /scan_data"
	 * Answer will be of "application/json" type.
	 */
	// signature/os/version/vendor/model
	// ex => https://HOST/open_vaccine_api/scan_data/android/2.4/samsung/galuxy3

	@path(":os/:version/:vendor/:model/scan_data")
	ScanData getScanData(string _os, string _version, string _vendor, string _model);
}

class OpenVaccineImpl : OpenVaccineApi
{
override: // usage of this handy D feature is highly recommended
	ScanData getScanData(string _os, string _version, string _vendor, string _model)
	{

		logInfo("getScanData call %s, %s, %s, %s", _os, _version, _vendor, _model);
		ScanData s;
		s.signatures ~= Signature("File", "FileData");
		return s;
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

