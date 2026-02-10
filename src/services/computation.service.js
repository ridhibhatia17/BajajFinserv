const logger = require('../utils/logger');

const generateFibonacci = (n) => {
  try {
    if (!Number.isFinite(n) || !Number.isInteger(n) || n <= 0) {
      throw new Error('Invalid input for fibonacci generation');
    }

    if (n === 1) return [0];
    if (n === 2) return [0, 1];

    const fibonacci = [0, 1];
    
    for (let i = 2; i < n; i++) {
      const nextValue = fibonacci[i - 1] + fibonacci[i - 2];
      
      if (!Number.isFinite(nextValue) || nextValue > Number.MAX_SAFE_INTEGER) {
        throw new Error('Fibonacci value overflow - number too large to represent safely');
      }
      
      fibonacci[i] = nextValue;
    }

    return fibonacci;
  } catch (error) {
    logger.error('Error generating fibonacci:', error);
    throw new Error('Failed to generate fibonacci series');
  }
};

const isPrime = (num) => {
  if (num <= 1) return false;
  if (num === 2 || num === 3) return true;
  if (num % 2 === 0 || num % 3 === 0) return false;

  for (let i = 5; i * i <= num; i += 6) {
    if (num % i === 0 || num % (i + 2) === 0) {
      return false;
    }
  }

  return true;
};

const filterPrimes = (numbers) => {
  try {
    if (!Array.isArray(numbers)) {
      throw new Error('Input must be an array');
    }
    
    const primes = [];
    
    for (let i = 0; i < numbers.length; i++) {
      const num = numbers[i];
      
      if (!Number.isFinite(num) || !Number.isInteger(num)) {
        throw new Error('Array must contain only integers');
      }
      
      if (isPrime(num)) {
        primes.push(num);
      }
    }
    
    return primes;
  } catch (error) {
    logger.error('Error filtering primes:', error);
    throw new Error('Failed to filter prime numbers');
  }
};

const gcd = (a, b) => {
  while (b !== 0) {
    const temp = b;
    b = a % b;
    a = temp;
  }
  return a;
};

const calculateHCF = (numbers) => {
  try {
    if (!Array.isArray(numbers)) {
      throw new Error('Input must be an array');
    }
    
    if (numbers.length < 2) {
      throw new Error('At least 2 numbers required for HCF calculation');
    }

    for (let i = 0; i < numbers.length; i++) {
      const num = numbers[i];
      if (!Number.isFinite(num) || !Number.isInteger(num) || num <= 0) {
        throw new Error('All numbers must be positive integers');
      }
    }

    let result = numbers[0];
    
    for (let i = 1; i < numbers.length; i++) {
      result = gcd(result, numbers[i]);
      
      if (!Number.isFinite(result)) {
        throw new Error('HCF calculation overflow');
      }
      
      if (result === 1) break;
    }

    return result;
  } catch (error) {
    logger.error('Error calculating HCF:', error);
    throw new Error('Failed to calculate HCF');
  }
};

const lcm = (a, b) => {
  return (a / gcd(a, b)) * b;
};

const calculateLCM = (numbers) => {
  try {
    if (!Array.isArray(numbers)) {
      throw new Error('Input must be an array');
    }
    
    if (numbers.length < 2) {
      throw new Error('At least 2 numbers required for LCM calculation');
    }

    for (let i = 0; i < numbers.length; i++) {
      const num = numbers[i];
      if (!Number.isFinite(num) || !Number.isInteger(num) || num <= 0) {
        throw new Error('All numbers must be positive integers');
      }
    }

    let result = numbers[0];
    
    for (let i = 1; i < numbers.length; i++) {
      result = lcm(result, numbers[i]);
      
      if (!Number.isFinite(result)) {
        throw new Error('LCM calculation overflow');
      }
      
      if (result > Number.MAX_SAFE_INTEGER) {
        throw new Error('LCM value too large');
      }
    }

    return result;
  } catch (error) {
    logger.error('Error calculating LCM:', error);
    throw new Error('Failed to calculate LCM');
  }
};

module.exports = {
  generateFibonacci,
  isPrime,
  filterPrimes,
  calculateHCF,
  calculateLCM
};
