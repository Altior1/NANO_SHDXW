defmodule NanoShdxwWeb.TopicLiveTest do
  use NanoShdxwWeb.ConnCase

  import Phoenix.LiveViewTest
  import NanoShdxw.MessagingFixtures

  @create_attrs %{link: "some link", id_message: 42, id_user: 42, titre: "some titre"}
  @update_attrs %{
    link: "some updated link",
    id_message: 43,
    id_user: 43,
    titre: "some updated titre"
  }
  @invalid_attrs %{link: nil, id_message: nil, id_user: nil, titre: nil}

  defp create_topic(_) do
    topic = topic_fixture()
    %{topic: topic}
  end

  describe "Index" do
    setup [:create_topic]

    test "lists all topic", %{conn: conn, topic: topic} do
      {:ok, _index_live, html} = live(conn, ~p"/topic")

      assert html =~ "Listing Topic"
      assert html =~ topic.link
    end

    test "saves new topic", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/topic")

      assert index_live |> element("a", "New Topic") |> render_click() =~
               "New Topic"

      assert_patch(index_live, ~p"/topic/new")

      assert index_live
             |> form("#topic-form", topic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#topic-form", topic: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/topic")

      html = render(index_live)
      assert html =~ "Topic created successfully"
      assert html =~ "some link"
    end

    test "updates topic in listing", %{conn: conn, topic: topic} do
      {:ok, index_live, _html} = live(conn, ~p"/topic")

      assert index_live |> element("#topic-#{topic.id} a", "Edit") |> render_click() =~
               "Edit Topic"

      assert_patch(index_live, ~p"/topic/#{topic}/edit")

      assert index_live
             |> form("#topic-form", topic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#topic-form", topic: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/topic")

      html = render(index_live)
      assert html =~ "Topic updated successfully"
      assert html =~ "some updated link"
    end

    test "deletes topic in listing", %{conn: conn, topic: topic} do
      {:ok, index_live, _html} = live(conn, ~p"/topic")

      assert index_live |> element("#topic-#{topic.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#topic-#{topic.id}")
    end
  end

  describe "Show" do
    setup [:create_topic]

    test "displays topic", %{conn: conn, topic: topic} do
      {:ok, _show_live, html} = live(conn, ~p"/topic/#{topic}")

      assert html =~ "Show Topic"
      assert html =~ topic.link
    end

    test "updates topic within modal", %{conn: conn, topic: topic} do
      {:ok, show_live, _html} = live(conn, ~p"/topic/#{topic}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Topic"

      assert_patch(show_live, ~p"/topic/#{topic}/show/edit")

      assert show_live
             |> form("#topic-form", topic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#topic-form", topic: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/topic/#{topic}")

      html = render(show_live)
      assert html =~ "Topic updated successfully"
      assert html =~ "some updated link"
    end
  end
end
