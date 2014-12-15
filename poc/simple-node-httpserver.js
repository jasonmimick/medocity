var http = require('http');

var server = http.createServer(function(request, response) {
		console.log('reqeust.method='+request.method);
		console.log('request.url='+request.url);
		if (request.method == 'GET') {
			console.log('request.url='+request.url);
			console.log("Headers\n-------");
			console.dir( request.headers );
			response.writeHead(200, { "content-type" : "text/html" });
			response.write("url:" + request.url + "\n");
			response.write("TimeStamp: " + (new Date()));
			response.end();
		}
		if (request.method == 'POST') {
            var postData= '';
            request.on('data', function (data) {
                postData += data;
				//console.log("Partial body: " + postData);
            });
            request.on('end', function () {
				console.log("Headers\n-------");
				console.dir( request.headers );
				console.log("Post Data\n---------");
                console.log(postData);
   				response.writeHead(200, { "content-type" : "text/html" });
				response.write("Read:" + postData.length + " characters\n");
				response.write("TimeStamp: " + (new Date()));
				response.end();
         });
        }

	//console.dir(request);
});

var port = 9292;
if ( process.argv.length >= 3 ) {
	port = process.argv[2];
}
server.listen( port );
console.dir("Server listening on " + port);

