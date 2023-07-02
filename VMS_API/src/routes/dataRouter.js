const express = require('express');
const {
  getVisitedPeople,
  getVisitedLocations,
  getCloserPeople,
} = require('../controllers/dataController');

const checkDateValid = require('../middleware/checkDateValid');

const router = express.Router();

router.get('/people', checkDateValid, getVisitedPeople);
router.get('/locations', checkDateValid, getVisitedLocations);
router.get('/closecontacts', checkDateValid, getCloserPeople);

module.exports = router;
