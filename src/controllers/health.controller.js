/**
 * Health Controller
 * Handles GET /health endpoint
 */

const logger = require('../utils/logger');
const { createHealthResponse } = require('../utils/helpers');

/**
 * Handle GET /health request
 */
const handleHealthCheck = (req, res) => {
  try {
    logger.info('Health check requested');
    return res.status(200).json(createHealthResponse());
  } catch (error) {
    logger.error('Error in health check:', error);
    return res.status(500).json(createHealthResponse());
  }
};

module.exports = {
  handleHealthCheck
};
