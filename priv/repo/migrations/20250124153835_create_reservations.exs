defmodule NanoShdxw.Repo.Migrations.CreateReservations do
  use Ecto.Migration

  def change do
    create table(:reservations) do
      add :starting_date, :utc_datetime
      add :ending_date, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:reservations, [:user_id])
  end
end
