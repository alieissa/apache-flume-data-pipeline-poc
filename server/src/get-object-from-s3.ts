/** @format */
import { GetObjectCommand, S3Client } from '@aws-sdk/client-s3'
import dotenv from 'dotenv'
import express from 'express'
dotenv.config()

const router = express.Router()

const client = new S3Client({
  region: process.env.S3_REGION,
  credentials: {
    accessKeyId: process.env.S3_ACCESS_KEY,
    secretAccessKey: process.env.S3_SECRET_KEY,
  },
})

/**
 * We really don't care about the data here.
 * This is the last stop and we are sure that
 * our uploaded had hit every point
 */
const getObjectFromS3 = (req, res) => {
  client.send(new GetObjectCommand(req.body))
  console.log('Attempted to retrieve', JSON.stringify(req.body))
  res.sendStatus(200)
}
router.post('/s3-object', getObjectFromS3)
export default router
