# 🚀 BFHL REST API - Quick Reference

## ⚡ Quick Start

```bash
# Install dependencies
npm install

# Start server
npm start

# Run tests
./test-api.ps1
```

Server runs on: **http://localhost:3000**

---

## 📡 API Endpoints

### GET /health
```http
GET http://localhost:3000/health
```

**Response:**
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in"
}
```

---

### POST /bfhl

**⚠️ IMPORTANT: Send EXACTLY ONE key per request**

#### 1️⃣ Fibonacci
```json
{"fibonacci": 10}
```
Returns: `[0,1,1,2,3,5,8,13,21,34]`

#### 2️⃣ Prime Filter
```json
{"prime": [1,2,3,4,5,6,7,8,9,10]}
```
Returns: `[2,3,5,7]`

#### 3️⃣ LCM
```json
{"lcm": [12,18,24]}
```
Returns: `72`

#### 4️⃣ HCF
```json
{"hcf": [12,18,24]}
```
Returns: `6`

#### 5️⃣ AI
```json
{"AI": "What is your name?"}
```
Returns: `"BFHL"`

---

## ✅ Success Response Format
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "data": <result>
}
```

## ❌ Error Response Format
```json
{
  "is_success": false,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "error": "<error message>"
}
```

---

## 📝 Validation Rules

| Key | Type | Rules | Returns |
|-----|------|-------|---------|
| fibonacci | Integer | 1-100 | Array |
| prime | Integer[] | Non-empty, all positive | Array |
| lcm | Integer[] | Min 2 items, all positive | Number |
| hcf | Integer[] | Min 2 items, all positive | Number |
| AI | String | 1-500 chars | String |

---

## 🔒 HTTP Status Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 400 | Validation Error |
| 404 | Route Not Found |
| 429 | Rate Limit Exceeded |
| 500 | Server Error |

---

## 🧪 Quick Test (PowerShell)

```powershell
# Test Health
Invoke-WebRequest -Uri "http://localhost:3000/health" -UseBasicParsing

# Test Fibonacci
$body = '{"fibonacci": 10}'
Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing

# Test Prime
$body = '{"prime": [1,2,3,4,5,6,7,8,9,10]}'
Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing

# Test LCM
$body = '{"lcm": [12,18,24]}'
Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing

# Test HCF
$body = '{"hcf": [12,18,24]}'
Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing

# Test AI
$body = '{"AI": "What is your name?"}'
Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
```

---

## 🐳 Deployment Options

### Node.js
```bash
npm start
```

### PM2 (Production)
```bash
pm2 start ecosystem.config.js --env production
pm2 status
pm2 logs
```

### Docker
```bash
docker build -t bfhl-api .
docker run -p 3000:3000 bfhl-api
```

### Docker Compose
```bash
docker-compose up -d
docker-compose logs -f
docker-compose down
```

---

## 📂 Project Structure

```
bajaj finserv/
├── src/
│   ├── config/           # Configuration
│   ├── controllers/      # Request handlers
│   ├── middleware/       # Validation, security, errors
│   ├── routes/           # Route definitions
│   ├── services/         # Business logic
│   └── utils/            # Helpers, logging
├── server.js             # Entry point
├── app.js                # Express setup
├── package.json          # Dependencies
├── .env                  # Environment config
├── Dockerfile            # Docker config
├── ecosystem.config.js   # PM2 config
└── test-api.ps1         # Test script
```

---

## 🛡️ Security Features

✅ Helmet.js - Security headers  
✅ CORS protection  
✅ Rate limiting (100 req/15min)  
✅ Input validation  
✅ Error sanitization  
✅ Request size limits  

---

## 📊 Rate Limits

- **Window:** 15 minutes
- **Max Requests:** 100 per IP
- **Response Code:** 429

---

## 🔍 Monitoring

Check logs for:
- Request/response times
- Validation failures
- Error tracking
- Health checks

Logs show:
```
2026-02-10 11:27:38 [info]: Processing BFHL request with key: fibonacci
2026-02-10 11:27:38 [info]: Fibonacci generated for n=10: 10 terms
POST /bfhl 200 5.919 ms - 101
```

---

## 🐛 Troubleshooting

**Port already in use?**
```bash
# Find process
netstat -ano | findstr :3000
# Kill process
taskkill /PID <PID> /F
```

**Dependencies issue?**
```bash
rm -rf node_modules package-lock.json
npm install
```

**Server not responding?**
```bash
# Check if running
curl http://localhost:3000/health
# Or
Invoke-WebRequest -Uri "http://localhost:3000/health" -UseBasicParsing
```

---

## 📧 Contact

**Developer:** ridhi0946.be23@chitkara.edu.in  
**Version:** 1.0.0  
**Date:** February 10, 2026

---

## ✨ Features Checklist

✅ Strict input validation  
✅ Exact response format matching  
✅ Correct HTTP status codes  
✅ Production-ready architecture  
✅ Security middleware  
✅ Comprehensive error handling  
✅ Industry folder structure  
✅ Deployment configurations  
✅ Logging and monitoring  
✅ Rate limiting  
✅ Docker support  
✅ PM2 cluster mode  
✅ Graceful shutdown  
✅ Health check endpoint  
✅ Complete documentation  
✅ Test scripts  

---

**🎉 API is production-ready and fully functional!**
