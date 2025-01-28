defmodule NanoShdxwWeb.ReservationApiController do
  use NanoShdxwWeb, :controller
  alias NanoShdxw.RoomReservation
  alias NanoShdxw.Repo

  @spec events(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def events(conn, _params) do
    # Récupération des réservations dans la base de données
    reservations = RoomReservation.list_reservations()
    |> Repo.preload(:user)

    # Transformer les réservations en un format compatible avec FullCalendar
    events =
      Enum.map(reservations, fn reservation ->
        %{
          id: reservation.id,
          start: DateTime.to_iso8601(reservation.starting_date),
          end: DateTime.to_iso8601(reservation.ending_date),
          user_id: reservation.user_id,
          user_email: reservation.user.email
        }
      end)

    # Retourner les données JSON
    json(conn, events)
  end
end
