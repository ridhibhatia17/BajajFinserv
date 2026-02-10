const logger = require('../utils/logger');
const { createErrorResponse } = require('../utils/helpers');
const config = require('../config/config');

class AppError extends Error {
  constructor(message, statusCode = 500, isOperational = true) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = isOperational;
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }
}

const getStatusCode = (err) => {
  // Explicit status code
  if (err.statusCode) return err.statusCode;
  
  // Error type mapping
  const errorTypeMap = {
    'ValidationError': 400,
    'CastError': 400,
    'SyntaxError': 400,
    'JsonWebTokenError': 401,
    'UnauthorizedError': 401,
    'TokenExpiredError': 401,
    'ForbiddenError': 403,
    'NotFoundError': 404,
    'MethodNotAllowedError': 405,
    'ConflictError': 409,
    'PayloadTooLargeError': 413,
    'UnsupportedMediaTypeError': 415,
    'RateLimitError': 429
  };
  
  // Check by error name
  if (errorTypeMap[err.name]) {
    return errorTypeMap[err.name];
  }
  
  // Check by error type
  if (err.type === 'entity.parse.failed') return 400;
  if (err.type === 'entity.too.large') return 413;
  if (err.type === 'charset.unsupported') return 415;
  
  // Check by error code
  if (err.code === 'EBADCSRFTOKEN') return 403;
  if (err.code === 'ETIMEDOUT') return 504;
  
  // Default to 500 for unknown errors
  return 500;
};

const getErrorMessage = (err, statusCode) => {
  // Use custom message if available
  if (err.message && err.isOperational) {
    return err.message;
  }
  
  // In production, hide internal error details
  if (config.env === 'production' && statusCode === 500) {
    return 'Internal server error';
  }
  
  // In development, show actual error
  return err.message || 'An unexpected error occurred';
};

const logError = (err, req) => {
  const errorDetails = {
    timestamp: new Date().toISOString(),
    message: err.message,
    name: err.name,
    statusCode: err.statusCode || 500,
    isOperational: err.isOperational || false,
    request: {
      method: req.method,
      url: req.originalUrl || req.url,
      path: req.path,
      headers: {
        'content-type': req.get('content-type'),
        'user-agent': req.get('user-agent'),
        'origin': req.get('origin')
      },
      ip: req.ip || req.connection.remoteAddress,
      body: req.method !== 'GET' ? maskSensitiveData(req.body) : undefined
    }
  };
  
  // Add stack trace for non-operational errors or in development
  if (!err.isOperational || config.env === 'development') {
    errorDetails.stack = err.stack;
  }
  
  // Log based on severity
  const statusCode = getStatusCode(err);
  if (statusCode >= 500) {
    logger.error('Server Error:', errorDetails);
  } else if (statusCode >= 400) {
    logger.warn('Client Error:', errorDetails);
  } else {
    logger.info('Error:', errorDetails);
  }
};

const maskSensitiveData = (data) => {
  if (!data || typeof data !== 'object') return data;
  
  const sensitiveFields = ['password', 'token', 'apiKey', 'secret', 'credit_card'];
  const masked = { ...data };
  
  sensitiveFields.forEach(field => {
    if (masked[field]) {
      masked[field] = '***MASKED***';
    }
  });
  
  return masked;
};

const notFoundHandler = (req, res) => {
  logger.warn(`404 Not Found: ${req.method} ${req.path}`);
  res.status(404).json(createErrorResponse('Route not found'));
};

const errorHandler = (err, req, res, next) => {
  // Log the error with full context
  logError(err, req);
  
  // Determine appropriate status code
  const statusCode = getStatusCode(err);
  
  // Determine error message
  const errorMessage = getErrorMessage(err, statusCode);
  
  // Create structured error response
  const errorResponse = createErrorResponse(errorMessage);
  
  // Add additional details in development mode
  if (config.env === 'development') {
    errorResponse.error_details = {
      message: err.message,
      name: err.name,
      statusCode: statusCode,
      stack: err.stack,
      ...(err.errors && { validation_errors: err.errors })
    };
  }
  
  // Don't send response if headers already sent
  if (res.headersSent) {
    logger.error('Headers already sent, delegating to default error handler');
    return next(err);
  }
  
  // Send error response
  res.status(statusCode).json(errorResponse);
};

const asyncHandler = (fn) => {
  return (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

const handleUnhandledRejection = () => {
  process.on('unhandledRejection', (reason, promise) => {
    logger.error('Unhandled Promise Rejection:', {
      reason: reason,
      promise: promise
    });
    // Don't exit in production, just log
    if (config.env !== 'production') {
      throw reason;
    }
  });
};

const handleUncaughtException = () => {
  process.on('uncaughtException', (error) => {
    logger.error('Uncaught Exception:', {
      message: error.message,
      stack: error.stack
    });
    // Exit process for uncaught exceptions
    process.exit(1);
  });
};

module.exports = {
  AppError,
  notFoundHandler,
  errorHandler,
  asyncHandler,
  handleUnhandledRejection,
  handleUncaughtException
};
