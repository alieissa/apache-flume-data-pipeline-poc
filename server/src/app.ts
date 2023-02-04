/** @format */

import express from 'express'
import getObjectFromS3 from './get-object-from-s3'
import indexRouter from './routes'

const app = express()
app.use(express.json())
app.use('/', indexRouter)
app.use(getObjectFromS3)
export default app
