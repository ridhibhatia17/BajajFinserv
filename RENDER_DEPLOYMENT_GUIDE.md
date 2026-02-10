# 🚀 Render.com Deployment Guide

## Quick Deploy to Render

### Prerequisites
- GitHub account with your code pushed to a repository
- Render.com account (free tier available)

---

## Option 1: Automatic Deployment (Recommended) 🌟

### Step 1: Push to GitHub
```bash
git add .
git commit -m "Prepare for Render deployment"
git push origin main
```

### Step 2: Deploy on Render
1. Go to [Render Dashboard](https://dashboard.render.com/)
2. Click **"New +"** → **"Blueprint"**
3. Connect your GitHub repository
4. Render will automatically detect `render.yaml` and deploy!

---

## Option 2: Manual Deployment

### Step 1: Create New Web Service
1. Go to [Render Dashboard](https://dashboard.render.com/)
2. Click **"New +"** → **"Web Service"**
3. Connect your GitHub repository
4. Select the repository: **bajaj-finserv** (or your repo name)

### Step 2: Configure Service
Fill in the following details:

| Field | Value |
|-------|-------|
| **Name** | `bfhl-rest-api` |
| **Region** | Oregon (US West) |
| **Branch** | `main` |
| **Runtime** | `Node` |
| **Build Command** | `npm install` |
| **Start Command** | `npm start` |
| **Instance Type** | `Free` |

### Step 3: Set Environment Variables
Add these environment variables in Render dashboard:

```
NODE_ENV=production
OFFICIAL_EMAIL=ridhi0946.be23@chitkara.edu.in
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
LOG_LEVEL=info
ALLOWED_ORIGINS=*
```

**Optional** (for AI features):
```
GOOGLE_GEMINI_API_KEY=your_actual_api_key_here
```

### Step 4: Deploy
Click **"Create Web Service"** and wait for deployment to complete (2-3 minutes).

---

## Post-Deployment

### Verify Deployment
Once deployed, Render provides you with a URL like:
```
https://bfhl-rest-api.onrender.com
```

### Test Endpoints

#### 1. Health Check
```bash
curl https://bfhl-rest-api.onrender.com/health
```

**Expected Response:**
```json
{
  "status": "OK",
  "timestamp": "2026-02-10T12:00:00.000Z",
  "uptime": 123.456,
  "service": "BFHL REST API"
}
```

#### 2. Test Fibonacci Endpoint
```bash
curl -X POST https://bfhl-rest-api.onrender.com/bfhl \
  -H "Content-Type: application/json" \
  -d '{"fibonacci": 10}'
```

**Expected Response:**
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "data": "0 1 1 2 3 5 8 13 21 34"
}
```

#### 3. Test AI Endpoint
```bash
curl -X POST https://bfhl-rest-api.onrender.com/bfhl \
  -H "Content-Type: application/json" \
  -d '{"AI": "What is AI?"}'
```

---

## Environment Variables Reference

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `NODE_ENV` | No | `development` | Application environment |
| `PORT` | No | `3000` | Port number (Render sets automatically) |
| `OFFICIAL_EMAIL` | No | `ridhi0946.be23@chitkara.edu.in` | Official email in responses |
| `RATE_LIMIT_WINDOW_MS` | No | `900000` | Rate limit window (15 min) |
| `RATE_LIMIT_MAX_REQUESTS` | No | `100` | Max requests per window |
| `LOG_LEVEL` | No | `info` | Logging level (error, warn, info, debug) |
| `ALLOWED_ORIGINS` | No | `*` | CORS allowed origins |
| `GOOGLE_GEMINI_API_KEY` | No | - | Google Gemini AI API key |

---

## Automatic Deployments

Render automatically deploys when you push to the `main` branch:

```bash
git add .
git commit -m "Update API"
git push origin main
```

Render will:
1. Detect the push
2. Run `npm install`
3. Start with `npm start`
4. Deploy the new version (zero downtime)

---

## Monitoring & Logs

### View Logs
1. Go to your service in Render Dashboard
2. Click **"Logs"** tab
3. View real-time logs

### Health Monitoring
Render automatically monitors `/health` endpoint:
- Checks every 30 seconds
- Restarts service if health check fails
- Sends email alerts on failures

---

## Troubleshooting

### Deployment Fails

**Error: Build failed**
```bash
# Check logs in Render dashboard
# Common fixes:
1. Ensure package.json has all dependencies
2. Check Node version compatibility (>=18.0.0)
3. Verify npm install completes successfully
```

**Error: Application crashed**
```bash
# Check if:
1. PORT is read from process.env.PORT (✅ Already configured)
2. All required dependencies are in package.json (✅ Done)
3. No hardcoded localhost URLs
```

### Service Not Responding

**Check health endpoint:**
```bash
curl https://your-service.onrender.com/health
```

**View logs in Render dashboard:**
- Look for startup errors
- Check for missing environment variables
- Verify all dependencies installed

### Rate Limiting Issues

If you hit rate limits (429 errors):
1. Increase `RATE_LIMIT_MAX_REQUESTS` in environment variables
2. Or increase `RATE_LIMIT_WINDOW_MS`

---

## Free Tier Limitations

Render Free Tier includes:
- ✅ 750 hours/month (enough for 24/7 uptime)
- ✅ Automatic HTTPS
- ✅ Auto-deploy from GitHub
- ⚠️ Spins down after 15 minutes of inactivity
- ⚠️ Cold start takes ~30 seconds

### Prevent Cold Starts
Use a service like [UptimeRobot](https://uptimerobot.com/) to ping your endpoint every 10 minutes:
```
https://your-service.onrender.com/health
```

---

## Production Checklist

Before deploying to production:

- [x] All tests passing locally
- [x] Environment variables configured
- [x] `.env` file in `.gitignore` (✅ Done)
- [x] Health endpoint working
- [x] Security features enabled (✅ All 5 implemented)
- [x] Rate limiting configured
- [x] Logging enabled
- [x] Error handling implemented
- [x] CORS configured
- [ ] Google Gemini API key added (optional)
- [ ] Custom domain configured (optional)

---

## Custom Domain (Optional)

### Add Custom Domain
1. Go to your service in Render
2. Click **"Settings"** → **"Custom Domain"**
3. Add your domain (e.g., `api.yourdomain.com`)
4. Update DNS records as instructed by Render
5. Render automatically provisions SSL certificate

---

## Cost Optimization

### Free Tier Usage
- Free tier is sufficient for development and small projects
- 750 hours/month = 24/7 uptime
- Unlimited bandwidth

### Upgrade to Paid (Optional)
- $7/month for Starter plan
- No cold starts
- Better performance
- More memory/CPU

---

## Support & Documentation

- [Render Documentation](https://render.com/docs)
- [Node.js on Render](https://render.com/docs/deploy-node-express-app)
- [Environment Variables](https://render.com/docs/environment-variables)
- [Health Checks](https://render.com/docs/health-checks)

---

## Security Notes

✅ **Already Implemented:**
- Content-Type validation (415 errors)
- Body size limits (100KB max)
- Empty body prevention
- Prototype pollution protection
- AI input sanitization
- Rate limiting (100 req/15min)
- Helmet.js security headers
- CORS protection
- HPP protection

🔐 **Additional Recommendations:**
- Add API key authentication for production
- Use Render's environment variable encryption
- Enable Render's DDoS protection
- Monitor logs for security events

---

## Quick Links

- **Render Dashboard**: https://dashboard.render.com/
- **API Documentation**: Check README.md
- **Security Documentation**: PRODUCTION_SECURITY_DOCUMENTATION.md
- **GitHub Repository**: Your repo URL

---

**Deployment Status: Ready! 🚀**

Your application is fully configured for Render deployment. Simply:
1. Push to GitHub
2. Connect to Render
3. Deploy!

---

**Last Updated**: February 10, 2026  
**Author**: ridhi0946.be23@chitkara.edu.in
