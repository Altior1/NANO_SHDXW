defmodule NanoShdxwWeb.ReservationLive.FormComponent do
  use NanoShdxwWeb, :live_component

  alias NanoShdxw.RoomReservation

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage reservation records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="reservation-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:starting_date]} type="datetime-local" label="Starting date" />
        <.input field={@form[:ending_date]} type="datetime-local" label="Ending date" />
        <.input field={@form[:user_id]} type="hidden" value={@current_user.id} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Reservation</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
def update(assigns, socket) do
  socket =
  socket
  |> assign(assigns)
  |> assign_new(:form, fn ->
    to_form(RoomReservation.change_reservation(assigns.reservation))
  end)

  {:ok, socket}
end

  @impl true
  def handle_event("validate", %{"reservation" => reservation_params}, socket) do
    changeset = RoomReservation.change_reservation(socket.assigns.reservation, reservation_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"reservation" => reservation_params}, socket) do
    save_reservation(socket, socket.assigns.action, reservation_params)
  end

  defp save_reservation(socket, :edit, reservation_params) do
    case RoomReservation.update_reservation(socket.assigns.reservation, reservation_params) do
      {:ok, reservation} ->
        notify_parent({:saved, reservation})

        {:noreply,
         socket
         |> put_flash(:info, "Reservation updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_reservation(socket, :new, reservation_params) do
    case RoomReservation.create_reservation(reservation_params) do
      {:ok, reservation} ->
        notify_parent({:saved, reservation})

        {:noreply,
         socket
         |> put_flash(:info, "Reservation created successfully")
         |> redirect(to: "/reservations_calendar")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
