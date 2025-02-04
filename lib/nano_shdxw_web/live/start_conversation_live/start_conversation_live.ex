defmodule NanoShdxwWeb.StartConversationLive do
  use NanoShdxwWeb, :live_view
  alias NanoShdxw.Accounts
  alias NanoShdxw.Messaging

  @impl true
  def mount(_params, _session, socket) do
    # Récupère tous les utilisateurs avec les messages préchargés
    users = Accounts.list_users()
    # last_message = Accounts.list_user_with_preload()
    # last_message |> IO.inspect(label: "mess")
    {:ok, assign(socket, users: users, selected_user_id: nil)}
  end

  @impl true
  def handle_event("start_conversation", %{"user_id" => user_id}, %{assigns: %{current_user: current_user}} = socket) do
    link = SecureRandom.urlsafe_base64(16)


    # Messaging.associate_users_to_topic(%{"link" => link}, [user_id] )
    Messaging.associate_users_to_topic(%{"link" => link}, [current_user.id, user_id] )
    |> IO.inspect(label: "mess")

    # case Accounts.get_user_by_id(user_id) do
    #   nil ->
    #     {:noreply, put_flash(socket, :error, "User not found")}

    #   user ->
    #     # Créez un nouveau Topic avec le lien unique
    #     case Messaging.create_topic(%{link: link}) do
    #       {:ok, topic} ->
    #         # Associez les utilisateurs au Topic
    #         Messaging.associate_users_to_topic(topic, [current_user.id, user.id])

    #         # Créez un message initial pour démarrer la conversation
    #         initial_message_content = "Conversation started!"

    #         case Messaging.create_message(%{
    #                sender_id: current_user.id,
    #                receiver_id: user.id,
    #                content: initial_message_content,
    #                link: link,
    #                topic_id: topic.id
    #              }) do
    #           {:ok, _message} ->
    #             {:noreply, push_navigate(socket, to: "/conversation/#{link}")}

    #           {:error, _changeset} ->
    #             {:noreply, put_flash(socket, :error, "Failed to create initial message")}
    #         end

    #       {:error, changeset} ->
    #         IO.inspect(changeset.errors, label: "Failed to create topic")
    #         {:noreply, put_flash(socket, :error, "Failed to start conversation")}
    #     end
    # end
    {:noreply, push_navigate(socket, to: "/conversation/#{link}")}
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
            <option value={user.id}>{user.email}</option>
          <% end %>
        </select>
        <.button type="submit">Start Conversation</.button>
      </.form>
      <%= if @flash[:error] do %>
        <p class="error">{@flash[:error]}</p>
      <% end %>
    </div>
    """
  end
end
