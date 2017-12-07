defmodule Discuss.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :provider, :string
      add :token, :string
      add :username, :string
      add :avatar, :string

      timestamps()
    end

    create unique_index(:users, [:email, :token, :username])
  end
end
