defmodule NanoShdxw.Repo.Migrations.CreateStartConversations do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :link, :text
    end
  end
end
