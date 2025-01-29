defmodule NanoShdxwWeb.StartConversationLive do
  use NanoShdxwWeb, :live_view
  alias NanoShdxw.Accounts
  alias NanoShdxw.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :email, "")}
  end

  @impl true
  def handle_event("start_conversation", %{"email" => email}, socket) do
    case Accounts.get_user_by_email(email) do
      nil ->
        {:noreply, put_flash(socket, :error, "User not found")}

      user ->
        current_user = socket.assigns.current_user
        {:noreply, redirect(socket, to: "/conversation/#{current_user.id}/#{user.id}")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="start-conversation">
      <h2>Start a Conversation</h2>
      <form phx-submit="start_conversation">
        <label for="email">Enter the email of the user you want to chat with:</label>
        <input
          type="email"
          name="email"
          value={@email}
          placeholder="Enter email..."
          required
        />
        <button type="submit">Start Conversation</button>
      </form>
      <%= if @flash[:error] do %>
        <p class="error"><%= @flash[:error] %></p>
      <% end %>
    </div>
    """
  end
end
