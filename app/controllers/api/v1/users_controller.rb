module Api
  module V1
    class UsersController < BaseController
      before_filter :load_user_by_mobile, only: [:resend_verification_sms, :verify, :send_friend_request, :friend_invitation_response]
      before_filter :check_status, only: :friend_invitation_response

      skip_before_filter :authorize_request, only: [:create, :check_presence, :resend_verification_sms, :verify]

      def create
        @user = User.create(user_params)
        respond_with(@user)
      end

      def check_presence
        @user_exist = User.exist_with_account_name?(params[:account_name])
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

      def friends_and_invitations
        @friends = current_user.friends
        @friend_invitations_sent_to = current_user.friend_invitations_sent_to
        @friend_invitations_received_by = current_user.friend_invitations_received_by
      end

      def friends_and_contacts
        @friends = current_user.friends
        @friend_invitations_sent_to = current_user.friend_invitations_sent_to
        @friend_invitations_received_by = current_user.friend_invitations_received_by
        total_friend_related_users = @friends + @friend_invitations_sent_to + @friend_invitations_received_by
        if(params[:mobiles].present?)
          @users = User.where.not(id: total_friend_related_users.map(&:id)).verified.with_mobiles(params[:mobiles])
        else
          @users = []
        end
        @others = params[:mobiles] - @users.map(&:mobile) - total_friend_related_users.map(&:mobile)
      end

      private
        def check_status
          render(status: 400, text: 'Incorrect status response') unless(FriendInvitation.accept_status?(params[:status]) || FriendInvitation.reject_status?(params[:status]))
        end

        def load_user_by_mobile
          render(status: 404, text: 'not found') unless(@user = User.find_by_mobile(params[:mobile]))
        end

        def user_params
          params.require(:user).permit(:account_name, :firstname, :lastname, :country_id, :mobile)
        end
    end
  end
end