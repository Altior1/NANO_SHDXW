defmodule NanoShdxw.RoomReservation.Reservation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reservations" do
    field :starting_date, :utc_datetime
    field :ending_date, :utc_datetime
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reservation, attrs) do
    reservation
    |> cast(attrs, [:starting_date, :ending_date])
    |> validate_required([:starting_date, :ending_date])
  end
end
