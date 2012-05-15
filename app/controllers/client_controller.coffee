before 'protect from forgery', ->
    protectFromForgery '8f4ae982f956d510a39869a2c7c50afb40991f5a'

action 'display', ->
    Campaign.all where: slug: params.slug, (err, campaigns)=>
      @campaign = campaigns[0]

      Brand.find @campaign.brand, (err, brand)=>
        @brand = brand

        #--- Send How Many Column Landing Page Has To Client Template ---#
        
        @counter = 0
        if (@campaign.columnHeader1 != '' && @campaign.columnText1 != '')
          @counter++
        if (@campaign.columnHeader2 != '' && @campaign.columnText2 != '')
          @counter++
        if (@campaign.columnHeader3 != '' && @campaign.columnText3 != '')
          @counter++

        layout 'client'
        render()

action 'rssFeed', ->
    Campaign.all (err, campaigns) =>
      res.charset = 'utf-8'
      res.contentType 'xml/rss'
      res.render app.root+'/app/views/client/rssFeed.jade',layout: null, campaigns: campaigns