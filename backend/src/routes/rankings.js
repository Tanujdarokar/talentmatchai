const express = require('express');
const { getRankings, getRanking, triggerRanking, deleteRanking } = require('../controllers/rankingController');
const { protect } = require('../middleware/auth');

const router = express.Router();

router.use(protect);

router.route('/')
    .get(getRankings)
    .post(triggerRanking); // Changed from createRanking to triggerRanking

router.route('/:id')
    .get(getRanking)
    .delete(deleteRanking);

module.exports = router;
