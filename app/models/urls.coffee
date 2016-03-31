mongoose = require "mongoose"
Schema = mongoose.Schema

Url = new Schema
  num : Number
  url : String
  
module.exports = mongoose.model "Url", Url