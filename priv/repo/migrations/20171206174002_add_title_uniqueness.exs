defmodule Discuss.Repo.Migrations.AddTitleUniqueness do
  use Ecto.Migration

  def change do
    create unique_index(:topics, [:title])
  end
end
