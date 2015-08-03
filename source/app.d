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

	string sigFile = "signatures.json";
	router.registerRestInterface(new OpenVaccineImpl(sigFile));

	auto settings = new HTTPServerSettings;
	
	settings.sslContext = createSSLContext(SSLContextKind.server);
	settings.sslContext.useCertificateChainFile("server.crt");
	settings.sslContext.usePrivateKeyFile("server.key");

	settings.port = 8080;
	settings.errorPageHandler = toDelegate(&showError);

	listenHTTP(settings, router);
}
