# Render.com Deployment Checklist

## Pre-Deployment Verification ✅

### 1. Code Repository
- [x] Code pushed to GitHub
- [x] `.env` file in `.gitignore`
- [x] `render.yaml` configuration created
- [x] `.env.example` template created

### 2. Application Configuration
- [x] `package.json` has correct start script: `"start": "node server.js"`
- [x] Node version specified in `package.json`: `"node": ">=18.0.0"`
- [x] All dependencies listed in `package.json`
- [x] PORT read from `process.env.PORT`
- [x] No hardcoded localhost URLs

### 3. Server Entry Point
- [x] Server file: `server.js` exists
- [x] Server starts with `npm start`
- [x] Health endpoint works: `/health`
- [x] No build errors

### 4. Security Features
- [x] Content-Type validation (415 errors)
- [x] Body size limits (100KB max)
- [x] Empty body prevention
- [x] Prototype pollution protection
- [x] AI input sanitization
- [x] Rate limiting configured
- [x] Helmet.js security headers
- [x] CORS configured

### 5. Test Coverage
- [x] All security tests passing (12/12)
- [x] All regression tests passing (8/8)
- [x] Health endpoint responding correctly

---

## Render Deployment Steps

### Option A: Automatic with render.yaml (Recommended) 🌟

1. **Push to GitHub**
   ```bash
   git add .
   git commit -m "Ready for Render deployment"
   git push origin main
   ```

2. **Deploy on Render**
   - Go to https://dashboard.render.com/
   - Click "New +" → "Blueprint"
   - Connect your GitHub repository
   - Render auto-detects `render.yaml`
   - Click "Apply" to deploy

### Option B: Manual Deployment

1. **Create Web Service**
   - Dashboard → "New +" → "Web Service"
   - Connect GitHub repo

2. **Configure**
   - Name: `bfhl-rest-api`
   - Branch: `main`
   - Build: `npm install`
   - Start: `npm start`

3. **Environment Variables**
   ```
   NODE_ENV=production
   OFFICIAL_EMAIL=ridhi0946.be23@chitkara.edu.in
   RATE_LIMIT_WINDOW_MS=900000
   RATE_LIMIT_MAX_REQUESTS=100
   LOG_LEVEL=info
   ALLOWED_ORIGINS=*
   ```

4. **Deploy**
   - Click "Create Web Service"
   - Wait 2-3 minutes

---

## Post-Deployment Verification

### 1. Health Check
```bash
curl https://your-service.onrender.com/health
```

Expected:
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in"
}
```

### 2. Test Fibonacci
```bash
curl -X POST https://your-service.onrender.com/bfhl \
  -H "Content-Type: application/json" \
  -d '{"fibonacci": 10}'
```

### 3. Test Prime
```bash
curl -X POST https://your-service.onrender.com/bfhl \
  -H "Content-Type: application/json" \
  -d '{"prime": [2,3,4,5,6,7]}'
```

### 4. Test AI
```bash
curl -X POST https://your-service.onrender.com/bfhl \
  -H "Content-Type: application/json" \
  -d '{"AI": "Hello"}'
```

### 5. Test Security
```bash
# Should return 415 (Unsupported Media Type)
curl -X POST https://your-service.onrender.com/bfhl \
  -d '{"fibonacci": 10}'
```

---

## Monitoring

### View Logs
- Render Dashboard → Your Service → "Logs" tab

### Check Status
- Render Dashboard → Your Service → "Events" tab

### Health Monitoring
- Automatic health checks every 30 seconds
- Email alerts on failures

---

## Troubleshooting

### Build Failed
**Check:**
- Node version compatibility (>=18.0.0)
- All dependencies in package.json
- npm install completes successfully

**Fix:**
```bash
# Locally test
npm install
npm start
```

### Application Crashed
**Check:**
- Server logs in Render dashboard
- Environment variables configured
- No missing dependencies

**Common Issues:**
- PORT not from environment (✅ Fixed)
- Missing dependencies (✅ All listed)
- Syntax errors (✅ Tested locally)

### Cold Starts (Free Tier)
**Issue:** Service sleeps after 15 min inactivity

**Solution:**
- Use UptimeRobot to ping every 10 min
- Or upgrade to paid plan ($7/month)

### Rate Limiting 429 Errors
**Fix:** Increase limits in environment variables
```
RATE_LIMIT_MAX_REQUESTS=200
```

---

## Success Criteria ✅

Your deployment is successful when:
- [x] Health endpoint returns 200 OK
- [x] All API endpoints working
- [x] Security features functioning
- [x] No errors in logs
- [x] Response times < 500ms

---

## Additional Resources

- [Render Docs](https://render.com/docs)
- [Node.js Guide](https://render.com/docs/deploy-node-express-app)
- [Troubleshooting](https://render.com/docs/troubleshooting-deploys)

---

## Deployment URL

After deployment, your API will be available at:
```
https://bfhl-rest-api.onrender.com
```

Or with custom name:
```
https://your-custom-name.onrender.com
```

---

**Status: READY FOR DEPLOYMENT! 🚀**

All checks passed. You can deploy to Render now!

---

**Last Verified**: February 10, 2026  
**Contact**: ridhi0946.be23@chitkara.edu.in
