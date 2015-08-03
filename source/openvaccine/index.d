module openvaccine.index;

import vibe.d;


void showHome(HTTPServerRequest req, HTTPServerResponse res)
{
	logInfo("show Home");
	string username = "Tester Test";
	res.render!("home.dt", req, username);
}
