defmodule NanoShdxw.Repo.Migrations.AddTopicIdToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :topic_id, references(:topics, on_delete: :nothing)
    end

    create index(:messages, [:topic_id])
  end
end
