defmodule NanoShdxwWeb.ReservationLive.Index do
  use NanoShdxwWeb, :live_view

  alias NanoShdxw.RoomReservation
  alias NanoShdxw.RoomReservation.Reservation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :reservations, RoomReservation.list_reservations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Reservation")
    |> assign(:reservation, RoomReservation.get_reservation!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Reservation")
    |> assign(:reservation, %Reservation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Reservations")
    |> assign(:reservation, nil)
  end

  @impl true
  def handle_info({NanoShdxwWeb.ReservationLive.FormComponent, {:saved, reservation}}, socket) do
    {:noreply, stream_insert(socket, :reservations, reservation)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    reservation = RoomReservation.get_reservation!(id)
    {:ok, _} = RoomReservation.delete_reservation(reservation)

    {:noreply, stream_delete(socket, :reservations, reservation)}
  end
end
