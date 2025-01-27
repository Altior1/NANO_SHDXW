defmodule NanoShdxwWeb.ReservationApiController do
  use NanoShdxwWeb, :controller

  alias NanoShdxw.RoomReservation

  def week(conn, %{"start_date" => start_date}) do
    case Timex.parse(start_date, "{YYYY}-{0M}-{0D}") do
      {:ok, parsed_date} ->
        reservations = RoomReservation.list_reservations_for_week(parsed_date)

        # Convert reservations to FullCalendar event format
        events = Enum.map(reservations, fn reservation ->
          %{
            id: reservation.id,
            title: reservation.title,
            start: reservation.starting_date,
            end: reservation.ending_date
          }
        end)

        json(conn, events)

      {:error, _reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid date format"})
    end
  end
end
