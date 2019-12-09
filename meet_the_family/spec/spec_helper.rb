class Hash
  def stringify_keys
    collect {|k,v| [k.to_s, v]}.to_h
  end
end