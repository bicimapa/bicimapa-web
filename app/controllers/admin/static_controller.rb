class Admin::StaticController < Admin::AdminController
  def index
    @site_count = Site.count

    query = %{
       select sum(ST_Length_Spheroid(path,'SPHEROID["WGS 84",6378137,298.257223563]'))/1000 as length
       from lines l 
       join categories c on c.id = l.category_id 
       where l.is_active and l.deleted_at is null
       and c.is_active and c.deleted_at is null

    }

    results = Line.connection.execute(query)
    @lines_km = results.first['length'].to_i


    @rating_count = Rating.count
    @user_count = User.count
    @report_count = Reports::Report.count
    @comment_count = Comment.count
    @newsletter_count = Newsletter.count
  end

  def configuration
  end
end
