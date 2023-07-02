const { valiDate } = require('../utils/dateConvert');

module.exports = (req, res, next) => {
  const { date } = req.query;
  if (!valiDate(date)) {
    return res
      .status(400)
      .json({ error: 'the input date format is not valid' });
  }

  return next();
};
