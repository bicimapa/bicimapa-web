module UiHelper

  def comment_form
    content_tag(:div, class: "media") do
      output = []

      output << link_to(user_path(current_user), class: "pull-left") do
          image_tag avatar_url(current_user), alt: t(:avatar), class: "media-object thumbnail"
      end
      
      output << content_tag(:div, class: "media-body") do
        form_tag("/sites/#{@site.id}/comment", :method => :patch) do
          output1 = []

          output1 << content_tag(:h4, class:"media-heading", styler: "margin-bottom: 7px") do
            full_name(current_user)
          end
          output1 << text_area_tag(:comment, nil, placeholder:t(:this_is_a_great_place), class: "form-control", style:"width: 100%;height: 85px")
          output1 << submit_tag(t(:post), :class => 'btn btn-default pull-right', style: "margin-top: 7px")

          output1.join("\n").html_safe
        end
      end

      output.join("\n").html_safe
    end
  end

  def comment(comment, record)
    content_tag(:div, class: "media") do
      output = []

      output << link_to(user_path(comment.user), class: "pull-left") do
          image_tag avatar_url(comment.user), alt: t(:avatar), class: "media-object thumbnail"
      end
      
      output << content_tag(:div, class: "media-body") do
        output1 = []

        output1 << content_tag(:h4, class:"media-heading") do
          output2 = [] 

          output2 << full_name(comment.user) 
          output2 << content_tag(:small) do
            output3 = []
            
            output3 << time_ago_in_words(comment.created_at)
            output3 << t(:ago)

            if comment.created_at < record.updated_at
                 output3 << "(#{t :before_last_update })"
            end
            
            output3.join(" ").html_safe
          end

          output2.join("\n").html_safe
        end

        output1 << comment.comment


        output1.join("\n").html_safe
      end

      output.join("\n").html_safe
    end
  end

  def callout(message, title=nil, type=:warning)

    message = I18n.t(message) if message.is_a?(Symbol)
    title = I18n.t(title) if title.is_a?(Symbol)

    content_tag(:div, class: "callout callout-#{type}") do
      output = []
      output << content_tag(:h4, title.html_safe) if title.present?
      output << content_tag(:p, message.html_safe)
      output.join("\n").html_safe
    end
  end

  def carousel(images)

    images = Array.wrap(images)
    
    content_tag(:div, id: "carousel", class: "carousel slide", data: {ride: "carousel"}) do
      output = []

      output << content_tag(:ol, class: "carousel-indicators") do
        output1 = []
        
        images.each_with_index do |image, index|
          output1 << content_tag(:li, nil, data: { target: "#carousel", "slide-to": index }, class: (index == 0)?"active":nil )
        end

        output1.join("\n").html_safe
      end

      output << content_tag(:div, class: "carousel-inner") do
        output2 = []
      
        images.each_with_index do |image, index|
          output2 << content_tag(:div, class: "item #{(index==0)?"active":nil}") do
            image_tag image.url(:medium), style: "margin: 0px auto"
          end
        end

        output2.join("\n").html_safe
      end

      output.join("\n").html_safe
    end
  end

  def row(&block)
    content_tag(:div, class: "row", &block)
  end

  def column(size=6, &block)
    content_tag(:div, class: "col-md-#{size}", &block)
  end

  def panel(title=nil, &block)
    content_tag(:div, class: "box box-solid") do
      output = []
      output << content_tag(:div, class: "box-header") do
        content_tag(:div, title, class: "box-title")
      end if title.present?
      output << content_tag(:div, class: "box-body", &block)
      output.join("\n").html_safe
    end
  end

  def attributes_table(&block)
    content_tag(:table, class: "table") do
      content_tag(:tbody, &block)
    end
  end

  alias form_table attributes_table

  def attribute(name, value)
    content_tag(:tr) do
      th = content_tag(:th, I18n.t(name))
      td = content_tag(:td) do
        if value.present?
          value
        else
          content_tag(:span, "Empty", class: "empty") 
        end
      end
      th + td
    end
  end

  def pull_right
    content_tag(:div, class: "pull-right") do
      yield + content_tag(:div, nil, class: "clearfix")
    end
  end

  def button_bar
    row do
      column(12) do
        panel do
          pull_right do
            yield
          end
        end
      end
    end
  end

end
