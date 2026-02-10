const { createErrorResponse } = require('../utils/helpers');
const logger = require('../utils/logger');

const validateBfhlRequest = (req, res, next) => {
  try {
    const body = req.body;

    // Check if body exists and is an object
    if (!body || typeof body !== 'object' || Array.isArray(body)) {
      logger.warn('Validation failed: Invalid request body type');
      return res.status(400).json(createErrorResponse('Request body must be a valid JSON object'));
    }

    // Get all keys from body
    const bodyKeys = Object.keys(body);

    // Check if body is empty (no keys)
    if (bodyKeys.length === 0) {
      logger.warn('Validation failed: Empty request body');
      return res.status(400).json(createErrorResponse('Request body must contain exactly one key from: fibonacci, prime, lcm, hcf, AI'));
    }

    // Check for exactly one key
    if (bodyKeys.length > 1) {
      logger.warn(`Validation failed: Multiple keys provided (${bodyKeys.length}): ${bodyKeys.join(', ')}`);
      return res.status(400).json(
        createErrorResponse('Request must contain exactly one key from: fibonacci, prime, lcm, hcf, AI')
      );
    }

    // Define valid keys
    const validKeys = ['fibonacci', 'prime', 'lcm', 'hcf', 'AI'];
    const key = bodyKeys[0];

    // Check if key is valid
    if (!validKeys.includes(key)) {
      logger.warn(`Validation failed: Invalid key '${key}'`);
      return res.status(400).json(
        createErrorResponse(`Invalid key '${key}'. Must be one of: fibonacci, prime, lcm, hcf, AI`)
      );
    }

    const value = body[key];

    // Check for null or undefined values
    if (value === null || value === undefined) {
      logger.warn(`Validation failed: ${key} value is null or undefined`);
      return res.status(400).json(
        createErrorResponse(`${key} value cannot be null or undefined`)
      );
    }

    // Validate based on key type
    switch (key) {
      case 'fibonacci':
        // Must be a positive integer
        if (typeof value !== 'number') {
          logger.warn(`Validation failed: fibonacci must be a number, got ${typeof value}`);
          return res.status(400).json(
            createErrorResponse('fibonacci value must be a positive integer')
          );
        }
        if (!Number.isFinite(value)) {
          logger.warn(`Validation failed: fibonacci must be finite, got ${value}`);
          return res.status(400).json(
            createErrorResponse('fibonacci value must be a finite number')
          );
        }
        if (!Number.isInteger(value)) {
          logger.warn(`Validation failed: fibonacci must be an integer, got ${value}`);
          return res.status(400).json(
            createErrorResponse('fibonacci value must be a positive integer')
          );
        }
        if (value <= 0) {
          logger.warn(`Validation failed: fibonacci must be positive, got ${value}`);
          return res.status(400).json(
            createErrorResponse('fibonacci value must be a positive integer')
          );
        }
        if (value > 100) {
          logger.warn(`Validation failed: fibonacci value too large: ${value}`);
          return res.status(400).json(
            createErrorResponse('fibonacci value must be less than or equal to 100')
          );
        }
        break;

      case 'prime':
        // Must be an array of positive integers
        if (!Array.isArray(value)) {
          logger.warn(`Validation failed: prime must be an array, got ${typeof value}`);
          return res.status(400).json(
            createErrorResponse('prime value must be a non-empty array of positive integers')
          );
        }
        if (value.length === 0) {
          logger.warn('Validation failed: prime array is empty');
          return res.status(400).json(
            createErrorResponse('prime value must be a non-empty array of positive integers')
          );
        }
        // Check each element
        for (let i = 0; i < value.length; i++) {
          const item = value[i];
          if (typeof item !== 'number') {
            logger.warn(`Validation failed: prime array element at index ${i} is not a number`);
            return res.status(400).json(
              createErrorResponse('prime array must contain only positive integers')
            );
          }
          if (!Number.isFinite(item)) {
            logger.warn(`Validation failed: prime array element at index ${i} is not finite`);
            return res.status(400).json(
              createErrorResponse('prime array must contain only finite numbers')
            );
          }
          if (!Number.isInteger(item)) {
            logger.warn(`Validation failed: prime array element at index ${i} is not an integer`);
            return res.status(400).json(
              createErrorResponse('prime array must contain only positive integers')
            );
          }
          if (item <= 0) {
            logger.warn(`Validation failed: prime array element at index ${i} is not positive`);
            return res.status(400).json(
              createErrorResponse('prime array must contain only positive integers')
            );
          }
        }
        break;

      case 'lcm':
        // Must be an array of positive integers with at least 2 elements
        if (!Array.isArray(value)) {
          logger.warn(`Validation failed: lcm must be an array, got ${typeof value}`);
          return res.status(400).json(
            createErrorResponse('lcm value must be an array of at least 2 positive integers')
          );
        }
        if (value.length === 0) {
          logger.warn('Validation failed: lcm array is empty');
          return res.status(400).json(
            createErrorResponse('lcm value must be an array of at least 2 positive integers')
          );
        }
        if (value.length < 2) {
          logger.warn(`Validation failed: lcm array has only ${value.length} element(s)`);
          return res.status(400).json(
            createErrorResponse('lcm value must be an array of at least 2 positive integers')
          );
        }
        // Check each element
        for (let i = 0; i < value.length; i++) {
          const item = value[i];
          if (typeof item !== 'number') {
            logger.warn(`Validation failed: lcm array element at index ${i} is not a number`);
            return res.status(400).json(
              createErrorResponse('lcm array must contain only positive integers')
            );
          }
          if (!Number.isFinite(item)) {
            logger.warn(`Validation failed: lcm array element at index ${i} is not finite`);
            return res.status(400).json(
              createErrorResponse('lcm array must contain only finite numbers')
            );
          }
          if (!Number.isInteger(item)) {
            logger.warn(`Validation failed: lcm array element at index ${i} is not an integer`);
            return res.status(400).json(
              createErrorResponse('lcm array must contain only positive integers')
            );
          }
          if (item <= 0) {
            logger.warn(`Validation failed: lcm array element at index ${i} is not positive`);
            return res.status(400).json(
              createErrorResponse('lcm array must contain only positive integers')
            );
          }
        }
        break;

      case 'hcf':
        // Must be an array of positive integers with at least 2 elements
        if (!Array.isArray(value)) {
          logger.warn(`Validation failed: hcf must be an array, got ${typeof value}`);
          return res.status(400).json(
            createErrorResponse('hcf value must be an array of at least 2 positive integers')
          );
        }
        if (value.length === 0) {
          logger.warn('Validation failed: hcf array is empty');
          return res.status(400).json(
            createErrorResponse('hcf value must be an array of at least 2 positive integers')
          );
        }
        if (value.length < 2) {
          logger.warn(`Validation failed: hcf array has only ${value.length} element(s)`);
          return res.status(400).json(
            createErrorResponse('hcf value must be an array of at least 2 positive integers')
          );
        }
        // Check each element
        for (let i = 0; i < value.length; i++) {
          const item = value[i];
          if (typeof item !== 'number') {
            logger.warn(`Validation failed: hcf array element at index ${i} is not a number`);
            return res.status(400).json(
              createErrorResponse('hcf array must contain only positive integers')
            );
          }
          if (!Number.isFinite(item)) {
            logger.warn(`Validation failed: hcf array element at index ${i} is not finite`);
            return res.status(400).json(
              createErrorResponse('hcf array must contain only finite numbers')
            );
          }
          if (!Number.isInteger(item)) {
            logger.warn(`Validation failed: hcf array element at index ${i} is not an integer`);
            return res.status(400).json(
              createErrorResponse('hcf array must contain only positive integers')
            );
          }
          if (item <= 0) {
            logger.warn(`Validation failed: hcf array element at index ${i} is not positive`);
            return res.status(400).json(
              createErrorResponse('hcf array must contain only positive integers')
            );
          }
        }
        break;

      case 'AI':
        // Must be a non-empty string
        if (typeof value !== 'string') {
          logger.warn(`Validation failed: AI must be a string, got ${typeof value}`);
          return res.status(400).json(
            createErrorResponse('AI value must be a non-empty string')
          );
        }
        if (value.trim().length === 0) {
          logger.warn('Validation failed: AI value is empty');
          return res.status(400).json(
            createErrorResponse('AI value must be a non-empty string')
          );
        }
        // Check for reasonable length (before sanitization)
        if (value.length > 1000) {
          logger.warn(`Validation failed: AI value too long (${value.length} characters)`);
          return res.status(400).json(
            createErrorResponse('AI value is too long (max 1000 characters)')
          );
        }
        // Check for null bytes (security check)
        if (value.includes('\0')) {
          logger.warn('Validation failed: AI value contains null bytes');
          return res.status(400).json(
            createErrorResponse('AI value contains invalid characters')
          );
        }
        break;
    }

    // Validation passed
    next();
  } catch (error) {
    logger.error('Validation error:', error);
    return res.status(400).json(createErrorResponse('Invalid request format'));
  }
};

module.exports = {
  validateBfhlRequest
};
