# API Testing Guide

## Quick Start

### 1. Install Dependencies
```bash
npm install
```

### 2. Start Server
```bash
npm start
```

### 3. Run Tests
```powershell
./test-api.ps1
```

## API Endpoints Reference

### GET /health
**Description:** Health check endpoint

**Response:**
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in"
}
```

---

### POST /bfhl

**Description:** Main computation endpoint - accepts EXACTLY ONE key

#### Operation 1: Fibonacci Series

**Request:**
```json
{
  "fibonacci": 10
}
```

**Validation Rules:**
- Must be a positive integer
- Must be ≤ 100
- Returns array of fibonacci numbers

**Success Response (200):**
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "data": [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
}
```

**Example:**
```powershell
$body = '{"fibonacci": 10}'
Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
```

---

#### Operation 2: Prime Number Filter

**Request:**
```json
{
  "prime": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
}
```

**Validation Rules:**
- Must be a non-empty array
- All elements must be positive integers
- Returns only prime numbers from the array

**Success Response (200):**
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "data": [2, 3, 5, 7]
}
```

**Example:**
```powershell
$body = '{"prime": [1,2,3,4,5,6,7,8,9,10]}'
Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
```

---

#### Operation 3: LCM Calculation

**Request:**
```json
{
  "lcm": [12, 18, 24]
}
```

**Validation Rules:**
- Must be an array with at least 2 elements
- All elements must be positive integers
- Returns the Least Common Multiple

**Success Response (200):**
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "data": 72
}
```

**Example:**
```powershell
$body = '{"lcm": [12, 18, 24]}'
Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
```

---

#### Operation 4: HCF Calculation

**Request:**
```json
{
  "hcf": [12, 18, 24]
}
```

**Validation Rules:**
- Must be an array with at least 2 elements
- All elements must be positive integers
- Returns the Highest Common Factor (GCD)

**Success Response (200):**
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "data": 6
}
```

**Example:**
```powershell
$body = '{"hcf": [12, 18, 24]}'
Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
```

---

#### Operation 5: AI Response

**Request:**
```json
{
  "AI": "What is your name?"
}
```

**Validation Rules:**
- Must be a non-empty string
- Maximum length: 500 characters
- Returns a single-word AI response

**Success Response (200):**
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "data": "BFHL"
}
```

**Example:**
```powershell
$body = '{"AI": "What is your name?"}'
Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
```

**AI Response Mapping (Sample Keywords):**
- "name", "who" → "BFHL"
- "hello", "hi" → "Hello"
- "how" → "Good"
- "weather" → "Sunny"
- "time" → "Now"
- "where" → "Here"
- Yes/No questions → "Yes"
- Default → "Understood"

---

## Error Responses

All errors follow this format:
```json
{
  "is_success": false,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "error": "error message"
}
```

### Common Errors

#### 1. Empty Request Body (400)
**Request:**
```json
{}
```

**Response:**
```json
{
  "is_success": false,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "error": "Request body is required"
}
```

---

#### 2. Multiple Keys (400)
**Request:**
```json
{
  "fibonacci": 10,
  "prime": [1, 2, 3]
}
```

**Response:**
```json
{
  "is_success": false,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "error": "Request must contain exactly one key from: fibonacci, prime, lcm, hcf, AI"
}
```

---

#### 3. Invalid Key (400)
**Request:**
```json
{
  "invalid": 10
}
```

**Response:**
```json
{
  "is_success": false,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "error": "Invalid key 'invalid'. Must be one of: fibonacci, prime, lcm, hcf, AI"
}
```

---

#### 4. Invalid Data Type (400)
**Request:**
```json
{
  "fibonacci": -5
}
```

**Response:**
```json
{
  "is_success": false,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "error": "fibonacci value must be a positive integer"
}
```

---

#### 5. Route Not Found (404)
**Request:** GET `/invalid-route`

**Response:**
```json
{
  "is_success": false,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "error": "Route not found"
}
```

---

#### 6. Rate Limit Exceeded (429)
**Triggered after:** 100 requests in 15 minutes from same IP

**Response:**
```json
{
  "is_success": false,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "error": "Too many requests from this IP, please try again later"
}
```

---

#### 7. Internal Server Error (500)
**Response:**
```json
{
  "is_success": false,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "error": "Internal server error"
}
```

---

## HTTP Status Codes

| Status Code | Description |
|-------------|-------------|
| 200 | Success |
| 400 | Bad Request - Validation Error |
| 404 | Not Found - Invalid Route |
| 429 | Too Many Requests - Rate Limit |
| 500 | Internal Server Error |

---

## Validation Rules Summary

### fibonacci
- Type: Positive Integer
- Range: 1 to 100
- Returns: Array of numbers

### prime
- Type: Array of Positive Integers
- Min Length: 1
- Returns: Array of prime numbers

### lcm
- Type: Array of Positive Integers
- Min Length: 2
- Returns: Single number (LCM)

### hcf
- Type: Array of Positive Integers
- Min Length: 2
- Returns: Single number (HCF/GCD)

### AI
- Type: Non-empty String
- Max Length: 500 characters
- Returns: Single word string

---

## Testing with cURL (if available)

### Health Check
```bash
curl -X GET http://localhost:3000/health
```

### Fibonacci
```bash
curl -X POST http://localhost:3000/bfhl \
  -H "Content-Type: application/json" \
  -d '{"fibonacci": 10}'
```

### Prime
```bash
curl -X POST http://localhost:3000/bfhl \
  -H "Content-Type: application/json" \
  -d '{"prime": [1,2,3,4,5,6,7,8,9,10]}'
```

### LCM
```bash
curl -X POST http://localhost:3000/bfhl \
  -H "Content-Type: application/json" \
  -d '{"lcm": [12,18,24]}'
```

### HCF
```bash
curl -X POST http://localhost:3000/bfhl \
  -H "Content-Type: application/json" \
  -d '{"hcf": [12,18,24]}'
```

### AI
```bash
curl -X POST http://localhost:3000/bfhl \
  -H "Content-Type: application/json" \
  -d '{"AI": "What is your name?"}'
```

---

## Advanced Testing Scenarios

### Test Case 1: Large Fibonacci
```json
{
  "fibonacci": 50
}
```

### Test Case 2: Large Prime Array
```json
{
  "prime": [97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111]
}
```
Expected: [97, 101, 103, 107, 109]

### Test Case 3: Three Number LCM
```json
{
  "lcm": [4, 6, 8]
}
```
Expected: 24

### Test Case 4: Complex HCF
```json
{
  "hcf": [48, 72, 96, 120]
}
```
Expected: 24

### Test Case 5: AI Questions
```json
{"AI": "Is the weather good?"}
```
Possible responses: "Yes", "Sunny", "Good"

```json
{"AI": "Hello, how are you?"}
```
Possible responses: "Hello", "Good"

---

## Rate Limiting

- **Window:** 15 minutes (900,000 ms)
- **Max Requests:** 100 per IP
- **Headers:**
  - `RateLimit-Limit`: Maximum requests allowed
  - `RateLimit-Remaining`: Requests remaining
  - `RateLimit-Reset`: Time when limit resets

---

## Security Features

1. **Helmet.js** - Security headers
2. **CORS** - Cross-origin protection
3. **Rate Limiting** - DDoS prevention
4. **Input Validation** - Injection prevention
5. **Error Sanitization** - Information leakage prevention
6. **Request Size Limit** - 10MB max
7. **JSON Parsing** - Malformed request protection

---

## Production Deployment

### Using Node.js
```bash
NODE_ENV=production PORT=3000 node server.js
```

### Using PM2
```bash
pm2 start ecosystem.config.js --env production
```

### Using Docker
```bash
docker build -t bfhl-api .
docker run -p 3000:3000 -e NODE_ENV=production bfhl-api
```

### Using Docker Compose
```bash
docker-compose up -d
```

---

## Environment Variables

Create a `.env` file:
```env
NODE_ENV=production
PORT=3000
OFFICIAL_EMAIL=ridhi0946.be23@chitkara.edu.in
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
LOG_LEVEL=info
```

---

## Troubleshooting

### Server won't start
- Check if port 3000 is available
- Verify Node.js version (>= 18.0.0)
- Run `npm install` to ensure dependencies are installed

### Connection refused
- Ensure server is running
- Check firewall settings
- Verify correct port in requests

### Rate limit errors
- Wait 15 minutes
- Use different IP address
- Increase `RATE_LIMIT_MAX_REQUESTS` in .env

---

## Support

**Developer:** ridhi0946.be23@chitkara.edu.in  
**API Version:** 1.0.0  
**Last Updated:** February 10, 2026
