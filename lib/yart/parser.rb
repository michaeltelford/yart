# frozen_string_literal: true

module YART::Parser
  def parse(prettify: true, &block)
    raise "Must pass a block to render HTML" unless block_given?

    @@yart_buffer = []

    instance_eval(&block)

    @@yart_buffer.join

    # TODO: use prettify
  end

  def method_missing(m, *args, &block)
    attributes = args.fetch(0, {})
    raise "The element attributes must be a Hash" unless attributes.is_a?(Hash)

    render(m, attributes, &block)
  end

  private

  def render(element, attributes, &block)
    # TODO: use attributes
    @@yart_buffer << "<#{element}>"
    @@yart_buffer << instance_eval(&block) if block_given?
    @@yart_buffer << "</#{element}>"
  end

  # Sets the innerText of the element being rendered.
  def text(&block)
    str = block.call
    raise "text's block must return a String" unless str.is_a?(String)

    str
  end

  # Override Ruby's p method to render the element instead of printing.
  def p(**attributes, &block)
    render("p", **attributes, &block)
  end
end
