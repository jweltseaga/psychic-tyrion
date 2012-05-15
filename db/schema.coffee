now = new Date()

User = describe 'User', () ->
    property 'firstName', String
    property 'lastName', String
    property 'email', String, index: true
    property 'superUser', Boolean, default: false
    property 'password', String

Campaign = describe 'Campaign', () ->
    property 'title', String
    property 'createdAt', Date, default: now
    property 'createdBy', String
    property 'imgUrl', String
    property 'published', Boolean
    property 'salesEmail', String
    property 'columnHeader1', String
    property 'columnHeader2', String
    property 'columnHeader3', String
    property 'columnText1', String
    property 'columnText2', String
    property 'columnText3', String
    property 'columnImage1', String
    property 'columnImage2', String
    property 'columnImage3', String
    property 'brand', String
    property 'slug', String

Brand = describe 'Brand', () ->
    property 'name', String
    property 'phone', String
    property 'defaultEmail', String
    property 'image', String

