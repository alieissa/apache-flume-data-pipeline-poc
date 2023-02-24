/** @format */
import request from 'supertest'
import app from '../src/app'

describe('Retrieve S3 Object', () => {
  test('Should receive object created event and retrieve it from S3', async () => {
    await request(app).post('/s3-object').send({ foo: 'bar' }).expect(200)
  })
})
