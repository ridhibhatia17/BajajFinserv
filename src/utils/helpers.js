/**
 * Helper Utilities
 * Common utility functions
 */

const config = require('../config/config');

/**
 * Create standardized success response
 */
const createSuccessResponse = (data) => {
  return {
    is_success: true,
    official_email: config.officialEmail,
    data: data
  };
};

/**
 * Create standardized error response
 */
const createErrorResponse = (error) => {
  return {
    is_success: false,
    official_email: config.officialEmail,
    error: error
  };
};

/**
 * Create health check response
 */
const createHealthResponse = () => {
  return {
    is_success: true,
    official_email: config.officialEmail
  };
};

/**
 * Validate if value is a positive integer
 */
const isPositiveInteger = (value) => {
  return Number.isInteger(value) && value > 0;
};

/**
 * Validate if value is an array of positive integers
 */
const isPositiveIntegerArray = (value) => {
  return Array.isArray(value) && 
         value.length > 0 && 
         value.every(item => Number.isInteger(item) && item > 0);
};

/**
 * Validate if value is a non-empty string
 */
const isNonEmptyString = (value) => {
  return typeof value === 'string' && value.trim().length > 0;
};

module.exports = {
  createSuccessResponse,
  createErrorResponse,
  createHealthResponse,
  isPositiveInteger,
  isPositiveIntegerArray,
  isNonEmptyString
};
