defmodule NanoShdxwWeb.ReservationCalendar do
  use NanoShdxwWeb, :live_view

  alias NanoShdxw.RoomReservation

  def mount(_params, _session, socket) do
    start_date = Timex.now() |> Timex.beginning_of_week()
    reservations = RoomReservation.list_reservations_for_week(start_date)
    {:ok, assign(socket, reservations: reservations, start_date: start_date)}
  end

  def render(assigns) do
    ~H"""
    <div id="calendar"></div>

    <script>
      document.addEventListener('DOMContentLoaded', function() {
      var calendarEl = document.getElementById('calendar');

      var calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: 'timeGridWeek',
      events: function(fetchInfo, successCallback, failureCallback) {
        fetch(`/reservations_calendar/week?start_date=${fetchInfo.startStr}`)
          .then(response => {
            if (!response.ok) {
              throw new Error('Failed to fetch events');
            }
            return response.json();
          })
          .then(data => successCallback(data))
          .catch(error => {
            console.error('Error fetching events:', error);
            failureCallback(error);
          });
      }
      });

      calendar.render();
      });
    </script>
    """
  end
end
