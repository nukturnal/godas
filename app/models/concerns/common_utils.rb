module CommonUtils
  extend ActiveSupport::Concern

  def convert_name(name, default = 1)
    return nil unless name
    name.split("-").join(" ").split.map{|i| i[0,default]}.join.upcase
  end

  # Simply grab the first 3 letters if the region name is one word
  # grab the first two letters of the first word and the first word of the last word if ...
  # region name is more than one
  # this should be OK for Ghana a country with then regions only.
  # We should have something like the examples below
  # UPW (Upper West)
  # UPE (Upper East)
  # ASH (Ashanti)
  # GRA (Greater Accra)
  # WES (Western)
  # EAS (Eastern)
  # CEN (Central)
  # BRA (Brong Ahafo)
  # VOL (Volta) Ny3 bro :)
  # NOR (Northern)
  def region_code(name)
    return nil unless name
    name_array = name.downcase.gsub(/region/,"").strip.split
    if name_array.size > 1
      first_name = name_array[0]
      last_name = name_array[-1]
      "#{convert_name(first_name, 2)}#{convert_name(last_name, 1)}"
    else
      name = name_array[0]
      "#{name[0..2]}".upcase
    end
  end

  # For some unknown reason I feel the first letter and last two letters will make sense
  # Example Kumasi will be better looking like KSI than KUM so lets get this over with
  def city_code(name)
    return nil unless name
    name_array = name.downcase.strip.split
    if name_array.size > 1
      convert_name(name_array.join(" "), 2)
    else
      name = name_array[0]
      "#{name[0..1]}#{name[-2..-1]}".upcase
    end
  end
end