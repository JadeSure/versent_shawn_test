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

  const parts = dateString.split(/[\/T-]/);

  const month = parseInt(parts[1], 10);
  const day = parseInt(parts[2], 10);

  if (month < 1 || month > 12 || day < 1 || day > 31) {
    return false;
  }

  return true;
};

// check date format
const isCompleteDate = (dateString) => {
  const dateRegex =
    /^(\d{4})(\/|-)(\d{2})\2(\d{2})(T\d{2}:\d{2}:\d{2}\.\d{3}Z)?$/;
  return dateRegex.test(dateString);
};

module.exports = {
  normalizeDate,
  valiDate,
};
