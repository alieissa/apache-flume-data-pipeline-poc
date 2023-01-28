/** @format */
import { GetObjectCommand, S3Client } from '@aws-sdk/client-s3'
import dotenv from 'dotenv'

dotenv.config()

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
  const command = new GetObjectCommand(req.body)
  client
    .send(command)
    .then((response) => {
      console.log(response)
    })
    .catch((error) => {
      console.log(error)
    })

  res.sendStatus(200)
}

export default getObjectFromS3
