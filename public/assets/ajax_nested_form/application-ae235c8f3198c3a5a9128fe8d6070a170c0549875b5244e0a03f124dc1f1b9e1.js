(function() {
  (function($) {
    window.NestedFormEvents = function() {
      this.addFields = $.proxy(this.addFields, this);
      this.removeFields = $.proxy(this.removeFields, this);
    };
    NestedFormEvents.prototype = {
      addFields: function(e) {
        var assoName, currentLink;
        currentLink = $(e.currentTarget);
        assoName = currentLink.data('association');
        $.ajax({
          url: "/ajax_nested_form/add_nested_fields",
          type: "GET",
          dataType: "html",
          data: currentLink.data(),
          success: function(html) {
            var field, nbVisibleFields, newNestedForm;
            newNestedForm = $(html);
            field = NestedFormEvents.prototype.insertFields($(newNestedForm), assoName, currentLink);
            if (currentLink.data('limit')) {
              nbVisibleFields = currentLink.data('target') ? $(currentLink.data('target')).children('.fields:visible').length : currentLink.siblings('.fields:visible').length;
              if (nbVisibleFields >= currentLink.data('limit')) {
                currentLink.hide();
              }
            }
            field.trigger({
              type: "nested:fieldAdded",
              field: field
            }).trigger({
              type: "nested:fieldAdded:" + assoName,
              field: field
            });
          },
          error: function(html) {
            $("<div>Error in AJAX request</div>").insertBefore(currentLink);
          }
        });
        return e.preventDefault();
      },
      insertFields: function(content, assoc, link) {
        var target;
        target = $(link).data('target');
        if (target) {
          return $(content).appendTo($(target));
        } else {
          return $(content).insertBefore(link);
        }
      },
      removeFields: function(e) {
        var addLink, closestField, currentLink, hiddenInput, nbVisibleFields;
        currentLink = $(e.currentTarget);
        closestField = currentLink.closest(".fields");
        hiddenInput = currentLink.prev('input[type=hidden]');
        if ($(hiddenInput).data('new')) {
          closestField.slideUp().remove();
        } else {
          $(hiddenInput).val('1');
          closestField.slideUp().hide();
        }
        addLink = $("a[data-record='" + (currentLink.data('record').match(/(.*)\[.*_attributes\].*$/)[1]) + "']");
        if (addLink.data('limit')) {
          nbVisibleFields = addLink.data('target') ? $(addLink.data('target')).children('.fields:visible').length : addLink.siblings('.fields:visible').length;
          if (nbVisibleFields < addLink.data('limit')) {
            addLink.show();
          }
        }
        closestField.trigger({
          type: 'nested:fieldRemoved',
          field: closestField
        }).trigger({
          type: 'nested:fieldRemoved:' + currentLink.data('association'),
          field: closestField
        });
        return e.preventDefault();
      }
    };
    window.nestedFormEvents = new NestedFormEvents();
    $(document).delegate("form a.add_nested_fields", "click", nestedFormEvents.addFields).delegate("form a.remove_nested_fields", "click", nestedFormEvents.removeFields);
  })(jQuery);

}).call(this);
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

