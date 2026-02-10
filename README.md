# BFHL REST API

Production-ready REST API built with Node.js and Express for handling computational and AI requests.

## Author
**Email:** ridhi0946.be23@chitkara.edu.in

## Features

- ✅ Production-ready architecture
- ✅ Strict input validation
- ✅ Security middleware (Helmet, CORS, Rate Limiting)
- ✅ Comprehensive error handling
- ✅ Structured logging with Winston
- ✅ Docker support
- ✅ PM2 cluster mode
- ✅ Industry-standard folder structure
- ✅ **Google Gemini AI Integration** (New!)

## 🤖 Google Gemini AI Integration

The API now includes **Google Gemini AI** for intelligent single-word responses.

### Key Features:
- ✅ API key from environment variable (never hardcoded)
- ✅ Single-word responses (100% enforced)
- ✅ Safe failure handling with fallback system
- ✅ 5-second timeout protection
- ✅ Server never crashes on API errors

### Quick Setup:
1. Get API key from: https://makersuite.google.com/app/apikey
2. Add to `.env`: `GOOGLE_GEMINI_API_KEY=your_key_here`
3. Restart server: `npm start`

### Usage:
```json
POST /bfhl
{
  "AI": "What is artificial intelligence?"
}

Response:
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "data": "Intelligence"
}
```

### Documentation:
- Full Guide: [GEMINI_INTEGRATION_GUIDE.md](GEMINI_INTEGRATION_GUIDE.md)
- Quick Setup: [GEMINI_QUICK_SETUP.md](GEMINI_QUICK_SETUP.md)
- Test Suite: `test-gemini-ai.ps1`

### Fallback System:
If Gemini API is unavailable, the system automatically uses rule-based responses. Your server **never crashes**.

---

## API Endpoints

### 1. POST /bfhl

Process computational and AI requests. Request body must contain **EXACTLY ONE** key.

#### Supported Operations:

**Fibonacci Series**
```json
{
  "fibonacci": 10
}
```
Returns: Array of 10 fibonacci numbers

**Prime Numbers Filter**
```json
{
  "prime": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
}
```
Returns: Array of prime numbers only

**LCM Calculation**
```json
{
  "lcm": [12, 18, 24]
}
```
Returns: LCM value

**HCF Calculation**
```json
{
  "hcf": [12, 18, 24]
}
```
Returns: HCF value

**AI Response**
```json
{
  "AI": "What is your name?"
}
```
Returns: Single-word AI response

#### Success Response Format:
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "data": <result>
}
```

#### Error Response Format:
```json
{
  "is_success": false,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "error": "error message"
}
```

### 2. GET /health

Health check endpoint.

#### Response:
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in"
}
```

## Installation

### Prerequisites
- Node.js >= 18.0.0
- npm >= 9.0.0

### Local Setup

1. Clone the repository
```bash
cd "c:\Users\ridhi\OneDrive\Desktop\bajaj finserv"
```

2. Install dependencies
```bash
npm install
```

3. Create .env file (already created)
```bash
# .env file is present with configurations
```

4. Start development server
```bash
npm run dev
```

5. Start production server
```bash
npm start
```

## Docker Deployment

### Build and run with Docker
```bash
docker build -t bfhl-api .
docker run -p 3000:3000 bfhl-api
```

### Using Docker Compose
```bash
docker-compose up -d
```

## PM2 Deployment

### Install PM2 globally
```bash
npm install -g pm2
```

### Start application
```bash
pm2 start ecosystem.config.js --env production
```

### PM2 commands
```bash
pm2 status          # Check status
pm2 logs            # View logs
pm2 monit           # Monitor resources
pm2 restart all     # Restart all processes
pm2 stop all        # Stop all processes
pm2 delete all      # Delete all processes
```

## Project Structure

```
bajaj finserv/
├── src/
│   ├── config/
│   │   └── config.js              # Configuration management
│   ├── controllers/
│   │   ├── bfhl.controller.js     # BFHL endpoint logic
│   │   └── health.controller.js   # Health check logic
│   ├── middleware/
│   │   ├── errorHandler.js        # Error handling
│   │   ├── security.js            # Security middleware
│   │   └── validation.js          # Request validation
│   ├── routes/
│   │   ├── index.js               # Route aggregation
│   │   ├── bfhl.routes.js         # BFHL routes
│   │   └── health.routes.js       # Health routes
│   ├── services/
│   │   ├── computation.service.js # Mathematical operations
│   │   └── ai.service.js          # AI response generator
│   └── utils/
│       ├── helpers.js             # Utility functions
│       └── logger.js              # Logging configuration
├── app.js                         # Express app configuration
├── server.js                      # Server entry point
├── package.json                   # Dependencies
├── .env                           # Environment variables
├── .gitignore                     # Git ignore rules
├── Dockerfile                     # Docker configuration
├── docker-compose.yml             # Docker Compose config
├── ecosystem.config.js            # PM2 configuration
└── README.md                      # Documentation
```

## Security Features

- **Helmet.js**: Sets security HTTP headers
- **CORS**: Configurable cross-origin resource sharing
- **Rate Limiting**: Prevents abuse (100 requests per 15 minutes)
- **Input Validation**: Strict validation on all inputs
- **Error Sanitization**: Prevents information leakage in production

## Testing

### Manual Testing with cURL

**Test Health Endpoint:**
```bash
curl http://localhost:3000/health
```

**Test Fibonacci:**
```bash
curl -X POST http://localhost:3000/bfhl \
  -H "Content-Type: application/json" \
  -d "{\"fibonacci\": 10}"
```

**Test Prime:**
```bash
curl -X POST http://localhost:3000/bfhl \
  -H "Content-Type: application/json" \
  -d "{\"prime\": [1,2,3,4,5,6,7,8,9,10]}"
```

**Test LCM:**
```bash
curl -X POST http://localhost:3000/bfhl \
  -H "Content-Type: application/json" \
  -d "{\"lcm\": [12,18,24]}"
```

**Test HCF:**
```bash
curl -X POST http://localhost:3000/bfhl \
  -H "Content-Type: application/json" \
  -d "{\"hcf\": [12,18,24]}"
```

**Test AI:**
```bash
curl -X POST http://localhost:3000/bfhl \
  -H "Content-Type: application/json" \
  -d "{\"AI\": \"What is your name?\"}"
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| NODE_ENV | Environment mode | development |
| PORT | Server port | 3000 |
| OFFICIAL_EMAIL | Official email | ridhi0946.be23@chitkara.edu.in |
| GOOGLE_GEMINI_API_KEY | Google Gemini AI API key | (required for AI features) |
| RATE_LIMIT_WINDOW_MS | Rate limit window | 900000 (15 min) |
| RATE_LIMIT_MAX_REQUESTS | Max requests per window | 100 |
| LOG_LEVEL | Logging level | info |

## HTTP Status Codes

- **200**: Success
- **400**: Bad Request (validation errors)
- **404**: Not Found
- **429**: Too Many Requests (rate limit)
- **500**: Internal Server Error

## Production Deployment Checklist

- [x] Environment variables configured
- [x] Security middleware enabled
- [x] Rate limiting configured
- [x] Error handling implemented
- [x] Logging configured
- [x] Docker support added
- [x] PM2 configuration ready
- [x] Health check endpoint available
- [x] Input validation comprehensive
- [x] Graceful shutdown implemented

## Monitoring

The application includes:
- Winston logging to console
- PM2 process monitoring
- Health check endpoint for load balancers
- Graceful shutdown handling

## Support

For issues or questions, contact: ridhi0946.be23@chitkara.edu.in

## License

MIT
