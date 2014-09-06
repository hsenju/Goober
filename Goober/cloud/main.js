
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
var express = require('express');
var app = express();

// App configuration section
app.set('views', 'cloud/views');  // Folder containing view templates
app.set('view engine', 'ejs');    // Template engine
app.use(express.bodyParser());    // Read the request body into a JS object
 
app.get('*', function(req, res) { res.redirect(301, 'http://customname.com'); });