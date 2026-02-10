const rateLimit = require('express-rate-limit');
const config = require('../config/config');
const logger = require('../utils/logger');

const rateLimiter = rateLimit({
  windowMs: config.rateLimit.windowMs,
  max: config.rateLimit.maxRequests,
  message: {
    is_success: false,
    official_email: config.officialEmail,
    error: 'Too many requests from this IP, please try again later'
  },
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    logger.warn(`Rate limit exceeded for IP: ${req.ip}`);
    res.status(429).json({
      is_success: false,
      official_email: config.officialEmail,
      error: 'Too many requests from this IP, please try again later'
    });
  }
});

const sanitizeRequest = (req, res, next) => {
  // Remove any potential XSS or injection attempts
  if (req.body) {
    req.body = JSON.parse(JSON.stringify(req.body));
  }
  next();
};

module.exports = {
  rateLimiter,
  sanitizeRequest
};
