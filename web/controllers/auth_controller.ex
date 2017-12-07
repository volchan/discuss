defmodule Discuss.AuthController do
  use Discuss.Web, :controller

  alias Discuss.User

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider}) do
    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email,
      username: auth.info.nickname,
      avatar: auth.info.urls.avatar_url,
      provider: provider
    }

    changeset = User.changeset(%User{}, user_params)
    signin(conn, changeset)
  end

  def signout(conn, _params) do
    conn
     |> configure_session(drop: true)
     |> put_flash(:info, "Signed out successfully")
     |> redirect(to: topic_path(conn, :index))
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
         |> put_flash(:info, "Signed in successfully")
         |> put_session(:user_id, user.id)
         |> redirect(to: topic_path(conn, :index))
      {:error, _reason} ->
        conn
         |> put_flash(:error, "Error signing in")
         |> redirect(to: topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil -> Repo.insert(changeset)
      user -> {:ok, user}
    end
  end
end
