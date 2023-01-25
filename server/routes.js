/** @format */

const express = require('express')
const router = express.Router()

router.post('/s3-object', function (req, res, next) {
  res.sendStatus(201)
})

module.exports = router
