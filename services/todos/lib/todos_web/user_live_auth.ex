defmodule TodosAppWeb.UserLiveAuth do
  import Phoenix.Component
  import Phoenix.LiveView
  alias TodosAppWeb.Accounts

  def on_mount(:default, _params, %{"user_token" => user_token} = _session, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        Accounts.get_user_by_session_token(user_token)
      end)
    
    # サンプルのため、アカウントの検証は行わないのでコメントアウト
    # if socket.assigns.current_user.confirmed_at do
    #   {:cont, socket}
    # else
    #   {:halt, redirect(socket, to: "/auth/log_in")}
    # end
    {:cont, socket}
  end
end