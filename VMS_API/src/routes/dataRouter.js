const express = require('express');
const {
  getVisitedPeople,
  getVisitedLocations,
  getCloserPeople,
} = require('../controllers/dataController');

const router = express.Router();

router.get('/people', getVisitedPeople);
router.get('/locations', getVisitedLocations);
router.get('/closecontacts', getCloserPeople);

module.exports = router;
