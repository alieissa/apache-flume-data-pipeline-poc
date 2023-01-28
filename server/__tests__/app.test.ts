/** @format */
import request from 'supertest'
import app from '../src/app'
import getObjectFromS3 from '../src/get-object-from-s3'

jest.mock('../src/get-object-from-s3', () => {
  return jest.fn().mockImplementation(() => {
    return { getObjectFromS3: jest.fn() }
  })
})

describe('Retrieve S3 Object', () => {
  test('Should receive object created event and retrieve it from S3', async () => {
    await request(app).post('/s3-object').send({ foo: 'bar' })
    expect(getObjectFromS3).toBeCalled()
  })
})
