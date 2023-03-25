defmodule TodosApp.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodosApp.Todos` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        name: "some name",
        status: "some status"
      })
      |> TodosApp.Todos.create_task()

    task
  end
end
