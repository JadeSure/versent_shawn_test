const express = require('express');
const morgan = require('morgan');

const errorHandler = require('./middleware/errorHandler');
const cors = require('./middleware/cors');
const routers = require('./routes/dataRouter');
const config = require('./config/index');
const logger = require('./utils/logger');
const swaggerDoc = require('./utils/swagger');
const swaggerUI = require('swagger-ui-express');

const app = express();

// const connectionDB = require('./utils/dbConnection');
// mongodb+srv://shawn:<password>@cluster0.vd94k.mongodb.net/

// for console logger
app.use(morgan(config.Node_ENV === 'dev' ? 'dev' : 'common'));
app.use(express.json());
app.use(cors);
// docs
app.use('/api-docs', swaggerUI.serve, swaggerUI.setup(swaggerDoc));

// add router(a kind of middleware)
app.use(config.api.prefix, routers);

// health check for alb health validation
app.get('/health_check', (req, res) => {
  res.status(200).json({ status: 'active' });
});

// last middleware as error handling
app.use(errorHandler);

app.listen(config.port, () => {
  logger.info(`server running in ${config.port}`);
});
