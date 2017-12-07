defmodule Discuss.User do
  use Discuss.Web, :model

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    field :username, :string
    field :avatar, :string
    has_many :topics, Discuss.Topic
    has_many :comments, Discuss.Comment

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
