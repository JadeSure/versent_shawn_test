// for finding correct date
const normalizeDate = (dateString) => {
  const [year, month, day] = dateString.split(/[-/]/);
  const formattedDate = `${year}-${month.padStart(2, '0')}-${day.padStart(
    2,
    '0'
  )}T00:00:00.000Z`;

  return formattedDate;
};

const valiDate = (dateString) => {
  const date = new Date(dateString);
  // Check if the date is valid by testing if it is NaN
  if (isNaN(date.getTime())) {
    return false;
  }

  return true;
};

module.exports = {
  normalizeDate,
  valiDate,
};
