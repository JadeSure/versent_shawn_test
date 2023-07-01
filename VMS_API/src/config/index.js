const dotenv = require('dotenv');
dotenv.config();
const Node_ENV = process.env.NODE_ENV || 'dev';

module.exports = {
  port: process.env.PORT || 8080,
  api: {
    prefix: process.env.API_PREFIX || '/v1',
  },
};
