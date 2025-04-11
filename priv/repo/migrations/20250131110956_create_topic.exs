defmodule NanoShdxw.Repo.Migrations.CreateTopic do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :id_message, :integer
      add :id_user, :integer
      add :titre, :string
      add :link, :string

      timestamps(type: :utc_datetime)
    end
  end
end
