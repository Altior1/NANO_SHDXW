defmodule NanoShdxw.Repo.Migrations.CreateStartConversations do
  use Ecto.Migration

  def change do
    create table(:start_conversations) do

      timestamps(type: :utc_datetime)
    end
  end
end
