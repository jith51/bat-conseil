# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :foundation, class: 'group-form prefix-radius', hint_class: :field_with_hint, error_class: :error do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label_input
    b.use :error, wrap_with: { tag: 'span', class: 'form-error is-visible' }

    # Uncomment the following line to enable hints. The line is commented out by default since Foundation
    # does't provide styles for hints. You will need to provide your own CSS styles for hints.
    # b.use :hint,  wrap_with: { tag: :span, class: :hint }
  end

  config.wrappers :inline_foundation, class: :input, hint_class: :field_with_hint, error_class: :error do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
  
    b.wrapper tag: 'div', class: 'group-form prefix-radius' do |c|
      c.use :label, wrap_with: { tag: 'span', class: 'small-12 medium-12 large-5 column' }
      c.use :input, wrap_with: { tag: 'div', class: 'small-12 medium-12 large-7 column' }
      c.use :error, wrap_with: { tag: 'div', class: 'form-error is-visible' }
    end

  end

  # config.wrappers :min_inline_foundation, class: 'input', hint_class: :field_with_hint, error_class: :error do |b|
  #   b.use :html5
  #   b.use :placeholder
  #   b.optional :maxlength
  #   b.optional :pattern
  #   b.optional :min_max
  #   b.optional :readonly
  
  #   b.wrapper tag: 'div', class: 'group-form prefix-radius' do |c|
  #     c.use :label, wrap_with: { tag: 'span', class: 'small-12 medium-12 large-3 column' }
  #     c.use :input, wrap_with: { tag: 'div', class: 'small-12 medium-12 large-9 column' }
  #   end
  #   b.use :error, wrap_with: { tag: 'div', class: 'form-error is-visible' }

  # end
  config.wrappers :min_inline_foundation, class: 'group-form', hint_class: :field_with_hint, error_class: :error do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    # b.wrapper tag: 'div', class: 'small-12 medium-12 large-3 column' do |c|
    #   c.use :input
    #   c.use :error, class: 'form-error is-visible'
    # end
    b.use :label, wrap_with: { tag: 'div', class: 'small-12 medium-12 large-3 column' }

    b.wrapper tag: 'div', class: 'small-12 medium-12 large-9 column' do |c|
      c.use :input
      c.use :error, wrap_with: { tag: 'span', class: 'form-error is-visible' }
    end

  end

  # CSS class for buttons
  config.button_class = 'button'

  # CSS class to add for error notification helper.
  config.error_notification_class = 'alert callout'

  # The default wrapper to be used by the FormBuilder.
  config.default_wrapper = :min_inline_foundation
end
