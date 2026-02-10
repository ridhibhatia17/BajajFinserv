const config = require('../config/config');

const createSuccessResponse = (data) => {
  return {
    is_success: true,
    official_email: config.officialEmail,
    data: data
  };
};

const createErrorResponse = (error) => {
  return {
    is_success: false,
    official_email: config.officialEmail,
    error: error
  };
};

const createHealthResponse = () => {
  return {
    is_success: true,
    official_email: config.officialEmail
  };
};

const isPositiveInteger = (value) => {
  return Number.isInteger(value) && value > 0;
};

const isPositiveIntegerArray = (value) => {
  return Array.isArray(value) && 
         value.length > 0 && 
         value.every(item => Number.isInteger(item) && item > 0);
};

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
