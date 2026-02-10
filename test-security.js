const http = require('http');

const tests = [
  { name: 'Missing Content-Type', opts: {  path: '/bfhl', method: 'POST', headers: {}, body: '{"AI":"test"}' }, expect: 415 },
  { name: 'Wrong Content-Type', opts: { path: '/bfhl', method: 'POST', headers: {'Content-Type': 'text/plain'}, body: '{"AI":"test"}' }, expect: 415 },
  { name: 'Valid Request', opts: { path: '/bfhl', method: 'POST', headers: {'Content-Type': 'application/json'}, body: '{"AI":"test"}' }, expect: 200 },
  { name: 'Empty Body', opts: { path: '/bfhl', method: 'POST', headers: {'Content-Type': 'application/json'}, body: '' }, expect: 400 },
  { name: 'Empty JSON', opts: { path: '/bfhl', method: 'POST', headers: {'Content-Type': 'application/json'}, body: '{}' }, expect: 400 },
  { name: 'Prototype __proto__', opts: { path: '/bfhl', method: 'POST', headers: {'Content-Type': 'application/json'}, body: '{"__proto__":{"admin":true}}' }, expect: 400 },
  { name: 'Prototype constructor', opts: { path: '/bfhl', method: 'POST', headers: {'Content-Type': 'application/json'}, body: '{"constructor":{"admin":true}}' }, expect: 400 },
  { name: 'Prototype prototype', opts: { path: '/bfhl', method: 'POST', headers: {'Content-Type': 'application/json'}, body: '{"prototype":{"admin":true}}' }, expect: 400 },
  { name: 'AI Input >5000 chars', opts: { path: '/bfhl', method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify({AI: 'A'.repeat(5001)}) }, expect: 400 },
  { name: 'Valid Fibonacci', opts: { path: '/bfhl', method: 'POST', headers: {'Content-Type': 'application/json'}, body: '{"fibonacci":5}' }, expect: 200 },
  { name: 'Valid Prime', opts: { path: '/bfhl', method: 'POST', headers: {'Content-Type': 'application/json'}, body: '{"prime":[2,3,4,5,6,7]}' }, expect: 200 },
  { name: 'Health Check', opts: { path: '/health', method: 'GET' }, expect: 200 }
];

let passed = 0, failed = 0;

async function runTest(test) {
  return new Promise((resolve) => {
    const opts = {
      hostname: 'localhost',
      port: 3000,
      ...test.opts
    };
    
    const req = http.request(opts, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        if (res.statusCode === test.expect) {
          console.log(`✓ PASS: ${test.name} (${res.statusCode})`);
          passed++;
        } else {
          console.log(`✗ FAIL: ${test.name} (expected ${test.expect}, got ${res.statusCode})`);
          failed++;
        }
        resolve();
      });
    });
    
    req.on('error', (err) => {
      console.log(`✗ FAIL: ${test.name} (${err.message})`);
      failed++;
      resolve();
    });
    
    if (test.opts.body) req.write(test.opts.body);
    req.end();
  });
}

(async () => {
  console.log('\n========================================');
  console.log('Production Security Features Test');
  console.log('========================================\n');
  
  for (const test of tests) {
    await runTest(test);
  }
  
  console.log('\n========================================');
  console.log('Summary');
  console.log('========================================');
  console.log(`Total: ${passed + failed}`);
  console.log(`Passed: ${passed}`);
  console.log(`Failed: ${failed}`);
  console.log(`Success Rate: ${Math.round((passed/(passed+failed))*100)}%`);
  console.log('========================================\n');
  
  if (failed === 0) {
    console.log('✓ ALL SECURITY TESTS PASSED!\n');
    process.exit(0);
  } else {
    console.log('✗ Some tests failed\n');
    process.exit(1);
  }
})();
