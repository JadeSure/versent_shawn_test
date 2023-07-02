const winston = require('winston');
const config = require('../config/index');

const logger = winston.createLogger({
  level: config.NODE_ENV === 'dev' ? 'debug' : 'info',
  format: winston.format.combine(
    winston.format.colorize(),
    winston.format.timestamp({ format: 'HH:mm:ss' }),
    winston.format.printf(
      (info) => `${info.timestamp} [${info.level}] ${info.message}`
    )
  ),

  transports: [new winston.transports.Console()],
});

module.exports = logger;
