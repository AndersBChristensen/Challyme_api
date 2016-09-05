module AuthHelper
  # Sessions
  #
  # Keeps track of session info and provides methods of loggin in, logging out etc
  # @see https://github.com/binarylogic/Authlogic
  class Session < Authlogic::Session::Base
    authenticate_with User
  end

  # Logs out a user
  def self.logout
    AuthHelper::Session.find.destroy
  end

  # Logins user via a user object
  #
  # @params User user
  def self.login(user)
    session = AuthHelper::Session.new(user)
    return session.save
  end
end
