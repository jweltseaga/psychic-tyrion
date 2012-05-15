load 'application'
skipBeforeFilter('protect from forgery')

fs = require 'fs'
_  = require 'underscore'

before 'load campaign', ->
    Campaign.find params.id, (err, campaign) =>
        if err
            redirect path_to.campaigns()
        else
            @campaign = campaign
            if @campaign.brand
                
                Brand.find @campaign.brand, (err, brand)=>
                    if err
                        redirect path_to.campaigns()
                    else
                        @brand = brand
                        next()
            
            else
                next()

, only: ['show', 'edit', 'update', 'destroy']

before 'load brands', ->
    Brand.all (err, brands)=>
        if err
            redirect path_to.campaigns()
        else
            @brands = brands
            next()
, only: ['edit', 'new']


before 'image file check', ->
    if req.files
        # Save file info to an object
        # This optimizes traversing the object tree considerably
        images = req.files.Campaign
        
        # @ means it will still be accessible after next() is called
        @fileUrls  = {}

        for key, fileData of images
            if fileData.size != 0

                # Extract the base path from app stack
                basePath = app.root+'/public/uploads/'

                # Destroy old file first  

                if @campaign
                    fs.unlink basePath+@campaign[key], (err)->
                        console.log err
                
               
                
                # Extract File extension and create the file name based on DB id and field
                # this insures both uniquenes and fetchability
                fileExt = fileData.name.split('.')[1]
                
                if @campaign
                    imgName = @campaign.id+'-'+key+'.'+fileExt
                else
                    # If the campaign does not exist we must compensate for values we currently have
                    imgName = req.body.Campaign.slug+'-'+key+'.'+fileExt

                # Rename the temporary file
                fs.rename(fileData.path, basePath+imgName)

                # Attach the new file name to our @fileUrls object to pass on into next()
                @fileUrls[key] = imgName


            else
                # Destroy empty file
                fs.unlink fileData.path, (err)->
                    console.log err
        
        # Next Process
        next()
    else
        next()
, only: ['create', 'update']

action 'new', ->
    @campaign = new Campaign
    @title = 'New campaign'
    render()

action 'create', ->
    
    for field, url of @fileUrls
        body.Campaign[field] = url

    Campaign.create body.Campaign, (err, campaign) =>
        if err
            flash 'error', 'Campaign can not be created'
            @campaign = campaign
            @title = 'New campaign'
            render 'new'
        else
            flash 'info', 'Campaign created'
            redirect path_to.campaigns()


action 'index', ->
    Campaign.all (err, campaigns) =>
        @campaigns = campaigns
        @title = 'Campaigns index'
        render()

action 'show', ->
    @title = 'Campaign show'
    render()

action 'edit', ->
    @title = 'Campaign edit'
    render()

action 'update', ->

    for field, url of @fileUrls
        body.Campaign[field] = url

    ajax = body.ajax

    @campaign.updateAttributes body.Campaign, (err) =>
        if !err
            if ajax == 'true'
                res.json success: true
            else
                flash 'info', 'Campaign updated'
                redirect path_to.campaigns
        else
            if ajax == 'true'
                res.json error: err
            else
                flash 'error', 'Campaign can not be updated'
                @title = 'Edit campaign details'
                render 'edit'

action 'destroy', ->
    @campaign.destroy (error) ->
        if error
            flash 'error', 'Can not destroy campaign'
        else
            flash 'info', 'Campaign successfully removed'
        send "'" + path_to.campaigns() + "'"
