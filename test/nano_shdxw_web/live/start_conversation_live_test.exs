defmodule NanoShdxwWeb.StartConversationLiveTest do
  use NanoShdxwWeb.ConnCase

  import Phoenix.LiveViewTest
  import NanoShdxw.MessagingFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_start_conversation(_) do
    start_conversation = start_conversation_fixture()
    %{start_conversation: start_conversation}
  end

  describe "Index" do
    setup [:create_start_conversation]

    test "lists all start_conversations", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/start_conversations")

      assert html =~ "Listing Start conversations"
    end

    test "saves new start_conversation", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/start_conversations")

      assert index_live |> element("a", "New Start conversation") |> render_click() =~
               "New Start conversation"

      assert_patch(index_live, ~p"/start_conversations/new")

      assert index_live
             |> form("#start_conversation-form", start_conversation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#start_conversation-form", start_conversation: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/start_conversations")

      html = render(index_live)
      assert html =~ "Start conversation created successfully"
    end

    test "updates start_conversation in listing", %{
      conn: conn,
      start_conversation: start_conversation
    } do
      {:ok, index_live, _html} = live(conn, ~p"/start_conversations")

      assert index_live
             |> element("#start_conversations-#{start_conversation.id} a", "Edit")
             |> render_click() =~
               "Edit Start conversation"

      assert_patch(index_live, ~p"/start_conversations/#{start_conversation}/edit")

      assert index_live
             |> form("#start_conversation-form", start_conversation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#start_conversation-form", start_conversation: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/start_conversations")

      html = render(index_live)
      assert html =~ "Start conversation updated successfully"
    end

    test "deletes start_conversation in listing", %{
      conn: conn,
      start_conversation: start_conversation
    } do
      {:ok, index_live, _html} = live(conn, ~p"/start_conversations")

      assert index_live
             |> element("#start_conversations-#{start_conversation.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#start_conversations-#{start_conversation.id}")
    end
  end

  describe "Show" do
    setup [:create_start_conversation]

    test "displays start_conversation", %{conn: conn, start_conversation: start_conversation} do
      {:ok, _show_live, html} = live(conn, ~p"/start_conversations/#{start_conversation}")

      assert html =~ "Show Start conversation"
    end

    test "updates start_conversation within modal", %{
      conn: conn,
      start_conversation: start_conversation
    } do
      {:ok, show_live, _html} = live(conn, ~p"/start_conversations/#{start_conversation}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Start conversation"

      assert_patch(show_live, ~p"/start_conversations/#{start_conversation}/show/edit")

      assert show_live
             |> form("#start_conversation-form", start_conversation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#start_conversation-form", start_conversation: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/start_conversations/#{start_conversation}")

      html = render(show_live)
      assert html =~ "Start conversation updated successfully"
    end
  end
end
