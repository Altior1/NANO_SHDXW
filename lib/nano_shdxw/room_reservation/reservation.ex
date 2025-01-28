defmodule NanoShdxw.RoomReservation.Reservation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reservations" do
    field :starting_date, :utc_datetime
    field :ending_date, :utc_datetime

    belongs_to :user, NanoShdxw.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reservation, attrs) do
    reservation
    |> cast(attrs, [:starting_date, :ending_date, :user_id])
    |> validate_required([:starting_date, :ending_date, :user_id])
  end
end
