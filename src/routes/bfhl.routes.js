const express = require('express');
const { handleBfhlRequest } = require('../controllers/bfhl.controller');
const { validateBfhlRequest } = require('../middleware/validation');

const router = express.Router();

router.post('/bfhl', validateBfhlRequest, handleBfhlRequest);

module.exports = router;
