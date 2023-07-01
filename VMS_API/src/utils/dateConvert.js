const normalizeDate = (dateString) => {
  const [year, month, day] = dateString.split(/[-/]/);
  const formattedDate = `${year}-${month.padStart(2, '0')}-${day.padStart(
    2,
    '0'
  )}T00:00:00.000Z`;

  return formattedDate;
};

module.exports = {
  normalizeDate,
};
