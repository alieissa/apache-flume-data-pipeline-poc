/** @format */

import express from 'express'
import getObjectFromS3RouteHandler from './get-object-from-s3'

const app = express()

app.use(express.json())
app.use('/', getObjectFromS3RouteHandler)
export default app
