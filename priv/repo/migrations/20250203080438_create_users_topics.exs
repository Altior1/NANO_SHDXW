defmodule NanoShdxw.Repo.Migrations.CreateUsersTopics do
  use Ecto.Migration

  def change do
    create table(:users_topics, primary_key: false) do
      add :user_id, references(:users)
      add :topic_id, references(:topics)
    end

    create unique_index(:users_topics, [:user_id, :topic_id])
  end
end
