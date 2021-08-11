# frozen_string_literal: true

require "test_helper"

class Klass; include YART::Parser; end

class YartTest < Minitest::Test
  def test_version
    refute_nil YART::VERSION
  end

  def test_method_calls
    assert YART.respond_to? :parse
    assert Klass.new.respond_to? :parse
  end

  def test_render_login_form
    actual = YART.parse do
      form action: "/auth" do
        input type: :email, placeholder: "Email Address", required: true, close: true
        input type: :password, placeholder: "Password", required: true, close: true
        button(type: :submit, id: :login) { "Login" }
      end
    end
    expected = "<form action='/auth'><input type='email' placeholder='Email Address' required><input type='password' placeholder='Password' required><button type='submit' id='login'>Login</button></form>"

    assert_equal expected, actual
  end

  def test_render_sample_page
    actual = YART.parse do
      doctype
      html lang: :en do
        head do
          title { "YART API" }
        end
        body do
          h1 { "Use a block to return a String of innerText or more elements" }
          div data_test_id: "String attribute values will be parsed as is" do
            h2(data_x: :sub_heading) { "Symbol attribute keys/values will be kebab-cased" }
            text { "Set the div's innerText, before and/or after its child elements" }
            p(class: %i[content italic_text], id: :paragraph) do
              "You can pass an array of attribute values and they will be space separated"
            end
          end
          footer # Render an empty <footer></footer> element
        end
      end
    end
    expected = "<!DOCTYPE html><html lang='en'><head><title>YART API</title></head><body><h1>Use a block to return a String of innerText or more elements</h1><div data-test-id='String attribute values will be parsed as is'><h2 data-x='sub-heading'>Symbol attribute keys/values will be kebab-cased</h2>Set the div's innerText, before and/or after its child elements<p class='content italic-text' id='paragraph'>You can pass an array of attribute values and they will be space separated</p></div><footer></footer></body></html>"

    assert_equal expected, actual
  end

  def test_element
    assert_equal "<!DOCTYPE></!DOCTYPE>", YART.parse { element "!DOCTYPE" }
  end

  def test_text__block
    actual = YART.parse do
      div do
        p { "Hello" }
        text { "Big" }
        p { "World" }
      end
    end
    expected = "<div><p>Hello</p>Big<p>World</p></div>"

    assert_equal expected, actual
  end

  def test_block_and_close_true
    assert_raises StandardError do
      YART.parse do
        div(close: true) { "Hello world" }
      end
    end
  end

  def test_text__param
    actual = YART.parse do
      div do
        p { "Hello" }
        text "Big"
        p { "World" }
      end
    end
    expected = "<div><p>Hello</p>Big<p>World</p></div>"

    assert_equal expected, actual
  end

  def test_attribute_kebab_case
    assert_equal "<div data-x='secret-value'></div>", YART.parse { div data_x: :secret_value }
  end

  def test_attribute_string_value
    assert_equal "<div id='secret_Value 1'></div>", YART.parse { div id: "secret_Value 1" }
  end

  def test_attribute_true_value
    assert_equal "<input required></input>", YART.parse { input required: true }
  end

  def test_attribute_values_array
    assert_equal "<div class='a b c'></div>", YART.parse { div class: [:a, "b", "c"] }
  end

  def test_escape_illegal_chars
    assert_equal("<p id='&quot; &#39; &lt; &gt;'>Hello</p>", YART.parse do
      p(id: "\" ' < >") { "Hello" }
    end)
  end

  def test_close_attribute
    assert_equal "<input type='text'>", YART.parse { input type: :text, close: true }
  end

  def test_doctype
    assert_equal "<!DOCTYPE html>", YART.parse { doctype }
  end

  def test_script__block
    actual = YART.parse do
      javascript { "http://example.com/main.js" }
    end
    expected = "<script src='http://example.com/main.js'>"

    assert_equal expected, actual
  end

  def test_script__param
    actual = YART.parse { javascript "http://example.com/main.js" }
    expected = "<script src='http://example.com/main.js'>"

    assert_equal expected, actual
  end

  def test_stylesheet__block
    actual = YART.parse do
      stylesheet { "http://example.com/main.css" }
    end
    expected = "<link href='http://example.com/main.css' rel='stylesheet' type='text/css'>"

    assert_equal expected, actual
  end

  def test_stylesheet__param
    actual = YART.parse { stylesheet "http://example.com/main.css" }
    expected = "<link href='http://example.com/main.css' rel='stylesheet' type='text/css'>"

    assert_equal expected, actual
  end

  def test_br
    assert_equal("<br>", YART.parse { br })
    assert_equal("<br>", YART.parse { br close: true })
    assert_equal("<br></br>", YART.parse { br close: false })
  end

  def test_p
    assert_equal("<p>Hello world</p>", YART.parse { p { "Hello world" } })
  end
end
