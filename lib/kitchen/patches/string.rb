class String
  def uncapitalize
    sub(/^[A-Z]/, &:downcase)
  end
end
