const express = require('express');
const routers = require('./routes/dataRouter');
const errorHandler = require('./middleware/errorHandler');
const config = require('./config/index');
const app = express();

// const connectionDB = require('./utils/dbConnection');

// mongodb+srv://shawn:<password>@cluster0.vd94k.mongodb.net/

app.use(express.json());

app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header(
    'Access-Control-Allow-Headers',
    'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  );

  if (req.method == 'OPTIONS') {
    res.header('Access-Control-Allow-Methods', 'PUT, POST, PATCH, DELETE, GET');
    return res.status(200).json({});
  }

  next();
});

app.use(config.api.prefix, routers);

app.get('/health_check', (req, res) => {
  res.status(200).json({ status: 'active' });
});

app.use(errorHandler);

app.listen(config.port, () => {
  console.log(`server running in ${config.port}`);
});
