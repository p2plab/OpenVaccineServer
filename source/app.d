module app;

import vibe.d;
import openvaccine.index;
import openvaccine.rest;


void showError(HTTPServerRequest req, HTTPServerResponse res, HTTPServerErrorInfo error)
{
	res.render!("error.dt", req, error);
}

shared static this()
{
	setLogFile("debug.log");

	auto router = new URLRouter;
	router.get("/", &showHome);
	router.get("/about", staticTemplate!"about.dt");
	router.get("*", serveStaticFiles("public"));

	registerRestInterface(router, new OpenVaccineImpl());

	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.errorPageHandler = toDelegate(&showError);

	listenHTTP(settings, router);
}
