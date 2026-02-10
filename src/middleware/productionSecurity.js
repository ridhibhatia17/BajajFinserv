const logger = require('../utils/logger');
const validator = require('validator');
const config = require('../config/config');

const validateContentType = (req, res, next) => {
  // Skip for GET requests and health checks
  if (req.method === 'GET' || req.path === '/health') {
    return next();
  }

  const contentType = req.get('Content-Type');
  
  if (!contentType) {
    logger.warn('Content-Type header missing - returning 415');
    return res.status(415).json({
      is_success: false,
      official_email: config.officialEmail,
      error: 'Content-Type header is required'
    });
  }

  if (!contentType.includes('application/json')) {
    logger.warn(`Invalid Content-Type: ${contentType} - returning 415`);
    return res.status(415).json({
      is_success: false,
      official_email: config.officialEmail,
      error: 'Content-Type must be application/json'
    });
  }

  next();
};

const validateBodyExists = (req, res, next) => {
  // Skip for GET requests and health checks
  if (req.method === 'GET' || req.path === '/health') {
    return next();
  }

  // Check if body exists
  if (!req.body) {
    logger.warn('Request body is missing');
    return res.status(400).json({
      is_success: false,
      official_email: config.officialEmail,
      error: 'Request body is required'
    });
  }

  // Check if body is empty object
  if (typeof req.body === 'object' && Object.keys(req.body).length === 0) {
    logger.warn('Request body is empty');
    return res.status(400).json({
      is_success: false,
      official_email: config.officialEmail,
      error: 'Request body cannot be empty'
    });
  }

  next();
};

const preventPrototypePollution = (req, res, next) => {
  const dangerousKeys = [
    '__proto__',
    'constructor',
    'prototype'
  ];

  // Function to recursively check object for dangerous keys
  const hasDangerousKey = (obj, path = '') => {
    if (!obj || typeof obj !== 'object') {
      return false;
    }

    for (const key of Object.keys(obj)) {
      const currentPath = path ? `${path}.${key}` : key;

      // Check if key is dangerous
      if (dangerousKeys.includes(key.toLowerCase())) {
        logger.error(`Prototype pollution attempt detected: ${currentPath}`);
        return true;
      }

      // Recursively check nested objects and arrays
      if (typeof obj[key] === 'object' && obj[key] !== null) {
        if (hasDangerousKey(obj[key], currentPath)) {
          return true;
        }
      }
    }

    return false;
  };

  // Check body for dangerous keys
  if (req.body && hasDangerousKey(req.body)) {
    return res.status(400).json({
      is_success: false,
      official_email: config.officialEmail,
      error: 'Invalid property names detected'
    });
  }

  // Check query params
  if (req.query && hasDangerousKey(req.query)) {
    return res.status(400).json({
      is_success: false,
      official_email: config.officialEmail,
      error: 'Invalid query parameters detected'
    });
  }

  next();
};

const sanitizeAIInput = (input) => {
  if (!input || typeof input !== 'string') {
    return '';
  }

  // Remove null bytes
  let sanitized = input.replace(/\0/g, '');

  // Trim whitespace
  sanitized = sanitized.trim();

  // Limit length to prevent resource exhaustion
  const MAX_INPUT_LENGTH = 1000;
  if (sanitized.length > MAX_INPUT_LENGTH) {
    logger.warn(`AI input truncated from ${sanitized.length} to ${MAX_INPUT_LENGTH} characters`);
    sanitized = sanitized.substring(0, MAX_INPUT_LENGTH);
  }

  // Escape HTML to prevent XSS (in case response is used in web context)
  sanitized = validator.escape(sanitized);

  // Remove control characters (except newlines and tabs)
  sanitized = sanitized.replace(/[\x00-\x08\x0B-\x0C\x0E-\x1F\x7F]/g, '');

  // Remove multiple consecutive spaces
  sanitized = sanitized.replace(/\s+/g, ' ');

  // Final trim
  sanitized = sanitized.trim();

  return sanitized;
};

const logRequestSize = (req, res, next) => {
  const contentLength = req.get('Content-Length');
  
  if (contentLength) {
    const sizeInKB = parseInt(contentLength) / 1024;
    
    if (sizeInKB > 50) {
      logger.warn(`Large request received: ${sizeInKB.toFixed(2)} KB from ${req.ip}`);
    }
  }

  next();
};

const additionalSecurityHeaders = (req, res, next) => {
  // Prevent MIME type sniffing
  res.setHeader('X-Content-Type-Options', 'nosniff');
  
  // Prevent clickjacking
  res.setHeader('X-Frame-Options', 'DENY');
  
  // XSS protection
  res.setHeader('X-XSS-Protection', '1; mode=block');
  
  // Referrer policy
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
  
  // Permissions policy
  res.setHeader('Permissions-Policy', 'geolocation=(), microphone=(), camera=()');

  next();
};

module.exports = {
  validateContentType,
  validateBodyExists,
  preventPrototypePollution,
  sanitizeAIInput,
  logRequestSize,
  additionalSecurityHeaders
};
