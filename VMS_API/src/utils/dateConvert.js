// normalize date
const normalizeDate = (dateString) => {
  if (dateString.includes('T')) {
    return dateString;
  }
  const [year, month, day] = dateString.split(/[-/]/);
  const formattedDate = `${year}-${month.padStart(2, '0')}-${day.padStart(
    2,
    '0'
  )}T00:00:00.000Z`;

  return formattedDate;
};

const valiDate = (dateString) => {
  if (!isCompleteDate(dateString)) {
    return false;
  }

  const date = new Date(dateString);
  // Check if the date is valid by testing if it is NaN
  if (isNaN(date)) {
    return false;
  }

  return true;
};

// check date format
const isCompleteDate = (dateString) => {
  const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
  return dateRegex.test(dateString);
};

module.exports = {
  normalizeDate,
  valiDate,
};
