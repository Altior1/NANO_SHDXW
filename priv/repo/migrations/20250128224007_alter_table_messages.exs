defmodule NanoShdxw.Repo.Migrations.CreateStartConversations do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :title, :text
      add :message_date, :utc_datetime
    end
  end
end
