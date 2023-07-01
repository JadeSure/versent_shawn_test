const fs = require('fs');

const dbInit = () => {
  let jsonData;
  try {
    const data = fs.readFileSync('./src/model/data.json', 'utf8');
    jsonData = JSON.parse(data);
  } catch (err) {
    console.error('Error reading or parsing file:', err);
  }

  return jsonData;
};

module.exports = {
  dbInit,
};
