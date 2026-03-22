class AuthResponseSerializer
  def initialize(user, token)
    @user = user
    @token = token
  end

  def as_json(*)
    {
      user: UserSerializer.new(@user).as_json,
      token: @token
    }
  end
end
