before 'protect from forgery', ->
    protectFromForgery '8f4ae982f956d510a39869a2c7c50afb40991f5a'

nodemailer = require 'nodemailer'
_ = require 'underscore'
jade = require 'jade'
fs = require 'fs'
util = require 'util'

nodemailer.SMTP = 
  host: 'exchange.seagamfg.com',
  port: 25 
  use_authentication: true
  user: 'seagamfg\\seaga'
  pass: 'Seaga*7&'

mail_data = 
    sender: 'seaga@seagamfg.com'

before 'Load Campaign', ->
  if req.body.cid
    Campaign.find req.body.cid, (err, campaign) =>
        if err
          res.json error: 'We are sorry but the mailing service is unavailable at this time.  This incident has been reported!'
        else
          @campaign = campaign
          next()
  else
    @deprecated = true
    next()
, only: ['generateLead']

action 'generateLead', () ->
  
  if @deprecated != true
    
    @locals= req.body
    mail_data.subject='Campaign lead | '+@campaign.title
    mail_data.to=@campaign.salesEmail
    mail_data.cc=['bclos@seagamfg.com', 'aolson@seagamfg.com']

    jadeFile = fs.readFileSync __dirname+'/../views/mailer/campaignLead.jade'
    jadeTemplate = jade.compile jadeFile.toString 'utf8', 0, jadeFile.length
    compiledJade = jadeTemplate locals: 
      instance: @locals 
      cInfo: @campaign

    mail_data.html = compiledJade if compiledJade? 
    console.log mail_data.html

    nodemailer.send_mail mail_data, (err, success)->
      if err
        console.log '---- Error! ----'
        console.log err
        res.json err: 'Sorry, the email system failed to send that request.'
      else
        console.log '---- Success! ----'
        console.log success
        res.json success: true
  

  else
    
    mail_data = 
    sender: 'seaga@seagamfg.com'
    subject: 'Campaign lead | '+req.body.campaign 
    to: 'achesney@seagamfg.com'
    cc: ['bclos@seagamfg.com', 'aolson@seagamfg.com']
    html: "
            <table width='100%' cellspacing='1' cellpadding='10' style='border:1px solid #c0c0c0;background:#f8f8f8;'>
            <tbody style='padding:10px;'>
            <tr><th colspan='2' width='100%' style='font: italic 20px Georgia, 'Times New Roman', serif;color: #3B5F87;border-bottom: 1px solid #ECECE8;'>Lead From Campaign | #{req.body.campaign}</th></tr>
            <tr style='border-top:1px solid #f5f5f5;border-bottom:1px solid #f5f5f5;margin:2px;'>
              <td width='12%' style='background:#f8f8f8;color:#000;padding:5px;text-align:right;border-right:1px solid #c0c0c0;'>Name</td>
              <td width='78%' style='background:#fff;color:#333;padding:5px;border-top:1px solid #c0c0c0;'>#{req.body.name}</td>
            </tr>
            <tr style='border-top:1px solid #f5f5f5;border-bottom:1px solid #f5f5f5;margin:2px;'>
              <td width='12%' style='background:#f8f8f8;color:#000;padding:5px;text-align:right;border-right:1px solid #c0c0c0;'>Phone</td>
              <td width='78%' style='background:#fff;color:#333;padding:5px;'>#{req.body.phone}</td>
            </tr>
            <tr style='border-top:1px solid #f5f5f5;border-bottom:1px solid #f5f5f5;margin:2px;'>
              <td width='12%' style='background:#f8f8f8;color:#000;padding:5px;text-align:right;border-right:1px solid #c0c0c0;'>Email</td>
              <td width='78%' style='background:#fff;color:#333;padding:5px;'>#{req.body.email}</td>
            </tr>
            </tbody>
            </table>
          "
  
    nodemailer.send_mail mail_data, (err, success)->
      if err
        console.log '---- Error! ----'
        console.log err
      else
        console.log '---- Success! ----'
        console.log success
        res.json success: true
