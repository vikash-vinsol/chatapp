module Api
  module V1
    class UsersController < BaseController
      before_filter :load_user_by_mobile, only: [:resend_verification_sms, :verify]
      before_filter :load_verified_user_by_account_name, only: [:send_friend_request, :friend_invitation_response]
      before_filter :check_status, only: :friend_invitation_response

      skip_before_filter :authorize_request, only: [:create, :check_presence, :resend_verification_sms, :verify]

      def create
        @user = User.create(user_params)
        respond_with(@user)
      end

      def show
        @user = User.verified.find_by_account_name(params[:account_name])
      end

      def check_presence
        @user_exist = User.exist_with_account_name?(params[:account_name])
      end

      def send_installation_sms
        Sms.delay.deliver(params[:mobile], "XYZ's message")
        render nothing: true
      end

      def resend_verification_sms
        @user.regenerate_verification_token
        respond_with(@user)
      end

      def verify
        @status = @user.verify(params[:verification_token], current_device_type, current_device_token)
        session[:user_id] = @user.id if(@status == User::VERIFY_STATUS[:verified])
        respond_with(@user)
      end

      def send_friend_request
        @friend_request, @status = current_user.send_friend_invitation_to(@user)
        respond_with(@friend_request)
      end

      def friend_invitation_response
        @status = current_user.handle_friend_invitation_response(@user, params[:status])
      end

      def friends_and_contacts
        @old_friends = current_user.friends
        @friend_invitations_sent_to = current_user.friend_invitations_sent_to
        @friend_invitations_received_by = current_user.friend_invitations_received_by
        total_friend_related_users = @old_friends + @friend_invitations_sent_to + @friend_invitations_received_by

        if(params[:mobiles].present?)
          @other_mobiles = params[:mobiles] - total_friend_related_users.map(&:mobile)
          @new_friends = current_user.make_friends_with(@other_mobiles)
          @other_mobiles -= @new_friends.map(&:mobile)
        else
          @other_mobiles = []
          @new_friends = []
        end
      end

      private
        def check_status
          render(status: 400, text: 'Incorrect status response') unless(FriendInvitation.accept_status?(params[:status]) || FriendInvitation.reject_status?(params[:status]))
        end

        def load_user_by_mobile
          render(status: 404, text: 'not found') unless(@user = User.find_by_mobile(params[:mobile]))
        end

        def load_verified_user_by_account_name
          render(status: 404, text: 'not found') unless(@user = User.verified.find_by_account_name(params[:account_name]))
        end

        def user_params
          params.require(:user).permit(:account_name, :firstname, :lastname, :country_id, :mobile)
        end
    end
  end
end