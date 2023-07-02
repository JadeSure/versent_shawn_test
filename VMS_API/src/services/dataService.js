const { normalizeDate } = require('../utils/dateConvert');
const { dbInit } = require('../model/db');

// Initialize data from the database
const jsonData = dbInit();

// Checks if a person is valid
const validPerson = (person) => {
  for (const item of jsonData) {
    for (const personData of item.persons) {
      if (personData.person === person) {
        return true;
      }
    }
  }

  return false;
};

// Checks if a location is valid
const validLocation = (location) => {
  for (const item of jsonData) {
    if (item.location === location) {
      return true;
    }
  }

  return false;
};

// Finds people who visited a specific location on a given date
const findPeople = (location, date) => {
  const formattedDate = normalizeDate(date);
  const personsVisited = jsonData
    .filter((item) => item.location === location)
    .flatMap((item) => item.persons)
    .filter((person) => person.dates.includes(formattedDate))
    .map((person) => person.person);

  return personsVisited;
};

// Finds locations visited by a specific person on a given date
const findLocations = (person, date) => {
  const formattedDate = normalizeDate(date);
  let locationsVisited = [];

  for (const item of jsonData) {
    for (const personData of item.persons) {
      if (
        personData.person === person &&
        personData.dates.includes(formattedDate)
      ) {
        locationsVisited.push(item.location);
      }
    }
  }

  return locationsVisited;
};

// Finds people who had close contact with a specific person on a given date
const findCloserPeople = (person, date) => {
  const closeContactPeple = new Set();
  const locations = findLocations(person, date);

  for (const location of locations) {
    const people = findPeople(location, date);

    people.forEach((person) => {
      closeContactPeple.add(person);
    });
  }

  closeContactPeple.delete(person);
  return [...closeContactPeple];
};

module.exports = {
  findPeople,
  findLocations,
  findCloserPeople,
  validPerson,
  validLocation,
};
