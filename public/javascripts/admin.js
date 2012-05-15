(function() {

  $(window).load(function() {
    var choice, imgP, overlay, scc;
    imgP = $('.img-preview');
    overlay = $('.overlay');
    scc = $('.showcase-container');
    choice = $('div.option[data-state="inactive"]');
    imgP.live('click', function(e) {
      var _this = this;
      this.imgSrc = $(this).attr('data-img');
      return overlay.fadeIn(300, function() {
        var imgEle;
        imgEle = "<img src='/uploads/" + _this.imgSrc + "' class='showcase-img' />";
        return scc.html(imgEle).addClass('active').slideDown(300);
      });
    });
    overlay.live('click', function() {
      return $('.active').slideUp(300, function() {
        return overlay.fadeOut(300);
      });
    });
    return choice.live('click', function(e) {
      var checkState, el, field, id, instance, path, structure;
      el = $(this);
      id = el.attr('data-id');
      field = el.parent().attr('data-field');
      checkState = el.parent().attr('data-checkState');
      path = el.parent().attr('data-path');
      structure = el.parent().attr('data-structure');
      if (checkState === 'new') {
        if ($("form input#" + field).length > 0) {
          $("form input#" + field).val(id);
        } else {
          $('form').append("<input type='hidden' value='" + id + "' id='" + structure + "_" + field + "' name='" + structure + "[" + field + "]'/>");
        }
        el.siblings('[data-state="active"]').attr('data-state', 'inactive');
        return el.attr('data-state', 'active');
      } else {
        this.data = {};
        instance = {};
        instance[field] = id;
        this.data[structure] = instance;
        this.data.ajax = true;
        return $.put(path, this.data, function(res) {
          this.res = res;
          if (res.success) {
            el.siblings('[data-state="active"]').attr('data-state', 'inactive');
            return el.attr('data-state', 'active');
          } else {
            return console.log(res.error);
          }
        });
      }
    });
  });

}).call(this);
