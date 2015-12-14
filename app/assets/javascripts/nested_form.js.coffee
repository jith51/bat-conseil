(($) ->
  window.NestedFormEvents = ->
    @addFields = $.proxy(@addFields, this)
    @removeFields = $.proxy(@removeFields, this)
    return

  NestedFormEvents:: =
    addFields: (e) ->
      
      currentLink = $(e.currentTarget)
      assoName = currentLink.data('association')

      $.ajax
        url: "/add_nested_fields"
        type: "GET"
        dataType: "html"
        data: currentLink.data()

        success: (html) ->
          
          newNestedForm = $(html) 

          field = NestedFormEvents::insertFields $(newNestedForm), assoName, currentLink
          
          # si on a specifié une limite et qu'on l'a atteinte, on cache le lien
          if currentLink.data('limit')
            nbVisibleFields =  if currentLink.data('target') then $(currentLink.data('target')).children('.fields:visible').length else currentLink.siblings('.fields:visible').length
            if nbVisibleFields >= currentLink.data('limit')
              currentLink.hide()

          # bubble up event upto document (through form)
          field.trigger(
            type: "nested:fieldAdded"
            field: field
          ).trigger
            type: "nested:fieldAdded:" + assoName
            field: field

          return

        error: (html) ->
          $("<div>Error in AJAX request</div>").insertBefore currentLink
          return

      e.preventDefault()  

    insertFields: (content, assoc, link) ->
      target = $(link).data('target')
      if target
        return $(content).appendTo $(target)
      else
        return $(content).insertBefore link

    removeFields: (e) ->

      currentLink = $(e.currentTarget)
      closestField = currentLink.closest(".fields")
      hiddenInput = currentLink.prev('input[type=hidden]')

      if $(hiddenInput).data('new')
        closestField.slideUp().remove()      
      else
        $(hiddenInput).val('1')
        closestField.slideUp().hide()

      # si on a specifié une limite et qu'on ne l'atteint plus, on remet le lien add
      addLink = $("a[data-record='"+(currentLink.data('record').match(/(.*)\[.*_attributes\].*$/)[1])+"']")

      if addLink.data('limit')
        nbVisibleFields =  if addLink.data('target') then $(addLink.data('target')).children('.fields:visible').length else addLink.siblings('.fields:visible').length
        if nbVisibleFields < addLink.data('limit')
          addLink.show()

      closestField.trigger(
        type: 'nested:fieldRemoved'
        field: closestField
      ).trigger
        type: 'nested:fieldRemoved:' + currentLink.data('association')
        field: closestField

      e.preventDefault() 

  window.nestedFormEvents = new NestedFormEvents()

  $(document).delegate("form a.add_nested_fields", "click", nestedFormEvents.addFields).delegate "form a.remove_nested_fields", "click", nestedFormEvents.removeFields
  return

) jQuery