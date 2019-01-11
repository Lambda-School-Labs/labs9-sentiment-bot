const express = require('express')

const router = express()

// 'sanity' endpoint
router.get('/', (req, res) => {
  res.status(200).json({
    message: 'api up!'
  })
})

router.use('/users', require('./dataRoutes/usersRoutes'))

module.exports = router;