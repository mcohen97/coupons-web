const axios = require('axios').default;
const config = require('config');
const express = require('express')
const httpProxy = require('express-http-proxy')
const app = express()

const monolithicAppService = httpProxy('http://localhost:3000')


function getAction(method, url){
  return 'CREATE_PROMOTION'
}

function validateAuth(req, res, next){
  if (!req.headers.authorization) {
    return res.status(401).json({ error: 'Invalid credential' });
  }

  axios.post('http://localhost:4000/validate_auth', {
    token: req.headers.authorization,
    action: getAction(req.method, req.get('host'))
  })
  .then(function (response) {
    console.log('sent');
    next()
  })
  .catch(function (error) {
    res.send(error.message);
  });
}


// Authentication
app.use((req, res, next) => {
  /*if(req.url != '/users/sign_in'){
    validateAuth(req, res, next)
  }else{*/
    next()
  //}
})


// Proxy request
app.get("/promotions/:id", (req, res, next) => {
  monolithicAppService(req, res, next)
})

app.get("/users/sign_in", (req, res, next) => {
  monolithicAppService(req, res, next)
})

app.post("/users/sign_in", (req, res, next) => {
  monolithicAppService(req, res, next)
})

app.post("/promotions/evaluate", (req, res, next) => {
  console.log('Redireccionar a evaluate')
  monolithicAppService(req, res, next)
})

/*app.get("/users/sign_in", (req, res, next) => {
  monolithicAppService(req, res, next)
})

app.get("/users/sign_up", (req, res, next) => {
  monolithicAppService(req, res, next)
})
app.get("/users/cancel", (req, res, next) => {
  monolithicAppService(req, res, next)
})
app.get("/users/edit", (req, res, next) => {
  monolithicAppService(req, res, next)
})

app.post("/users/sign_in", (req, res, next) => {
  monolithicAppService(req, res, next)
})

app.delete("/users/sign_out", (req, res, next) => {
  monolithicAppService(req, res, next)
})

app.get("/home/index", (req, res, next) => {
  monolithicAppService(req, res, next)
})

app.get("/home/invitation", (req, res, next) => {
  monolithicAppService(req, res, next)
})

app.post("/home/invite", (req, res, next) => {
  monolithicAppService(req, res, next)
})*/

app.listen(5000, function () {
  console.log('Example app listening on port 5000!');
});
