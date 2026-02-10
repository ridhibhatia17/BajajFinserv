/**
 * BFHL Controller
 * Handles POST /bfhl endpoint logic
 */

const logger = require('../utils/logger');
const { createSuccessResponse, createErrorResponse } = require('../utils/helpers');
const computationService = require('../services/computation.service');
const aiService = require('../services/ai.service');

/**
 * Handle POST /bfhl request
 */
const handleBfhlRequest = async (req, res) => {
  try {
    const body = req.body;
    const key = Object.keys(body)[0];
    const value = body[key];

    logger.info(`Processing BFHL request with key: ${key}`);

    let result;

    switch (key) {
      case 'fibonacci':
        result = computationService.generateFibonacci(value);
        logger.info(`Fibonacci generated for n=${value}: ${result.length} terms`);
        break;

      case 'prime':
        result = computationService.filterPrimes(value);
        logger.info(`Prime numbers filtered: ${result.length} primes found`);
        break;

      case 'lcm':
        result = computationService.calculateLCM(value);
        logger.info(`LCM calculated for ${value}: ${result}`);
        break;

      case 'hcf':
        result = computationService.calculateHCF(value);
        logger.info(`HCF calculated for ${value}: ${result}`);
        break;

      case 'AI':
        result = await aiService.generateAIResponse(value);
        logger.info(`AI response generated for question: "${value}" => "${result}"`);
        break;

      default:
        // This should never happen due to validation middleware
        logger.error(`Unexpected key: ${key}`);
        return res.status(400).json(createErrorResponse('Invalid request'));
    }

    // Return success response
    return res.status(200).json(createSuccessResponse(result));

  } catch (error) {
    logger.error('Error in BFHL controller:', error);
    return res.status(500).json(createErrorResponse(error.message || 'Internal server error'));
  }
};

module.exports = {
  handleBfhlRequest
};
