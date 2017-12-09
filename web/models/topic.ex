defmodule Discuss.Topic do
  use Discuss.Web, :model

  alias Discuss.{User, Comment}

  @derive {Poison.Encoder, only: ~w(title user comments)a}

  schema "topics" do
    field :title, :string
    belongs_to :user, User
    has_many :comments, Comment

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:title])
      |> validate_required([:title])
      |> unique_constraint(:title)
  end
end
