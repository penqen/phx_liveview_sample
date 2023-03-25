defmodule TodosAppWeb.PageController do
  use TodosAppWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
