# Helper methods defined here can be accessed in any controller or view in the application

Lbs::App.helpers do
  def numeric?(value)
    true if value.present? && Float(value) rescue false
  end
end
