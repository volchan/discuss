defmodule Discuss.User do
  use Discuss.Web, :model

  alias Discuss.{Topic, Comment}

  @derive {Poison.Encoder, only: ~w(username avatar)a}

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    field :username, :string
    field :avatar, :string
    has_many :topics, Topic
    has_many :comments, Comment

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:email, :provider, :token, :username, :avatar])
      |> validate_required([:email, :provider, :token, :username, :avatar])
      |> unique_constraint(:email)
      |> unique_constraint(:token)
      |> unique_constraint(:username)
  end
end
