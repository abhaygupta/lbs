class Address 
  attr_accessor :line1, :line2, :city, :state, :pincode, :landmark, :country
  
  def to_s
    "#{line1} #{line2} #{pincode} #{landmark} #{city} #{state} #{country}".downcase
  end
end