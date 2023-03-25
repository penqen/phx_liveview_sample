defmodule TodosApp.Repo do
  use Ecto.Repo,
    otp_app: :todos,
    adapter: Ecto.Adapters.MyXQL
end
