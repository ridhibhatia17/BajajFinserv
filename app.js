const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const hpp = require('hpp');
const compression = require('compression');
const morgan = require('morgan');
const config = require('./src/config/config');
const logger = require('./src/utils/logger');
const { rateLimiter } = require('./src/middleware/security');
const { errorHandler, notFoundHandler } = require('./src/middleware/errorHandler');
const {
  validateContentType,
  validateBodyExists,
  preventPrototypePollution,
  logRequestSize,
  additionalSecurityHeaders
} = require('./src/middleware/productionSecurity');
const routes = require('./src/routes');

const app = express();

// Security middleware
app.use(helmet());
app.use(cors({
  origin: config.env === 'production' ? config.allowedOrigins : '*',
  credentials: true
}));

// Additional security headers
app.use(additionalSecurityHeaders);

// Prevent HTTP Parameter Pollution
app.use(hpp());

// Rate limiting
app.use(rateLimiter);

// Log request size for monitoring
app.use(logRequestSize);

// Validate Content-Type header
app.use(validateContentType);

// Body parsing middleware with strict size limits
app.use(express.json({ 
  limit: '100kb', // Strict limit to prevent large payload attacks
  strict: true,
  type: 'application/json'
}));
app.use(express.urlencoded({ extended: true, limit: '100kb' }));

// Handle JSON parsing errors
app.use((err, req, res, next) => {
  if (err instanceof SyntaxError && err.status === 400 && 'body' in err) {
    logger.error('JSON parsing error:', err.message);
    return res.status(400).json({
      is_success: false,
      official_email: config.officialEmail,
      error: 'Invalid JSON format'
    });
  }
  
  // Handle payload too large errors
  if (err.type === 'entity.too.large') {
    logger.error('Payload too large:', err.message);
    return res.status(413).json({
      is_success: false,
      official_email: config.officialEmail,
      error: 'Request payload too large (max 100KB)'
    });
  }
  
  next(err);
});

// Validate body exists (prevent empty body attacks)
app.use(validateBodyExists);

// Prevent prototype pollution
app.use(preventPrototypePollution);

// Compression middleware
app.use(compression());

// Logging middleware
if (config.env === 'development') {
  app.use(morgan('dev'));
} else {
  app.use(morgan('combined', {
    stream: {
      write: (message) => logger.info(message.trim())
    }
  }));
}

// API routes
app.use('/', routes);

// 404 handler
app.use(notFoundHandler);

// Global error handler
app.use(errorHandler);

module.exports = app;
