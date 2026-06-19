const express = require('express');
const { getPipelines, createPipelineEntry, updatePipelineStatus, deletePipelineEntry } = require('../controllers/pipelineController');
const { protect } = require('../middleware/auth');

const router = express.Router();

router.use(protect);

router.route('/')
    .get(getPipelines)
    .post(createPipelineEntry);

router.route('/:id')
    .put(updatePipelineStatus)
    .delete(deletePipelineEntry);

module.exports = router;
