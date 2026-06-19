const express = require('express');
const { exportRankingsCsv, exportCandidatesCsv, exportRankingsJson } = require('../controllers/reportController');
const { protect } = require('../middleware/auth');

const router = express.Router();

router.use(protect);

router.get('/rankings/csv', exportRankingsCsv);
router.get('/rankings/json', exportRankingsJson);
router.get('/candidates/csv', exportCandidatesCsv);

module.exports = router;
