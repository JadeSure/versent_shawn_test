const swaggerJsdoc = require('swagger-jsdoc');

module.exports = swaggerJsdoc({
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'VMS Technical Challenge - Shawn',
      version: '1.0.0',
      contact: {
        name: 'Shawn',
        email: 'tremendous.shawn.wang@outlook.com',
      },
    },
  },
  apis: ['./src/controllers/*.js'],
});
