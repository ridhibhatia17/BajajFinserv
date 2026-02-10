const http = require("http");

const req1 = http.request({
  hostname: "localhost",
  port: 3000,
  path: "/bfhl",
  method: "POST",
  headers: {}  // Explicitly empty headers
}, (res) => {
  console.log("Test 1 (no headers): Status =", res.statusCode);
  console.log("Request headers sent:", req1.getHeaders());
  res.on("data", () => {});
  res.on("end", () => {
    
    const req2 = http.request({
      hostname: "localhost",
      port: 3000,
      path: "/bfhl",
      method: "POST",
      headers: { "Content-Type": "text/plain" }
    }, (res2) => {
      console.log("\nTest 2 (text/plain): Status =", res2.statusCode);
      console.log("Request headers sent:", req2.getHeaders());
      res2.on("data", () => {});
      res2.on("end", () => process.exit(0));
    });
    req2.write(JSON.stringify({ AI: "test" }));
    req2.end();
  });
});

req1.write(JSON.stringify({ AI: "test" }));
req1.end();
