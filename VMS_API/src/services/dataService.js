const { normalizeDate } = require('../utils/dateConvert');
const { dbInit } = require('../model/db');

// Initialize data from the database
const jsonData = dbInit();

// Checks if a person is exist in db
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

// Checks if a location is exist in db
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
    // Extract the persons array from each item (flat array without location and people)
    .flatMap((item) => item.persons)
    // Filter the persons who visited on the specified date
    .filter((person) => person.dates.includes(formattedDate))
    // Extract the name of each person
    .map((person) => person.person);

  return personsVisited;
};

// Finds locations visited by a specific person on a given date
const findLocations = (person, date) => {
  const formattedDate = normalizeDate(date);
  let locationsVisited = [];

  for (const item of jsonData) {
    for (const personData of item.persons) {
      // Check if the person and date match the person and date
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

  // Retrieve the locations visited by the specific person on the given date
  const locations = findLocations(person, date);

  for (const location of locations) {
    // Retrieve the people who visited the same location on the same date
    const people = findPeople(location, date);

    people.forEach((person) => {
      closeContactPeple.add(person);
    });
  }

  // Remove the original person from the closeContactPeople Set
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
