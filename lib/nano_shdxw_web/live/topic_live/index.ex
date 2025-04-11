defmodule NanoShdxwWeb.TopicLive.Index do
  use NanoShdxwWeb, :live_view

  alias NanoShdxw.Messaging
  alias NanoShdxw.Messaging.Topic

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :topic_collection, Messaging.list_topic())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Topic")
    |> assign(:topic, Messaging.get_topic!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Topic")
    |> assign(:topic, %Topic{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Topic")
    |> assign(:topic, nil)
  end

  @impl true
  def handle_info({NanoShdxwWeb.TopicLive.FormComponent, {:saved, topic}}, socket) do
    {:noreply, stream_insert(socket, :topic_collection, topic)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    topic = Messaging.get_topic!(id)
    {:ok, _} = Messaging.delete_topic(topic)

    {:noreply, stream_delete(socket, :topic_collection, topic)}
  end
end
