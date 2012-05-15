before 'protect from forgery', ->
    protectFromForgery '8f4ae982f956d510a39869a2c7c50afb40991f5a'

action 'anniversary', () -> 
    render
        title: "Annivesary Special"
        cdn: "http://www.seagamfg.com"
        host: "http://click.seagamfg.com"
        special: 'specials/anniversary'