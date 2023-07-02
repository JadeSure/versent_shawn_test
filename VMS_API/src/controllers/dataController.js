const {
  findPeople,
  findLocations,
  findCloserPeople,
  validPerson,
  validLocation,
} = require('../services/dataService');

const getVisitedPeople = (req, res) => {
  const { location, date } = req.query;
  if (!location || !date) {
    return res
      .status(400)
      .json({ error: 'Please query the correct info to retrieve' });
  }

  if (!validLocation(location)) {
    return res.status(404).json({ error: 'No results for this location' });
  }

  const personsVisited = findPeople(location, date);
  return res.status(200).json({ personsVisited });
};

const getVisitedLocations = (req, res) => {
  const { person, date } = req.query;

  if (!person || !date) {
    return res
      .status(400)
      .json({ error: 'Please query the correct info to retrieve' });
  }

  if (!validPerson(person)) {
    return res.status(404).json({ error: 'No results for this person' });
  }

  const locationsVisited = findLocations(person, date);
  return res.status(200).json({ locationsVisited });
};

const getCloserPeople = (req, res) => {
  let { person, date } = req.query;

  if (!person || !date) {
    return res
      .status(400)
      .json({ error: 'Please query the correct info to retrieve' });
  }

  if (!validPerson(person)) {
    return res.status(404).json({ error: 'No results for this person' });
  }

  const closeContactPeple = findCloserPeople(person, date);
  return res.status(200).json({ closeContactPeple });
};

module.exports = {
  getVisitedPeople,
  getVisitedLocations,
  getCloserPeople,
};
