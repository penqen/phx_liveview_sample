defmodule TodosApp.Todos.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias TodosApp.Accounts.User

  schema "tasks" do
    field :name, :string
    field :status, :string, default: "todo"
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :status])
    |> cast_assoc(:user)
    |> validate_required([:name, :status])
  end
end
