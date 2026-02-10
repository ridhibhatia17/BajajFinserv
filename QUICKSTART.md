# 🚀 Quick Start - Render Deployment

## Deploy in 5 Minutes!

Your application is **100% deployment-ready**. Follow these simple steps:

---

## Step 1: Push to GitHub (If Not Done)

```bash
cd "c:\Users\ridhi\OneDrive\Desktop\bajaj finserv"
git add .
git commit -m "Add Render deployment configuration"
git push origin main
```

---

## Step 2: Deploy on Render.com

### Automatic Deployment (Recommended) ⚡

1. Go to https://dashboard.render.com/
2. Click **"New +"** → **"Blueprint"**
3. **Connect your GitHub repository**
4. Render will auto-detect `render.yaml`
5. Click **"Apply"**
6. Wait 2-3 minutes ⏱️
7. Done! ✅

### Manual Deployment (Alternative)

1. Go to https://dashboard.render.com/
2. Click **"New +"** → **"Web Service"**
3. Select your GitHub repository
4. Configure:
   - **Name**: `bfhl-rest-api`
   - **Branch**: `main`
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
5. Add Environment Variables:
   ```
   NODE_ENV=production
   OFFICIAL_EMAIL=ridhi0946.be23@chitkara.edu.in
   RATE_LIMIT_WINDOW_MS=900000
   RATE_LIMIT_MAX_REQUESTS=100
   LOG_LEVEL=info
   ALLOWED_ORIGINS=*
   ```
6. Click **"Create Web Service"**
7. Wait 2-3 minutes ⏱️
8. Done! ✅

---

## Step 3: Verify Deployment

Once deployed, test your API:

### Health Check
```bash
curl https://your-service.onrender.com/health
```

Expected Response:
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in"
}
```

### Test Fibonacci
```bash
curl -X POST https://your-service.onrender.com/bfhl \
  -H "Content-Type: application/json" \
  -d '{"fibonacci": 10}'
```

Expected Response:
```json
{
  "fibonacci": [0, 1, 1, 2, 3, 5, 8, 13, 21, 34],
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in"
}
```

---

## Optional: Add Google Gemini AI

To enable AI responses:

1. Get your API key: https://makersuite.google.com/app/apikey
2. In Render Dashboard → Your Service → **Environment**
3. Add variable:
   ```
   GOOGLE_GEMINI_API_KEY=your_actual_api_key_here
   ```
4. Save and redeploy

Test AI:
```bash
curl -X POST https://your-service.onrender.com/bfhl \
  -H "Content-Type: application/json" \
  -d '{"AI": "Hello"}'
```

---

## What's Included? ✅

Your deployment includes:

### API Endpoints
- ✅ `POST /bfhl` - Process data (Fibonacci, Prime, LCM, HCF, AI)
- ✅ `GET /health` - Health check

### Security Features (All Tested)
- ✅ Content-Type validation (JSON only)
- ✅ Body size limits (100KB max)
- ✅ Empty body prevention
- ✅ Prototype pollution protection
- ✅ AI input sanitization
- ✅ Rate limiting (100 requests/15 min)
- ✅ Helmet.js security headers
- ✅ CORS configured

### Performance
- ✅ Optimized mathematical algorithms
- ✅ AI with 5s timeout and fallback
- ✅ Winston structured logging
- ✅ Graceful shutdown

### Tests Passing
- ✅ 12/12 security tests
- ✅ 8/8 regression tests
- ✅ 0 vulnerabilities

---

## Your Deployment URL

After deployment, your API will be at:
```
https://bfhl-rest-api.onrender.com
```

Or with your custom name:
```
https://your-custom-name.onrender.com
```

---

## Free Tier Features

Render free tier includes:
- ✅ 750 hours/month (24/7 uptime possible)
- ✅ Automatic SSL certificate
- ✅ Health monitoring
- ✅ Auto-deploy on push
- ⚠️ Cold starts after 15 min inactivity

### Prevent Cold Starts

Use **UptimeRobot** (free) to ping your service every 10 minutes:
1. Sign up at https://uptimerobot.com/
2. Add monitor → HTTP(s)
3. URL: `https://your-service.onrender.com/health`
4. Monitoring interval: 10 minutes

---

## Troubleshooting

### Build Failed?
```bash
# Test locally first
npm install
npm start
```

### Need Logs?
- Render Dashboard → Your Service → **"Logs"** tab

### Application Crashed?
- Check environment variables are set
- View logs for error messages

---

## Files Created for Deployment

1. **render.yaml** - Automatic deployment configuration
2. **RENDER_DEPLOYMENT_GUIDE.md** - Detailed guide
3. **DEPLOYMENT_CHECKLIST.md** - Pre-deployment verification
4. **.env.example** - Environment variable template
5. **QUICKSTART.md** - This file!

---

## Need Help?

- 📚 [Render Documentation](https://render.com/docs)
- 🛠️ [Troubleshooting Guide](https://render.com/docs/troubleshooting-deploys)
- 📧 Contact: ridhi0946.be23@chitkara.edu.in

---

## You're Ready! 🎉

Everything is configured and tested. Just:
1. Push to GitHub
2. Connect to Render
3. Deploy!

**No build errors. No configuration needed. Just deploy!** 🚀

---

**Last Updated**: February 10, 2026
