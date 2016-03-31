Urls = require "../models/urls.js"

urlReg = /^(https?:\/\/)([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/
urlBeheadedReg = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/
path = process.cwd();

urlHandlerF = ->
  set : (req, res) ->
    
    url = req.params[0]
    
    resObj =
      longUrl : url
      
    unless urlReg.test url
      if urlBeheadedReg.test url
        resObj.err = "url must begin with http:// or https://"
      else
        resObj.err = "not a valid url"
      res.send JSON.stringify resObj
    else
      Urls.findOne
        url : url
      .exec (err, urlObj) =>
        if err then throw err
        if urlObj?
          resObj.shortUrl = "#{process.env.APP_URL}#{urlObj.num}"
          res.send JSON.stringify resObj
        else
          Urls.find {}
          .sort
            num : -1
          .limit 1
          .exec (err, high) =>
            if err then throw err
            num = (high?[0]?.num or 0) + 1
            urlObj = new Urls
              num : num
              url : url
            urlObj.save (err, urlObj) ->
              if err then throw err
              resObj.shortUrl = "#{process.env.APP_URL}#{urlObj.num}"
              res.send JSON.stringify resObj
    
  get : (req, res) ->
    num = req.params.num
    if isNaN Number num
      res.send "parameter must be a number"
    else
      Urls.findOne
        num : num
      .exec (err, urlObj) ->
        if err then throw err
        if urlObj?.url?
          res.send "<META HTTP-EQUIV='Refresh' CONTENT='5; URL=#{urlObj.url}'>"
        else
          res.send "not found"
module.exports = urlHandlerF