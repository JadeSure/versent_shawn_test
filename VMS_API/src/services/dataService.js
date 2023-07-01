const { normalizeDate } = require('../utils/dateConvert');
const { dbInit } = require('../model/db');

const jsonData = dbInit();

const findPeople = (location, date) => {
  const formattedDate = normalizeDate(date);
  const personsVisited = jsonData
    .filter((item) => item.location === location)
    .flatMap((item) => item.persons)
    .filter((person) => person.dates.includes(formattedDate))
    .map((person) => person.person);

  return personsVisited;
};

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
};
