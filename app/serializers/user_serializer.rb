class UserSerializer
  def initialize(user)
    @user = user
  end

  def as_json(*)
    {
      id: @user.id,
      email: @user.email,
      firstName: @user.first_name,
      lastName: @user.last_name,
      createdAt: @user.created_at
    }
  end
end
