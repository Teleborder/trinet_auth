module TrinetAuth
  class Client
    module Auth
      def login(employee_id, password)
        @auth_token = post "signon", { emplid: employee_id, userpassword: password }
      end

      def token_info
        get "guid", { token: @auth_token }
      end

      def user_attributes
        get "user/token/#{@auth_token}"
      end
    end
  end
end
