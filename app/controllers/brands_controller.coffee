load 'application'

fs = require 'fs'

before 'load brand', ->
    Brand.find params.id, (err, brand) =>
        if err
            redirect path_to.brands()
        else
            @brand = brand
            next()
, only: ['show', 'edit', 'update', 'destroy']

before 'image file check', ->
    
    # Save file info to an object
    # This optimizes traversing the object tree considerably
    images = req.files.Brand
    
    # @ means it will still be accessible after next() is called
    @fileUrls  = {}

    for key, fileData of images
        if fileData.size != 0
            
            # Extract the base path on the server so processes can manipulate it
            fileArray = fileData.path.split('/')
            delete fileArray[fileArray.length-1]
            basePath = fileArray.join('/')
            
            # Extract File extension and create the file name based on DB id and field
            # this insures both uniquenes and fetchability
            fileExt = fileData.name.split('.')[1]
            if @brand
                imgName = @brand.id+'-'+key+'.'+fileExt
            else
                imgName = body.Brand.name+'-'+key+'.'+fileExt

            # Rename the temporary file
            fs.rename(fileData.path, basePath+imgName)

            # Attach the new file name to our @fileUrls object to pass on into next()
            @fileUrls[key] = imgName

            # Destroy old file
            if @brand
                fs.unlink basePath+@brand[key], (err)->
                    console.log err
        else
            # Destroy empty file
            fs.unlink fileData.path, (err)->
                console.log err
    
    # Next Process
    next()
, only: ['create', 'update']

action 'new', ->
    @brand = new Brand
    @title = 'New brand'
    render()

action 'create', ->
   
    for field, url of @fileUrls
        body.Brand[field] = url

    Brand.create body.Brand, (err, brand) =>
        if err
            flash 'error', 'Brand can not be created'
            @brand = brand
            @title = 'New brand'
            render 'new'
        else
            flash 'info', 'Brand created'
            redirect path_to.brands()

action 'index', ->
    Brand.all (err, brands) =>
        @brands = brands
        @title = 'Brands index'
        render()

action 'show', ->
    @title = 'Brand show'
    render()

action 'edit', ->
    @title = 'Brand edit'
    render()

action 'update', ->

    for field, url of @fileUrls
        body.Brand[field] = url

    @brand.updateAttributes body.Brand, (err) =>
        if !err
            flash 'info', 'Brand updated'
            redirect path_to.brand(@brand)
        else
            flash 'error', 'Brand can not be updated'
            @title = 'Edit brand details'
            render 'edit'

action 'destroy', ->
    @brand.destroy (error) ->
        if error
            flash 'error', 'Can not destroy brand'
        else
            flash 'info', 'Brand successfully removed'
        send "'" + path_to.brands() + "'"

