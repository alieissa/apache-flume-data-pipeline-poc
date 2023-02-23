/** @format */

const http = require('http')

const options = {
  // Static private IP of EC2
  hostname: '10.0.0.5',
  port: 3000,
  path: '/s3-object',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
}

exports.handler = function (obj) {
  const objData = {
    Bucket: obj.Records[0].s3.bucket.name,
    Key: obj.Records[0].s3.object.key,
  }

  http
    .request(options)
    .on('error', function (e) {
      console.log('Problem with request:', e.message)
    })
    .write(JSON.stringify(objData))
    .end()
}
