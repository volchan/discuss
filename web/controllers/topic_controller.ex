defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  plug Discuss.Plugs.RequireAuth when action in ~w(new create edit update delete)a
  plug :check_topic_owner when action in ~w(edit update delete)a

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def show(conn, %{"id" => id}) do
    topic = Repo.get!(Topic, id)
    render conn, "show.html", topic: topic
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic_params}) do
    changeset = conn.assigns.user
      |> build_assoc(:topics)
      |> Topic.changeset(topic_params)

    case Repo.insert(changeset) do
      {:ok, topic} ->
        conn
          |> put_flash(:info, "Topic created successfully")
          |> redirect(to: topic_path(conn, :show, topic))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => id}) do
    old_topic = Repo.get(Topic, id)
    changeset = Topic.changeset(old_topic)
    render conn, "edit.html", topic: old_topic, changeset: changeset, old_topic: old_topic
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    old_topic = Repo.get(Topic, id)
    changeset = Topic.changeset(old_topic, topic_params)

    case Repo.update(changeset) do
      {:ok, topic} ->
        conn
          |> put_flash(:info, "Topic updated successfully")
          |> redirect(to: topic_path(conn, :show, topic))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic, old_topic: old_topic
    end
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(Topic, id) |> Repo.delete!
    conn
      |> put_flash(:info, "Topic deleted successfully")
      |> redirect(to: topic_path(conn, :index))
  end

  defp check_topic_owner(%{params: %{"id" => topic_id}} = conn, _params) do
    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
        |> put_flash(:error, "You are not authorized to do that!")
        |> redirect(to: topic_path(conn, :index))
        |> halt()
    end
  end
end
