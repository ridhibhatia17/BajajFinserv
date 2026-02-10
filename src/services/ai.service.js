const { GoogleGenerativeAI } = require('@google/generative-ai');
const logger = require('../utils/logger');
const { sanitizeAIInput } = require('../middleware/productionSecurity');

// Initialize Gemini AI with API key from environment variable
// NEVER hardcode the API key
let genAI = null;
let model = null;

try {
  const apiKey = process.env.GOOGLE_GEMINI_API_KEY;
  
  if (!apiKey || apiKey === 'your_google_gemini_api_key_here') {
    logger.warn('Google Gemini API key not configured. AI service will use fallback responses.');
  } else {
    genAI = new GoogleGenerativeAI(apiKey);
    model = genAI.getGenerativeModel({ model: 'gemini-pro' });
    logger.info('Google Gemini AI initialized successfully');
  }
} catch (error) {
  logger.error('Failed to initialize Google Gemini AI:', error);
  logger.warn('AI service will use fallback responses');
}

const trimToSingleWord = (response) => {
  if (!response || typeof response !== 'string') {
    return 'Unknown';
  }

  // Remove punctuation and extra whitespace
  const cleaned = response.trim()
    .replace(/[.,!?;:'"()\[\]{}]/g, '')
    .replace(/\s+/g, ' ');

  // Get first word
  const words = cleaned.split(' ').filter(word => word.length > 0);
  
  if (words.length === 0) {
    return 'Unknown';
  }

  // Return first word, capitalized
  const firstWord = words[0];
  return firstWord.charAt(0).toUpperCase() + firstWord.slice(1).toLowerCase();
};

const generateFallbackResponse = (question) => {
  const lowerQuestion = question.toLowerCase().trim();

  const responses = {
    'hello': 'Hello',
    'hi': 'Hi',
    'hey': 'Hey',
    'how': 'Good',
    'name': 'BFHL',
    'who': 'BFHL',
    'time': 'Now',
    'when': 'Soon',
    'where': 'Here',
    'weather': 'Sunny',
    'thanks': 'Welcome',
    'thank': 'Welcome',
    'bye': 'Goodbye',
    'help': 'Available',
    'yes': 'Affirmative',
    'no': 'Negative'
  };

  // Check for keyword matches
  for (const [keyword, response] of Object.entries(responses)) {
    if (lowerQuestion.includes(keyword)) {
      return response;
    }
  }

  // Check for yes/no questions
  if (lowerQuestion.includes('?')) {
    if (lowerQuestion.startsWith('is ') || 
        lowerQuestion.startsWith('are ') || 
        lowerQuestion.startsWith('can ')) {
      return 'Yes';
    }
    return 'Perhaps';
  }

  return 'Understood';
};

const generateAIResponse = async (question) => {
  try {
    // Validate input
    if (!question || typeof question !== 'string') {
      logger.warn('Invalid question input for AI service');
      return 'Unknown';
    }

    // Sanitize input to prevent injection attacks
    const sanitizedQuestion = sanitizeAIInput(question);
    
    if (sanitizedQuestion.length === 0) {
      logger.warn('Empty question after sanitization');
      return 'Unknown';
    }

    logger.info(`Original input length: ${question.length}, Sanitized length: ${sanitizedQuestion.length}`);

    // Create prompt that encourages single-word response
    const prompt = `Answer this question with ONLY ONE WORD. Be concise and direct. Question: ${sanitizedQuestion}`;

    logger.info(`Calling Google Gemini API for question: "${sanitizedQuestion}"`);

    // Call Gemini API with timeout protection
    const timeoutPromise = new Promise((_, reject) => {
      setTimeout(() => reject(new Error('Gemini API timeout')), 5000); // 5 second timeout
    });

    const generationPromise = model.generateContent(prompt);

    // Race between API call and timeout
    const result = await Promise.race([generationPromise, timeoutPromise]);

    // Extract response text
    const response = result.response;
    const text = response.text();

    logger.info(`Gemini API raw response: "${text}"`);

    // Trim to single word
    const singleWord = trimToSingleWord(text);

    logger.info(`Trimmed AI response: "${singleWord}"`);

    return singleWord;

  } catch (error) {
    // Handle all failures safely - server must not crash
    logger.error('Error calling Google Gemini API:', {
      error: error.message,
      stack: error.stack
    });

    // Use fallback response on any error
    logger.info('Using fallback response due to API error');
    
    // Sanitize question for fallback as well
    const sanitizedForFallback = sanitizeAIInput(question);
    return generateFallbackResponse(sanitizedForFallback || question);
  }
};

module.exports = {
  generateAIResponse
};
