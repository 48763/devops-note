'use strict'
const express = require('express');
const fs = require('fs');

const app = express();
const port = 80;
const mes = ""

// Runs before each requests
// app.use((req, res, next) => {
//   res.locals.startEpoch = Date.now();
//   next();
// })

app.get('/', (req, res, next) => {
  setTimeout(() => {
    res.json({ message: 'Hello World!' });
    next();
  }, Math.round(Math.random() * 200));
});

app.get('/favicon.ico', (req, res) => {
    res.status(204).send();
});

// - - - 
var list = []
app.get('/file:path(/*)/$', (req, res, next) => {

  if (fs.statSync(req.params.path).isDirectory()) {
    fs.readdirSync(req.params.path).forEach(file => {
      if (fs.statSync(req.params.path+'/'+file).isDirectory())
        list.push(file +'/')
      else 
        list.push(file)
    })
    next()
  } else next(err)
  
}, (req, res, next) => {
    res.json({ isDirectory : true , files: list});
})

app.get('/file:path(/*)', (req, res, next) => {

  if (fs.statSync(req.params.path).isFile()) next()
  else next(err)
}, (req, res, next) => {
    res.send(Buffer.from('true'))
})

app.delete('/file:path(/*)', (req, res, next) => {
  if (fs.statSync(req.params.path).isFile()) next()
  else next(err)
}, (req, res, next) => {
    fs.unlinkSync(req.params.path)
    res.send(Buffer.from('Delete'))
})

app.use(express.raw())
app.post('/file:path(/*/):filename(*)', (req, res, next) => {
  if (!fs.existsSync(req.params.path)) next(err)
  else if((fs.existsSync(req.params.path + req.params.filename))) next(err)
  else next()
}, (req, res, next) => {
    const writeStream = fs.createWriteStream(req.params.path + req.params.filename);
    req.pipe(writeStream);
    res.send(Buffer.from('Upload'))
})

app.patch('/file:path(/*/):filename(*)', (req, res, next) => {
  if (fs.statSync(req.params.path + req.params.filename).isFile()) next()
  else next(err)
}, (req, res, next) => {
    const writeStream = fs.createWriteStream(req.params.path + req.params.filename);
    req.pipe(writeStream);
    res.send(Buffer.from('Update'))
})

app.use(function (req, res, next) {
  next(createError());
});

app.use(function (err, req, res, next) {
  res.status(err.status || 404);
  res.end('404 not found!');
});

const server = app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
})

// Graceful shutdown
process.on('SIGTERM', () => {
  clearInterval(metricsInterval);

  server.close((err) => {
    if (err) {
      console.error(err);
      process.exit(1);
    }

    process.exit(0);
  })
})
