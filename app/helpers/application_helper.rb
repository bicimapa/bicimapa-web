module ApplicationHelper

  def has_picture(site)
    return true if (site.picture_1? || site.picture_2? || site.picture_3?)
    false
  end

  def get_first_picture(site)
    return site.picture_1.url if site.picture_1?
    return site.picture_2.url if site.picture_2?
    return site.picture_3.url if site.picture_3?
  end

  def get_team_users
    User.find [1, 5, 6, 8]
  end

  def static_map_url(path)

    points = path.points.map do |p| [p.y, p.x] end
    polyline = Polylines::Encoder.encode_points(points)

    start_lat = path.points[0].y.round 5
    start_lon = path.points[0].x.round 5

    end_lat = path.points[-1].y.round 5
    end_lon = path.points[-1].x.round 5

    "https://maps.googleapis.com/maps/api/staticmap?size=1024x512&path=weight:3|color:0x000000FF|enc:#{polyline}&markers=icon:#{"http://goo.gl/GpeLJm"}|#{start_lat},#{start_lon}&markers=icon:#{"http://goo.gl/fMjXd2"}|#{end_lat},#{end_lon}"
  end

  def polygon_to_s(polygon)
    polygon.exterior_ring.points[0...-1].map { |p| [p.y, p.x] }.to_s
  end

  def bool(bool)

    klass = 'label '

    if bool 
      klass += 'label-success'
    else
      klass += 'label-danger'
    end

    content_tag :span, bool ? t(:true) : t(:false), class: klass
  end

  def avatar_url(user, size=64)
    if user.nil?
       return "anonymous.png"
    end

    if user.avatar.present?
      user.avatar.url(:thumb)
    elsif user.facebook_uid.present?
      "https://graph.facebook.com/v2.5/#{user.facebook_uid}/picture?width=#{size}&height=#{size}"
    else
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      "https://www.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=wavatar"
    end
  end

  def full_name(user)
    user.try(:full_name) || I18n.t(:anonymous)
  end

  def rating(rating, nb_ratings = nil)
    str = ''

    if !rating.nil?
      str += '<span style="color:#f39c12">'

      for i in 0..rating.floor - 1
        str += '<i class="fa fa-star"></i>'
      end
      if rating % 1 != 0
        if rating.modulo(1).between?(0, 0.5)
          if rating < 1.5
            str += '<i class="fa fa-star-o"></i>'
          else
            str += '<i class="fa fa-star-half-o"></i>'
          end
        else
          if rating < 1.5
            str += '<i class="fa fa-star-half-o"></i>'
          else
            str += '<i class="fa fa-star"></i>'
          end
        end
      end
      for i in rating.ceil..4
        str += '<i class="fa fa-star-o"></i>'
      end
      str += '</span>'
      unless nb_ratings.nil?
        str += "<span style=\"color: #ccc\"> (<acronym title=\"#{I18n.t(:number_of_users_who_rated_this_site)}\" style=\"cursor:help\">#{nb_ratings}</acronym>)</span>"
      end
    else
      str += '<span style="color:#eee">'
      for i in 0..4
        str += '<i class="fa fa-star"></i>'
      end
      unless nb_ratings.nil?
        str += ' (<acronym title="' + I18n.t(:number_of_users_who_rated_this_site) + '" style="cursor:help">0</acronym>)</span>'
      end
      str += '</span>'
    end

    str.html_safe
  end

  def added_by(bean)
    return content_tag :span, I18n.t(:bicimapa_team), style: 'color:#ccc' if bean.try(:origin) == 'IMP' || bean.try(:origin) == 'ORG'
    content_tag :span, bean.try(:user).try(:full_name) || I18n.t(:anonymous), style: ('color:#ccc' if bean.user.nil?)
  end

  def added_by_without_html(bean)
    return I18n.t(:bicimapa_team) if bean.try(:origin) == 'IMP' || bean.try(:origin) == 'ORG'
    bean.try(:user).try(:full_name) || I18n.t(:anonymous)
  end

end
