const {
  findPeople,
  findLocations,
  findCloserPeople,
  validPerson,
  validLocation,
} = require('../services/dataService');

/**
 * @swagger
 * /v1/people:
 *   get:
 *     summary: Get visited people
 *     tags: [TASK]
 *     description: Retrieve a list of people who visited a specific location on a given date.
 *     parameters:
 *       - in: query
 *         name: location
 *         required: true
 *         description: The location to query.
 *         schema:
 *           type: string
 *       - in: query
 *         name: date
 *         required: true
 *         description: The date to query. eg.YYYY/MM/DD or YYYY-MM-DD or YYYY-MM-DDT00:00:00.000Z
 *         schema:
 *           type: string
 *     responses:
 *       '200':
 *         description: Successful operation. Returns a list of visited people.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 personsVisited:
 *                   type: array
 *                   items:
 *                     type: string
 *       '400':
 *         description: Bad request. The location is missing in the query.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *       '404':
 *         description: Not found. No results found for the given location.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 */
const getVisitedPeople = (req, res) => {
  const { location, date } = req.query;
  if (!location) {
    return res
      .status(400)
      .json({ error: 'The query location param is missing' });
  }

  if (!validLocation(location)) {
    return res.status(404).json({ error: 'No results for this location' });
  }

  const personsVisited = findPeople(location, date);
  return res.status(200).json({ personsVisited });
};

/**
 *@swagger
 * /v1/locations:
 *   get:
 *     summary: Get visited locations
 *     tags: [TASK]
 *     description: Retrieve a list of locations visited by a specific person on a given date.
 *     parameters:
 *       - in: query
 *         name: person
 *         required: true
 *         description: The person to query.
 *         schema:
 *           type: string
 *       - in: query
 *         name: date
 *         required: true
 *         description: The date to query.
 *         schema:
 *           type: string
 *     responses:
 *       '200':
 *         description: Successful operation. Returns a list of visited locations.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 locationsVisited:
 *                   type: array
 *                   items:
 *                     type: string
 *       '400':
 *         description: Bad request. The person is missing in the query.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *       '404':
 *         description: Not found. No results found for the given person.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 */
const getVisitedLocations = (req, res) => {
  const { person, date } = req.query;

  if (!person) {
    return res.status(400).json({ error: 'The query person param is missing' });
  }

  if (!validPerson(person)) {
    return res.status(404).json({ error: 'No results for this person' });
  }

  const locationsVisited = findLocations(person, date);
  return res.status(200).json({ locationsVisited });
};

/**
 * @swagger
 * /v1/closecontacts:
 *   get:
 *     summary: Get closer people
 *     tags: [TASK]
 *     description: Retrieve a list of people who had close contact with a specific person on a given date.
 *     parameters:
 *       - in: query
 *         name: person
 *         required: true
 *         description: The person to query.
 *         schema:
 *           type: string
 *       - in: query
 *         name: date
 *         required: true
 *         description: The date to query.
 *         schema:
 *           type: string
 *     responses:
 *       '200':
 *         description: Successful operation. Returns a list of closer people.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 closeContactPeople:
 *                   type: array
 *                   items:
 *                     type: string
 *       '400':
 *         description: Bad request. The person is missing in the query.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *       '404':
 *         description: Not found. No results found for the given person.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 */
const getCloserPeople = (req, res) => {
  let { person, date } = req.query;

  if (!person) {
    return res.status(400).json({ error: 'The query person param is missing' });
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
