const { valiDate } = require('../utils/dateConvert');

// date middle ware validate date param query
module.exports = (req, res, next) => {
  const { date } = req.query;
  if (!date) {
    return res.status(400).json({ error: 'The query date param is missing' });
  }

  if (!valiDate(date)) {
    return res
      .status(400)
      .json({ error: 'the input date format is not valid' });
  }

  return next();
};
