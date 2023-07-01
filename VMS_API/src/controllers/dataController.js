const {
  findPeople,
  findLocations,
  findCloserPeople,
} = require('../services/dataService');

const getVisitedPeople = (req, res) => {
  const { location, date } = req.query;
  const personsVisited = findPeople(location, date);
  res.status(200).json({ personsVisited });
};

const getVisitedLocations = (req, res) => {
  const { person, date } = req.query;

  const locationsVisited = findLocations(person, date);
  res.status(200).json({ locationsVisited });
};

const getCloserPeople = (req, res) => {
  let { person, date } = req.query;
  const closeContactPeple = findCloserPeople(person, date);
  res.status(200).json({ closeContactPeple });
};

module.exports = {
  getVisitedPeople,
  getVisitedLocations,
  getCloserPeople,
};
