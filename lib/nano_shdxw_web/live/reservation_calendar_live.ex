defmodule NanoShdxwWeb.ReservationCalendarLive do
  use NanoShdxwWeb, :live_view

  alias NanoShdxw.RoomReservation

  def mount(_params, _session, socket) do
    start_date = Timex.now() |> Timex.beginning_of_week()
    reservations = RoomReservation.list_reservations_for_week(start_date)
    {:ok, assign(socket, reservations: reservations, start_date: start_date)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-xl font-bold mb-4">Calendrier des Réservations</h1>
      <div>
        <.button id="zoom_day">Jour</.button>
        <.button id="zoom_week">Semaine</.button>
      </div>
      <div id="calendar" phx-hook="CalendarHook"></div>
      <br/>
      <.button phx-click="new">New Reservation</.button>
    </div>
    """
  end

  def handle_event("new", _params, socket) do
    {:noreply, push_navigate(socket, to: "/reservations/new")}
  end
end
