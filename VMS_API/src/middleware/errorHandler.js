module.exports = (err, req, res, next) => {
  console.log(err);
  res.status(400).json({ error: err.message });
};
