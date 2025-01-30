defmodule NanoShdxwWeb.StartConversationLive do
  use NanoShdxwWeb, :live_view
  alias NanoShdxw.Accounts

  @impl true
  def mount(_params, _session, socket) do
    users = Accounts.list_users() # Récupère tous les utilisateurs
    {:ok, assign(socket, users: users, selected_user_id: nil)}
  end

  @impl true
  def handle_event("start_conversation", %{"user_id" => user_id}, socket) do
    case Accounts.get_user_by_id(user_id) do
      nil ->
        {:noreply, put_flash(socket, :error, "User not found")}

      user ->
        current_user = socket.assigns.current_user
        {:noreply, push_navigate(socket, to: "/conversation/#{current_user.id}/#{user.id}")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="start-conversation">
      <h2>Start a Conversation</h2>
      <.form for={%{}} phx-submit="start_conversation">
        <label for="user_id">Select a user to chat with:</label>
        <select name="user_id" required>
          <option value="" disabled selected>Choose a user...</option>
          <%= for user <- @users do %>
            <option value={user.id}><%= user.email %></option>
          <% end %>
        </select>
        <.button type="submit">Start Conversation</.button>
      </.form>
      <%= if @flash[:error] do %>
        <p class="error"><%= @flash[:error] %></p>
      <% end %>
    </div>
    """
  end
end
