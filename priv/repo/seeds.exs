defmodule Discuss.DatabaseSeeder do
  alias Discuss.Repo
  alias Discuss.User
  alias Discuss.Topic
  alias Discuss.Comment

  def clear do
    Repo.delete_all(Comment)
    Repo.delete_all(Topic)
    Repo.delete_all(User)
  end

  def insert_user do
    username = :crypto.strong_rand_bytes(8) |> Base.url_encode64 |> binary_part(0, 8)
    email = username <> "@gmail.com"
    token = :crypto.strong_rand_bytes(20) |> Base.url_encode64 |> binary_part(0, 20)

    Repo.insert! %User{
      username: username,
      email: email,
      token: token,
      provider: "github",
      avatar: "https://avatars3.githubusercontent.com/u/466015?s=460&v=4"
    }
  end

  def insert_topic(users) do
    title = :crypto.strong_rand_bytes(30) |> Base.url_encode64 |> binary_part(0, 30)
    user = Enum.random(users)

    Repo.insert! %Topic{
      title: title,
      user: user
    }
  end

  def insert_comment(users, topics) do
    content = :crypto.strong_rand_bytes(255) |> Base.url_encode64 |> binary_part(0, 255)
    user = Enum.random(users)
    topic = Enum.random(topics)

    Repo.insert! %Comment{
      content: content,
      user: user,
      topic: topic
    }
  end
end

Discuss.DatabaseSeeder.clear

(1..5000) |> Enum.each(fn _ ->
  Discuss.DatabaseSeeder.insert_user
end)

users = Discuss.Repo.all(Discuss.User)

(1..5000) |> Enum.each(fn _ ->
  Discuss.DatabaseSeeder.insert_topic(users)
end)

topics = Discuss.Repo.all(Discuss.Topic)

(1..500000) |> Enum.each(fn _ ->
  Discuss.DatabaseSeeder.insert_comment(users, topics)
end)
