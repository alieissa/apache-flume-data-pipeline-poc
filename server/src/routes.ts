/** @format */

// const express = require('express')
import express from 'express'
const getObjectKey = (req, res, next) => {
  // TODO Get key from body and add to req and call next()
  console.log('get object key', req.body)
  req.getS3ObjectKey = () => {}
  res.sendStatus(201)
}

const router = express.Router()
// TODO Put object reception and parsing in a middleware
// and object download in another middleware. Cleaner
router.post('/s3-object', getObjectKey)

export default router
