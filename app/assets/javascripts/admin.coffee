$(window).load ->
  imgP    = $('.img-preview')
  overlay = $('.overlay')
  scc     = $('.showcase-container')
  choice = $('div.option[data-state="inactive"]')


  imgP.live 'click', (e)->
    @imgSrc = $(this).attr('data-img')
    overlay.fadeIn 300, =>
      imgEle = "<img src='/uploads/#{@imgSrc}' class='showcase-img' />"
      scc.html(imgEle).addClass('active').slideDown 300
  

  overlay.live 'click', ->
    $('.active').slideUp 300, ->
      overlay.fadeOut 300

  choice.live 'click', (e)->
    el = $(this)
    id = el.attr('data-id')
    field = el.parent().attr('data-field')
    checkState = el.parent().attr('data-checkState')
    path  = el.parent().attr('data-path')
    structure = el.parent().attr('data-structure')

    if checkState is 'new'
      if $("form input##{field}").length > 0
        $("form input##{field}").val(id)
      else
        $('form').append("<input type='hidden' value='#{id}' id='#{structure}_#{field}' name='#{structure}[#{field}]'/>")
      el.siblings('[data-state="active"]').attr('data-state', 'inactive')
      el.attr('data-state', 'active')
    else
      @data = {}
      instance = {}
      instance[field] = id 
      @data[structure] = instance
      @data.ajax = true   
      $.put path,  @data, (@res)->
          if res.success
            el.siblings('[data-state="active"]').attr('data-state', 'inactive')
            el.attr('data-state', 'active')
          else
            console.log res.error