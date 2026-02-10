const http = require("http");

function testRequest(opts, expectedStatus, name) {
  return new Promise((resolve) => {
    const req = http.request({
      hostname: "localhost",
      port: 3000,
      ...opts
    }, (res) => {
      let data = "";
      res.on("data", chunk => data += chunk);
      res.on("end", () => {
        const status = res.statusCode;
        console.log(`${name}: Status=${status}, Body length=${data.length}`);
        console.log(`Body preview: ${data.substring(0, 200)}`);
        console.log("");
        resolve({ status, body: data });
      });
    });
    req.on("error", err => {
      console.log(`${name}: ERROR - ${err.message}`);
      resolve({ status: -1 });
    });
    if (opts.body) req.write(opts.body);
    req.end();
  });
}

(async () => {
  console.log("Test 1: No Content-Type header");
  await testRequest({
    path: "/bfhl",
    method: "POST",
    headers: {},
    body: JSON.stringify({ AI: "test" })
  }, 415, "No Content-Type");
  
  console.log("Test 2: Wrong Content-Type");
  await testRequest({
    path: "/bfhl",
    method: "POST",
    headers: { "Content-Type": "text/plain" },
    body: JSON.stringify({ AI: "test" })
  }, 415, "Wrong Content-Type");
})();
