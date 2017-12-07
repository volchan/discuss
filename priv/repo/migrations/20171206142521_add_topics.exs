defmodule Discuss.Repo.Migrations.AddTopics do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :title, :string
      add :user_id, references(:users)

      timestamps()
    end

    create unique_index(:topics, [:title])
  end
end
