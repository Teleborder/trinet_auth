module TrinetAuth
  class Client
    module Auth
      def login(employee_id, password)
        @token = post "signon", { emplid: employee_id, userpassword: password }
      end

      def token_info
        get "guid", { token: @token }
      end

      def user_attributes
        get "user/token/#{@token}"
      end
    end
  end
end
