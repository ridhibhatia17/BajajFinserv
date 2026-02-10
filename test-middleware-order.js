const express = require('express');
const app = express();

app.use((req, res, next) => {
  console.log('Middleware 1: Content-Type =', req.get('Content-Type') || 'MISSING');
  if (!req.get('Content-Type')) {
    console.log('Returning 415');
    return res.status(415).send('No Content-Type');
  }
  next();
});

app.use(express.json());

app.post('/test', (req, res) => {
  console.log('Route handler: body =', req.body);
  res.json({ success: true, body: req.body });
});

app.listen(3001, () => console.log('Test server on 3001'));
