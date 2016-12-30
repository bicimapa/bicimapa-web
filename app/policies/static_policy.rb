class StaticPolicy < Struct.new(:user, :static)
  def show?
    true
  end
end
