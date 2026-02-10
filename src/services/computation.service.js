const logger = require('../utils/logger');

const generateFibonacci = (n) => {
  try {
    // Strict validation
    if (!Number.isFinite(n) || !Number.isInteger(n) || n <= 0) {
      throw new Error('Invalid input for fibonacci generation');
    }

    // Handle edge cases
    if (n === 1) {
      return [0];
    }
    
    if (n === 2) {
      return [0, 1];
    }

    // Initialize with first two terms
    const fibonacci = [0, 1];
    
    // Generate remaining terms
    for (let i = 2; i < n; i++) {
      const nextValue = fibonacci[i - 1] + fibonacci[i - 2];
      
      // Safety check for overflow
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
  // Numbers <= 1 are not prime
  if (num <= 1) return false;
  
  // 2 and 3 are prime
  if (num === 2 || num === 3) return true;
  
  // Eliminate multiples of 2 and 3
  if (num % 2 === 0 || num % 3 === 0) return false;

  // Check for divisibility using 6k±1 pattern
  // All primes > 3 are of the form 6k±1
  for (let i = 5; i * i <= num; i += 6) {
    if (num % i === 0 || num % (i + 2) === 0) {
      return false;
    }
  }

  return true;
};

const filterPrimes = (numbers) => {
  try {
    // Validate input is array
    if (!Array.isArray(numbers)) {
      throw new Error('Input must be an array');
    }
    
    // Filter primes with validation
    const primes = [];
    
    for (let i = 0; i < numbers.length; i++) {
      const num = numbers[i];
      
      // Validate each element is a valid integer
      if (!Number.isFinite(num) || !Number.isInteger(num)) {
        throw new Error('Array must contain only integers');
      }
      
      // Use efficient prime check and add if prime
      if (isPrime(num)) {
        primes.push(num);
      }
      // Non-prime values are silently ignored
    }
    
    return primes;
  } catch (error) {
    logger.error('Error filtering primes:', error);
    throw new Error('Failed to filter prime numbers');
  }
};

const gcd = (a, b) => {
  // Euclidean algorithm
  while (b !== 0) {
    const temp = b;
    b = a % b;
    a = temp;
  }
  return a;
};

const calculateHCF = (numbers) => {
  try {
    // Validate input is array
    if (!Array.isArray(numbers)) {
      throw new Error('Input must be an array');
    }
    
    // Require at least 2 numbers
    if (numbers.length < 2) {
      throw new Error('At least 2 numbers required for HCF calculation');
    }

    // Validate all numbers are positive integers
    for (let i = 0; i < numbers.length; i++) {
      const num = numbers[i];
      if (!Number.isFinite(num) || !Number.isInteger(num) || num <= 0) {
        throw new Error('All numbers must be positive integers');
      }
    }

    // Calculate HCF by applying GCD iteratively
    let result = numbers[0];
    
    for (let i = 1; i < numbers.length; i++) {
      result = gcd(result, numbers[i]);
      
      // Safety check
      if (!Number.isFinite(result)) {
        throw new Error('HCF calculation overflow');
      }
      
      // Optimization: if HCF becomes 1, it won't change
      if (result === 1) {
        break;
      }
    }

    return result;
  } catch (error) {
    logger.error('Error calculating HCF:', error);
    throw new Error('Failed to calculate HCF');
  }
};

const lcm = (a, b) => {
  // Use formula: LCM = (a / GCD) * b to minimize overflow risk
  // Dividing first reduces the size before multiplication
  return (a / gcd(a, b)) * b;
};

const calculateLCM = (numbers) => {
  try {
    // Validate input is array
    if (!Array.isArray(numbers)) {
      throw new Error('Input must be an array');
    }
    
    // Require at least 2 numbers
    if (numbers.length < 2) {
      throw new Error('At least 2 numbers required for LCM calculation');
    }

    // Validate all numbers are positive integers
    for (let i = 0; i < numbers.length; i++) {
      const num = numbers[i];
      if (!Number.isFinite(num) || !Number.isInteger(num) || num <= 0) {
        throw new Error('All numbers must be positive integers');
      }
    }

    // Calculate LCM by applying formula iteratively
    let result = numbers[0];
    
    for (let i = 1; i < numbers.length; i++) {
      result = lcm(result, numbers[i]);
      
      // Check for overflow
      if (!Number.isFinite(result)) {
        throw new Error('LCM calculation overflow');
      }
      
      // Prevent extremely large unsafe numbers
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
