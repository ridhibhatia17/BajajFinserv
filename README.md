# BFHL REST API

A production-ready REST API service that provides mathematical computations and AI-powered question answering capabilities.

## Overview

This Node.js Express API serves mathematical operations including Fibonacci sequence generation, prime number filtering, LCM/HCF calculations, and AI-powered responses using Google Gemini AI with intelligent fallback mechanisms.

## Features

- **Mathematical Operations**: Fibonacci, Prime Numbers, LCM, HCF calculations
- **AI Integration**: Google Gemini AI with comprehensive fallback system
- **Production Security**: Rate limiting, input validation, security headers
- **Error Handling**: Comprehensive error management and logging
- **High Performance**: Optimized algorithms with overflow protection
- **Docker Ready**: Containerized deployment support

## API Endpoints

### Health Check
```
GET /health
```
Returns service health status and configuration information.

**Response:**
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in"
}
```

### BFHL Operations
```
POST /bfhl
```
Performs various mathematical and AI operations based on the request body.

**Request Format:**
- Content-Type: `application/json`
- Body must contain exactly one operation key

#### Fibonacci Sequence
Generate Fibonacci sequence of n terms.

**Request:**
```json
{
  "fibonacci": 7
}
```

**Response:**
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "data": [0, 1, 1, 2, 3, 5, 8]
}
```

#### Prime Number Filtering
Filter prime numbers from an array.

**Request:**
```json
{
  "prime": [2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
}
```

**Response:**
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "data": [2, 3, 5, 7, 11]
}
```

#### LCM Calculation
Calculate Least Common Multiple of numbers.

**Request:**
```json
{
  "lcm": [4, 6, 8]
}
```

**Response:**
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "data": 24
}
```

#### HCF Calculation
Calculate Highest Common Factor of numbers.

**Request:**
```json
{
  "hcf": [12, 18, 24]
}
```

**Response:**
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "data": 6
}
```

#### AI Question Answering
Get AI-powered responses to questions.

**Request:**
```json
{
  "AI": "what is 5+3?"
}
```

**Response:**
```json
{
  "is_success": true,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "data": "Eight"
}
```

## Installation

### Prerequisites
- Node.js 18.x or higher
- npm 9.x or higher

### Local Development

1. Clone the repository:
```bash
git clone <repository-url>
cd bajaj-finserv
```

2. Install dependencies:
```bash
npm install
```

3. Configure environment variables:
```bash
cp .env.example .env
```

Edit `.env` file with your configuration:
```env
NODE_ENV=development
PORT=3000
OFFICIAL_EMAIL=your-email@domain.com
GOOGLE_GEMINI_API_KEY=your-api-key
```

4. Start the development server:
```bash
npm run dev
```

### Production Deployment

1. Set production environment:
```bash
export NODE_ENV=production
```

2. Start the production server:
```bash
npm start
```

### Docker Deployment

1. Build the Docker image:
```bash
docker build -t bfhl-api .
```

2. Run the container:
```bash
docker run -p 3000:3000 --env-file .env bfhl-api
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `NODE_ENV` | Environment mode | `development` |
| `PORT` | Server port | `3000` |
| `OFFICIAL_EMAIL` | Contact email | Required |
| `GOOGLE_GEMINI_API_KEY` | Google AI API key | Optional |

### Security Features

- **Rate Limiting**: 100 requests per 15 minutes per IP
- **Input Validation**: Strict JSON schema validation
- **Security Headers**: Comprehensive HTTP security headers
- **Request Size Limits**: Maximum 100KB payload size
- **Content-Type Validation**: Enforced JSON content type
- **Parameter Pollution Prevention**: HPP protection enabled
- **CORS Protection**: Configurable origin restrictions

## API Validation Rules

The API enforces strict validation rules:

1. **Content-Type Required**: Must be `application/json`
2. **Single Operation**: Request must contain exactly one operation key
3. **Valid Input Types**: 
   - Numbers must be finite integers
   - Arrays must contain valid elements
   - Positive numbers required for LCM/HCF
4. **Size Limits**: Maximum 2 numbers for LCM/HCF calculations
5. **Range Limits**: Fibonacci limited to reasonable sequence lengths

## Error Responses

All errors follow a consistent format:

```json
{
  "is_success": false,
  "official_email": "ridhi0946.be23@chitkara.edu.in",
  "error": "Error description"
}
```

### Common Error Codes

- **400**: Invalid request format or validation failure
- **415**: Unsupported content type
- **429**: Rate limit exceeded
- **500**: Internal server error

## Testing

### Manual Testing

Use curl or any HTTP client:

```bash
# Health check
curl -X GET http://localhost:3000/health

# Fibonacci
curl -X POST http://localhost:3000/bfhl \
  -H "Content-Type: application/json" \
  -d '{"fibonacci": 5}'

# Prime filtering
curl -X POST http://localhost:3000/bfhl \
  -H "Content-Type: application/json" \
  -d '{"prime": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]}'
```

### PowerShell Testing

```powershell
# Health check
$health = Invoke-WebRequest -Uri "http://localhost:3000/health" -UseBasicParsing
